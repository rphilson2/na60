global class ABNonBatchCustomerInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Customer (Non-Batch)' description='Books the customer provided in the input on behalf of the user specified to the Core.')
    global static List<AutomatedBookingResponse> bookCustomer(List<ABNonBatchCustomerCalloutInputParams> inputParams) {
        
        List<AutomatedBookingResponse> responseList = new List<AutomatedBookingResponse>();
        
        ABOrchestrator orchestrator = new ABOrchestrator();
        
        for(ABNonBatchCustomerCalloutInputParams c : inputParams){
            
            responseList.add(orchestrator.BookCustomer(c.relationshipId, null, null, c.externalReferenceId, ABUtility.ParseKeyValuePairs(c.additionalProperties)));
            
        }
        
        return responseList;
        
    }
    
}