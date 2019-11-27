global class ABLoanRenewalInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Loan Renewal' description='Renews the loan provided in the input on behalf of the user specified to the Core.')
    global static void renewLoan(List<ABLoanCalloutInputParams> inputParams) {
        ABPerformLoanRenewalBatchable myBatch = new ABPerformLoanRenewalBatchable(inputParams);
        Database.executeBatch(myBatch);
    }
    
}