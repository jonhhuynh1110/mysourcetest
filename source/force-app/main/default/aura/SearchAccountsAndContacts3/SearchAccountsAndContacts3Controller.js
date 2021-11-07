({
	doSearch: function(component, event, helper) {
        var searchField = component.find('searchField');
        var isValueMissing = searchField.get('v.validity').valueMissing;
        if(isValueMissing) {
            searchField.showHelpMessageIfInvalid();
            searchField.focus();
        }else{
            helper.searchHelper(component, event);
        }
    },
    
    doIncrementCounter: function(component, event, helper) {
        var searchResult = component.get("v.searchResult");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var tmpRecord = searchResult[index];
        if(tmpRecord.recordType == 'Account') {
            helper.updateData(component, event, searchResult, index);
        } else {
            helper.updateData(component, event, searchResult, index);
        }
    },
})