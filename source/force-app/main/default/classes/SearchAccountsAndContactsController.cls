public with sharing class SearchAccountsAndContactsController {
	@AuraEnabled
	public static List<Data> fetchData(String searchKeyWord) {
        List<Data> lstDataReturn = new List<Data>();
        try {
            String searchKey = searchKeyWord + '%';
            Data tmpData;
            for (Account tmpAccount : [Select id, Name, Counter__c From Account Where Name LIKE: searchKey LIMIT 500]) {
                tmpData = new Data();
                tmpData.recordId 	= tmpAccount.Id;
                tmpData.recordName 	= tmpAccount.Name;
                tmpData.counter 	= tmpAccount.Counter__c != null ? Integer.valueOf(tmpAccount.Counter__c) : 0;
                tmpData.recordType 	= 'Account';
                lstDataReturn.add(tmpData);
            }
            
            for (Contact tmpContact : [Select id, Name, Counter__c From Contact Where Name LIKE: searchKey LIMIT 500]) {
                tmpData = new Data();
                tmpData.recordId 	= tmpContact.Id;
                tmpData.recordName 	= tmpContact.Name;
                tmpData.counter 	= tmpContact.Counter__c != null ? Integer.valueOf(tmpContact.Counter__c) : 0;
                tmpData.recordType 	= 'Contact';
                lstDataReturn.add(tmpData);
            }
            
        } catch (Exception ex) {
            throw new AuraHandledException('Internal Server Error. Please contact administrator!!!');
        }
        return lstDataReturn;
        
    }
    @AuraEnabled
	public static void updateRecordData(String recordId, Integer counter, String typeObject) {
        try {
            if (typeObject == 'Account') {
                Account tmpAccount = new Account(Id = recordId , Counter__c = counter + 1);
                update tmpAccount;
            } else {
                Contact tmpContact = new Contact(Id = recordId, Counter__c = counter + 1);
                update tmpContact;
            }
            
        } catch (DmlException e) {
            String messageError = '';
            for (Integer i = 0; i < e.getNumDml(); i++) {
                messageError =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(messageError);
        }
    }
    
    public class Data {
        @AuraEnabled public String recordId;
        @AuraEnabled public String recordName;
        @AuraEnabled public String recordType;
        @AuraEnabled public Integer counter;
        public Data(){
            this.recordId      = null;
            this.recordName    = null;
            this.recordType    = null;
            this.counter       = null;
        }
    }
}