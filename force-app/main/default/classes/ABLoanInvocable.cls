global class ABLoanInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Loan' description='Books the loan provided in the input on behalf of the user specified to the Core.')
    global static void bookLoan(List<ABLoanCalloutInputParams> inputParams) {
        ABPerformLoanBatchable myBatch = new ABPerformLoanBatchable(inputParams);
        Database.executeBatch(myBatch);
    }
    
}