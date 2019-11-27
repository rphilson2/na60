global class ABLoanModificationInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Loan Modification' description='Modifies the loan provided in the input on behalf of the user specified to the Core.')
    global static void modifyLoan(List<ABLoanCalloutInputParams> inputParams) {
        ABPerformLoanModificationBatchable myBatch = new ABPerformLoanModificationBatchable(inputParams);
        Database.executeBatch(myBatch);
    }
    
}