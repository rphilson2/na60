trigger reparentContacts on Contact (after insert) {

    List<Contact> unparentedContacts = [SELECT id, DUNS_Number__c
                                        FROM Contact 
                                        WHERE (isoSourceRecordTypeId__c = '01236000000AUAU' OR recordTypeId = '012a0000001ZVUv')
                                        AND id = :Trigger.newMap.keySet()];



        Map<Id, String> dunsNumbers = new Map<Id, String>();
        for(Contact cont : [SELECT id, DUNS_Number__c 
                            FROM Contact
                            WHERE id 
                            IN :unparentedContacts]){
                         
        dunsNumbers.put(cont.id, cont.DUNS_Number__c);
        }
        
        
        Map<String, Id> parentAccounts = new Map<String, Id>();
        for(Account acct : [SELECT DUNS_Number__c, id 
                         FROM Account 
                         WHERE DUNS_Number__c IN :dunsNumbers.values()]){
                         
        parentAccounts.put(acct.DUNS_Number__c, acct.id);
        }


        for(Contact cont : unparentedContacts) {
                cont.accountId = parentAccounts.get(cont.DUNS_Number__c);
                cont.RecordTypeId = '012a0000001ZVUv';
        }
 
        update unparentedContacts;
    

}