@RestResource(urlMapping='/v1/MyService/Contact/*')
global  class WebserviceContact {
    private static Integer responseStatusCode;
    private static String message;
    @HttpPatch
    global static void patch() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        List<ApplicationResponseMsg> lstmsg = new List<ApplicationResponseMsg>();
        try {
            String jsonBody = request.requestBody.toString().trim();
            System.debug(jsonBody);
            if (String.isNotBlank(jsonBody)) {
                List<Contact> lstContact = (List<Contact>)JSON.deserialize(jsonBody , List<Contact>.Class);
                System.debug(lstContact);
                Database.SaveResult[] srList = Database.update(lstContact, false);
                ApplicationResponseMsg msg;
                for (Database.SaveResult sr : srList) {
                    msg = new ApplicationResponseMsg();
                    if (sr.isSuccess()) {
                        msg.ID 		= sr.getId();
                        msg.Status 	= 'Success';
                    }
                    else {
                        msg.ID 		=  '';
                        msg.Status 	= 'Error';
                        for(Database.Error err : sr.getErrors()) {
                            msg.Message += JSON.serialize(err);
                        }
                    }
                    lstmsg.add(msg);
                }
                message = JSON.serialize(lstmsg);
            } else {
                responseStatusCode = 400;
                message = 'The body is Null !';
            }
        } catch (Exception ex) {
            responseStatusCode = 500;
            message = ex.getMessage();            
        } finally {
            response.statusCode = responseStatusCode;
            response.responseBody = Blob.valueOf(message);
        }
    }
}