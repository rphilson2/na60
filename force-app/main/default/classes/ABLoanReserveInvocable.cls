global class ABLoanReserveInvocable extends ABEntities {
    
    @InvocableMethod(label='Automated Booking - Loan Reservation' description='Obtains a reserved loan id for the loan provided in the input on behalf of the user specified to the Core.')
    global static void reserveLoan(List<ABLoanCalloutInputParams> inputParams) {
        ABPerformLoanReserveBatchable myBatch = new ABPerformLoanReserveBatchable(inputParams);
        Database.executeBatch(myBatch);
    }
    
}