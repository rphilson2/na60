global class ABPerformDepositBatchable extends ABEntities implements Database.Batchable<ABDepositCalloutInputParams>, Database.AllowsCallouts {

    @TestVisible private class BatchableException extends Exception {}
    
    @testVisible
    private static Boolean forceTestingException = false;
    
    @testVisible
    private IABOrchestrator orchestrator = new ABOrchestrator();

    List<ABDepositCalloutInputParams> items = new List<ABDepositCalloutInputParams>();

    global ABPerformDepositBatchable(List<ABDepositCalloutInputParams> items) {this.items = items;}

    global Iterable<ABDepositCalloutInputParams> start(Database.BatchableContext bc) {
        return (Iterable<ABDepositCalloutInputParams>)this.items;
    }
    
    global void execute(Database.BatchableContext BC, List<ABDepositCalloutInputParams> items){
        List<ABEntities.AutomatedBookingResponse> resArr = new List<ABEntities.AutomatedBookingResponse>();
        
        for(ABDepositCalloutInputParams c : items){
        
            ABEntities.AutomatedBookingResponse res = new ABEntities.AutomatedBookingResponse();
            try{
                if(forceTestingException)
                    throw new BatchableException('forceTestingException');
                res = orchestrator.BookDeposit(c.depositId, c.requestedByUserId, c.userSessionId, c.externalReferenceId, ABUtility.ParseKeyValuePairs(c.additionalProperties));
            } catch(Exception ex) {
                res.Messages = String.format(System.Label.ABSendServiceOrchestrationException, 
                    new String[]{
                        System.Label.DepositBooking,
                        ex.getMessage()
                    });
            }  
            
            resArr.add(res);

        }
        
        System.debug(resArr);
        
    }
    global void finish(Database.BatchableContext BC){}
    
}