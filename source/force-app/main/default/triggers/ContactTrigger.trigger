trigger ContactTrigger on Contact (before insert, after insert, before update, after update, after undelete, after delete) {
	if ( Trigger.isAfter ) {
        List<Contact> contactList = new List<Contact> ();
        Set<Id> accountIdsSet = new Set<Id>();
        if ( Trigger.isDelete ) {
            contactList = Trigger.Old;
        } else {
            contactList = Trigger.New;
        }
        
        for ( Contact con : contactList ) {
            if (con.AccountId != null ){
                accountIdsSet.add(con.AccountId);
            }
            if ( Trigger.isUpdate ) {
                Contact oldContact = (Contact)Trigger.oldMap.get(con.Id);
                if ( oldContact.AccountId != con.AccountId ) {
                    accountIdsSet.add(oldContact.AccountId);
                }
            }
            
        }
        
        List<Account> accountList = [Select Id, Name, Total_Contacts__c, (Select Id, Name, Active__c From Contacts Where Active__c = true)
                                    From Account Where Id IN : accountIdsSet];
        for (Account acc : accountList) {
            List<Contact> relatedContacts = acc.Contacts;
            if ( relatedContacts != null ){
                acc.Total_Contacts__c = relatedContacts.size();
            } else {
                acc.Total_Contacts__c = 0;
            }
        }
        update accountList;
    }
}