global class ABNonBatchLoanRenewalInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Loan Renewal (Non-Batch)' description='Renews the loan provided in the input on behalf of the user specified to the Core.')
    global static List<AutomatedBookingResponse> renewLoan(List<ABNonBatchLoanCalloutInputParams> inputParams) {
        
        List<AutomatedBookingResponse> responseList = new List<AutomatedBookingResponse>();
        
        ABOrchestrator orchestrator = new ABOrchestrator();
        
        for(ABNonBatchLoanCalloutInputParams c : inputParams){
            
            responseList.add(orchestrator.RenewLoan(c.loanId, null, null, c.externalReferenceId, ABUtility.ParseKeyValuePairs(c.additionalProperties)));
            
        }
        
        return responseList;
        
    }
    
}