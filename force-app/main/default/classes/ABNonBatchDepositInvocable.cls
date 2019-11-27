global class ABNonBatchDepositInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Deposit (Non-Batch)' description='Books the deposit provided in the input on behalf of the user specified to the Core.')
    global static List<AutomatedBookingResponse> bookDeposit(List<ABNonBatchDepositCalloutInputParams> inputParams) {
        
        List<AutomatedBookingResponse> responseList = new List<AutomatedBookingResponse>();
        
        ABOrchestrator orchestrator = new ABOrchestrator();
        
        for(ABNonBatchDepositCalloutInputParams c : inputParams){
            
            responseList.add(orchestrator.BookDeposit(c.depositId, null, null, c.externalReferenceId, ABUtility.ParseKeyValuePairs(c.additionalProperties)));
            
        }
        
        return responseList;
        
    }
    
}