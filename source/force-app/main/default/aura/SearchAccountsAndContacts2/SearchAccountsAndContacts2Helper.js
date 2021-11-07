({
    searchHelper: function(component, event) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var action = component.get("c.fetchData");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword")
        });
        action.setCallback(this, function(response) {
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    this.fireToast('Error', 'Error', "No Records Found...");
                }
                component.set("v.TotalNumberOfRecord", storeResponse.length);
                component.set("v.searchResult", storeResponse); 
                
            }else if (state === "INCOMPLETE") {
                this.fireToast('Error', 'Error', 'Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.fireToast(state, 'Error', errors[0].message);
                    }
                } else {
                    this.fireToast(state, 'Error', "Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fireToast : function(type, message, title) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: type.toLowerCase(),
            title,
            message
        });
        toastEvent.fire();
    }
})