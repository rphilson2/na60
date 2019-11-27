global class ABNonBatchLoanModificationInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Loan Modification (Non-Batch)' description='Modifies the loan provided in the input on behalf of the user specified to the Core.')
    global static List<AutomatedBookingResponse> modifyLoan(List<ABNonBatchLoanCalloutInputParams> inputParams) {
        
        List<AutomatedBookingResponse> responseList = new List<AutomatedBookingResponse>();
        
        ABOrchestrator orchestrator = new ABOrchestrator();
        
        for(ABNonBatchLoanCalloutInputParams c : inputParams){
            
            responseList.add(orchestrator.ModifyLoan(c.loanId, null, null, c.externalReferenceId, ABUtility.ParseKeyValuePairs(c.additionalProperties)));
            
        }
        
        return responseList;
        
    }
    
}