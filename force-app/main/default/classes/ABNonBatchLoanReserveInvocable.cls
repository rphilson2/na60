global class ABNonBatchLoanReserveInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Loan Reserve (Non-Batch)' description='Obtains a reserved loan id for the loan provided in the input on behalf of the user specified to the Core.')
    global static List<AutomatedBookingResponse> reserveLoan(List<ABNonBatchLoanCalloutInputParams> inputParams) {
        
        List<AutomatedBookingResponse> responseList = new List<AutomatedBookingResponse>();
        
        ABOrchestrator orchestrator = new ABOrchestrator();
        
        for(ABNonBatchLoanCalloutInputParams c : inputParams){
            
            responseList.add(orchestrator.reserveLoan(c.loanId, null, null, c.externalReferenceId, ABUtility.ParseKeyValuePairs(c.additionalProperties)));
            
        }
        
        return responseList;
        
    }
    
}