global class ABDepositInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Deposit' description='Books the deposit provided in the input on behalf of the user specified to the Core.')
    global static void bookDeposit(List<ABDepositCalloutInputParams> inputParams) {
        ABPerformDepositBatchable myBatch = new ABPerformDepositBatchable(inputParams);
        Database.executeBatch(myBatch);
    }
    
}