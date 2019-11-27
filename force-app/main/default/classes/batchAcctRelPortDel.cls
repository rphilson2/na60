public class batchAcctRelPortDel implements Database.Batchable<sObject> {
    public String query;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<FNNI_Account_Relationship_Portal__c> portalRecs) {
        delete portalRecs;
        Database.emptyRecycleBin(portalRecs);
    }
    
    public void finish(Database.BatchableContext bc){
    }
}