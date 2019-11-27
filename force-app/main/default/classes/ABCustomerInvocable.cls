global class ABCustomerInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Customer' description='Books the customer provided in the input on behalf of the user specified to the Core.')
    global static void bookCustomer(List<ABCustomerCalloutInputParams> inputParams) {
        ABPerformCustomerBatchable myBatch = new ABPerformCustomerBatchable(inputParams);
        Database.executeBatch(myBatch);
    }
    
}