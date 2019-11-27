@isTest()
private class TestABEntities{
    
    @isTest
	private static void TestEntities() {
	    
	    ABEntities.ABLoanCalloutInputParams result1 = new ABEntities.ABLoanCalloutInputParams();
	    result1.loanId = '';
	    result1.externalReferenceId = '';
	    result1.additionalProperties = new List<String>{ 'property1|propertyvalue1' };
	    System.assertEquals(true, String.isBlank(result1.loanId));
	    
	    ABEntities.ABCustomerCalloutInputParams result2 = new ABEntities.ABCustomerCalloutInputParams();
	    result2.relationshipId = '';
	    result2.externalReferenceId = '';
	    result2.additionalProperties = new List<String>{ 'property1|propertyvalue1' };
	    System.assertEquals(true, String.isBlank(result2.relationshipId));
	    
	    ABEntities.ABDepositCalloutInputParams result3 = new ABEntities.ABDepositCalloutInputParams();
	    result3.depositId = '';
	    result3.externalReferenceId = '';
	    result3.additionalProperties = new List<String>{ 'property1|propertyvalue1' };
	    System.assertEquals(true, String.isBlank(result3.depositId));
	    
	    ABEntities.AutomatedBookingResponse result4 = new ABEntities.AutomatedBookingResponse();
	    result4.Messages = '';
	    result4.IsSuccessful = true;
	    result4.pendingBatch = true;
        List<String> enrollmentStatuses = new List<String>();
	    enrollmentStatuses.add('abc@phony.com' + ',' + true);
	    result4.enrollmentStatuses = enrollmentStatuses;
	    result4.TransactionLogExternalId = '';
	    System.assertEquals(true, result4.IsSuccessful);
	    
	    ABEntities.TransactionLogResponse result5 = new ABEntities.TransactionLogResponse();
	    result5.ObjectId = '';
        result5.Details = '';
	    result5.IsComplete = true;
	    result5.VendorStatus = '';
	    result5.Status = '';
	    result5.ExternalId = '';
	    result5.IsSuccessful = true;
	    System.assertEquals(true, result5.IsComplete);
        
        //rjp start
        ABEntities.CompoundTransactionLogResponse result5b = new ABEntities.CompoundTransactionLogResponse();
        result5b.ObjectId = '';
	    result5b.ExternalId = '';
	    result5b.Details = '';
	    result5b.Status = '';
	    result5b.VendorStatus = '';
	    result5b.IsComplete = true;
	    result5b.IsSuccessful = true;
        result5b.bookCustomerButtonEnabled = false;
        result5b.bookDepositButtonEnabled = false;
        result5b.renewLoanButtonEnabled = false;
        result5b.modifyLoanButtonEnabled = false;
        result5b.reserveLoanButtonEnabled = false;
        result5b.bookToCoreButtonEnabled = false;
        
	    System.assertEquals(true, result5b.IsComplete);
	    //rjp stop
	    
	    ABEntities.ABNonBatchLoanCalloutInputParams result6 = new ABEntities.ABNonBatchLoanCalloutInputParams();
	    result6.loanId = '';
	    result6.externalReferenceId = '';
	    result6.additionalProperties = new List<String>{ 'property1|propertyvalue1' };
	    System.assertEquals(true, String.isBlank(result6.loanId));
	    
	    ABEntities.ABNonBatchCustomerCalloutInputParams result7 = new ABEntities.ABNonBatchCustomerCalloutInputParams();
	    result7.relationshipId = '';
	    result7.externalReferenceId = '';
	    result7.additionalProperties = new List<String>{ 'property1|propertyvalue1' };
	    System.assertEquals(true, String.isBlank(result7.relationshipId));
	    
	    ABEntities.ABNonBatchDepositCalloutInputParams result8 = new ABEntities.ABNonBatchDepositCalloutInputParams();
	    result8.depositId = '';
	    result8.externalReferenceId = '';
	    result8.additionalProperties = new List<String>{ 'property1|propertyvalue1' };
	    System.assertEquals(true, String.isBlank(result8.depositId));
	    
	    
	    
	}
	
}