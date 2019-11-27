global class ABNonBatchLoanInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Loan (Non-Batch)' description='Books the loan provided in the input on behalf of the user specified to the Core.')
    global static List<AutomatedBookingResponse> bookLoan(List<ABNonBatchLoanCalloutInputParams> inputParams) {
        
        List<AutomatedBookingResponse> responseList = new List<AutomatedBookingResponse>();
        
        ABOrchestrator orchestrator = new ABOrchestrator();
        
        for(ABNonBatchLoanCalloutInputParams c : inputParams){
            
            responseList.add(orchestrator.BookLoan(c.loanId, null, null, c.externalReferenceId, ABUtility.ParseKeyValuePairs(c.additionalProperties)));
            
        }
        
        return responseList;
        
    }
    
}