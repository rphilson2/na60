public interface IABOrchestrator {
	Boolean PerformBatchUpdateTransactionLog(String transactionLogExternalId, String status, String transactionDetail, String vendorStatus);
	Boolean QueueBatchUpdateTransactionLog(String transactionLogExternalId, String status, String transactionDetail, String vendorStatus);
	String GetReservedLoanNumberByLoanId(String loanId);
	String GetBookedLoanNumberByLoanId(String loanId, Boolean clean, String delimiter);
	
	ABEntities.TransactionLogResponse GetTransactionLogDetails(String externalId);
	ABEntities.AutomatedBookingResponse ReserveLoan(String loanId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties);
	ABEntities.AutomatedBookingResponse BookLoan(String loanId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties);
	ABEntities.AutomatedBookingResponse RenewLoan(String loanId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties);
	ABEntities.AutomatedBookingResponse ModifyLoan(String loanId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties);
	ABEntities.AutomatedBookingResponse BookCustomer(String relationshipId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties);
	ABEntities.AutomatedBookingResponse BookDeposit(String depositId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties);
	
	String GetConfigValue(String configLookupKey);
	Map<String,Object> GetBookingMessage(String type, String loanPropertyKey, Id objectId);
	Boolean StringContainsConfigValue(String stringToTest, String configLookupKey);
	
	Map<String,String> GetMessageConstants();
	
}