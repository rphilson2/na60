global class ABTransactionLogInvocable extends ABEntities {
    
    @InvocableMethod(label='Update Transaction Log' description='Updates the specified transaction log')
    global static void updateLog(List<ABTransactionLogInputParams> inputParams) {
        ABPerformTransactionLogBatchable myBatch = new ABPerformTransactionLogBatchable(inputParams);
        Database.executeBatch(myBatch);
    }
    
}