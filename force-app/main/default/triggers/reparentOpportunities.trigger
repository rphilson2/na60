trigger reparentOpportunities on Opportunity (after insert) {

    List<Opportunity> unparentedOpportunities = [SELECT id, connectionReceivedId 
                                             FROM Opportunity 
                                             WHERE isoSourceRecordTypeId__c = '01236000000AeGv' 
                                             AND id = :Trigger.newMap.keySet()];



        set<String> dunsNumbers = new set<String>();
        for(Opportunity opp : [SELECT id, isoSourceDunsNumber__c 
                         FROM Opportunity 
                         WHERE id 
                         IN :unparentedOpportunities]){
                         
        dunsNumbers.add(opp.isoSourceDunsNumber__c);
        }
        
        
        set<String> parentAccounts = new set<String>();
        for(Account acct : [SELECT id 
                         FROM Account 
                         WHERE DUNS_Number__c IN :dunsNumbers]){
                         
        parentAccounts.add(acct.id);
        }


        for(Opportunity opp : unparentedOpportunities) {
            for(String acct : parentAccounts){
                opp.accountId = acct;
                opp.RecordTypeId = '012a0000001ZVX6';
        }}
 
        update unparentedOpportunities;
    

}