global class ABPerformTransactionLogBatchable extends ABEntities implements Database.Batchable<ABTransactionLogInputParams>, Database.AllowsCallouts {

    @TestVisible private class BatchableException extends Exception {}
    
    @testVisible
    private static Boolean forceTestingException = false;
    @testVisible
    private IABOrchestrator orchestrator = new ABOrchestrator();
    
    List<ABTransactionLogInputParams> items = new List<ABTransactionLogInputParams>();

    global ABPerformTransactionLogBatchable(List<ABTransactionLogInputParams> items) {this.items = items;}

    global Iterable<ABTransactionLogInputParams> start(Database.BatchableContext bc) {
        return (Iterable<ABTransactionLogInputParams>)this.items;
    }
    
    global void execute(Database.BatchableContext BC, List<ABTransactionLogInputParams> items){
        
        for(ABTransactionLogInputParams c : items){
        
            try{
                orchestrator.PerformBatchUpdateTransactionLog(c.ExternalId, c.Status, c.TransactionDetails, c.VendorStatus);
            } catch(Exception ex) {
                throw new BatchableException(ex.getMessage());
            }  

        }
        
    }
    global void finish(Database.BatchableContext BC){}
    
}