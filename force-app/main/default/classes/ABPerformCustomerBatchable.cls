global class ABPerformCustomerBatchable extends ABEntities implements Database.Batchable<ABCustomerCalloutInputParams>, Database.AllowsCallouts {

    @TestVisible private class BatchableException extends Exception {}
    
    @testVisible
    private static Boolean forceTestingException = false;
    
    @testVisible
    private IABOrchestrator orchestrator = new ABOrchestrator();

    List<ABCustomerCalloutInputParams> items = new List<ABCustomerCalloutInputParams>();

    global ABPerformCustomerBatchable(List<ABCustomerCalloutInputParams> items) {this.items = items;}

    global Iterable<ABCustomerCalloutInputParams> start(Database.BatchableContext bc) {
        return (Iterable<ABCustomerCalloutInputParams>)this.items;
    }
    
    global void execute(Database.BatchableContext BC, List<ABCustomerCalloutInputParams> items){
        List<ABEntities.AutomatedBookingResponse> resArr = new List<ABEntities.AutomatedBookingResponse>();
        
        for(ABCustomerCalloutInputParams c : items){
        
            ABEntities.AutomatedBookingResponse res = new ABEntities.AutomatedBookingResponse();
            try{
                if(forceTestingException)
                    throw new BatchableException('forceTestingException');
                res = orchestrator.BookCustomer(c.relationshipId, c.requestedByUserId, c.userSessionId, c.externalReferenceId, ABUtility.ParseKeyValuePairs(c.additionalProperties));
            } catch(Exception ex) {
                res.Messages = String.format(System.Label.ABSendServiceOrchestrationException, 
                    new String[]{
                        System.Label.CustomerBooking,
                        ex.getMessage()
                    });
            }  
            
            resArr.add(res);

        }
        
        System.debug(resArr);
        
    }
    global void finish(Database.BatchableContext BC){}
    
}