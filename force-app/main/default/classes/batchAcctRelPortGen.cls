public class batchAcctRelPortGen implements Database.batchable<sObject> {
    
    public String query;
    public List<FNNI_Account_Relationship_Portal__c> portalRecs = new List<FNNI_Account_Relationship_Portal__c>();
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);        
    }
    
    public void genPortalRecs(Database.BatchableContext bc, List<Account> forwardAccounts) {
        
    }
    
    public void execute(Database.BatchableContext bc, List<Account> forwardAccounts) {
        for(Account acct : forwardAccounts) {
            FNNI_Account_Relationship_Portal__c portalRec = new FNNI_Account_Relationship_Portal__c(
            Name__c = acct.Name,
            Card_Relationship__c = acct.Current_Card_Relationship__c,
            CTS_Relationship__c = acct.Current_CTS_Relationship__c,
          //Current_Relationship__c = acct.Current_Relationship__c,   DAG 08/07/2018 Remove this field... it is no longer needed. ADS ticket ADS0003026
            Insurance_Relationship__c = acct.Current_Insurance_Relationship__c,
            Lauritzen_Relationship__c = acct.Current_Lauritzen_Relationship__c,
            Lending_Relationship__c = acct.Current_Lending_Relationship__c,
            Owner_Full_Name__c = acct.Owner_Full_Name__c,
            Wealth_Relationship__c = acct.Current_Wealth_Account__c);
            portalRecs.add(portalRec);
        }
        insert portalRecs;
    }
    
    public void finish(Database.BatchableContext bc) {
        
    }
}