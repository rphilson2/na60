global class ABPerformLoanModificationBatchable extends ABEntities implements Database.Batchable<ABLoanCalloutInputParams>, Database.AllowsCallouts {

    @TestVisible private class BatchableException extends Exception {}
    
    @testVisible
    private static Boolean forceTestingException = false;
    
    @testVisible
    private IABOrchestrator orchestrator = new ABOrchestrator();

    List<ABLoanCalloutInputParams> items = new List<ABLoanCalloutInputParams>();

    global ABPerformLoanModificationBatchable(List<ABLoanCalloutInputParams> items) {this.items = items;}

    global Iterable<ABLoanCalloutInputParams> start(Database.BatchableContext bc) {
        return (Iterable<ABLoanCalloutInputParams>)this.items;
    }
    
    global void execute(Database.BatchableContext BC, List<ABLoanCalloutInputParams> items){
        List<ABEntities.AutomatedBookingResponse> resArr = new List<ABEntities.AutomatedBookingResponse>();
        
        for(ABLoanCalloutInputParams c : items){
        
            ABEntities.AutomatedBookingResponse res = new ABEntities.AutomatedBookingResponse();
            try{
                if(forceTestingException)
                    throw new BatchableException('forceTestingException');
                res = orchestrator.ModifyLoan(c.loanId, c.requestedByUserId, c.userSessionId, c.externalReferenceId, ABUtility.ParseKeyValuePairs(c.additionalProperties));
            } catch(Exception ex) {
                res.Messages = String.format(System.Label.ABSendServiceOrchestrationException, 
                    new String[]{
                        System.Label.LoanModification,
                        ex.getMessage()
                    });
            }  
            
            resArr.add(res);

        }
        
        System.debug(resArr);
        
    }
    global void finish(Database.BatchableContext BC){}
    
}