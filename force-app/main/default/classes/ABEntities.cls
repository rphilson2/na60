global with sharing virtual class ABEntities {
    
    global class AutomatedBookingResponse {
        @invocableVariable(label = 'Messages'
            description = 'Response messages from the booking activity.')
        global String Messages;
        @invocableVariable(label = 'IsSuccessful'
            description = 'Indicates if the activity was successful or not.')
        global Boolean IsSuccessful;
        @invocableVariable(label = 'pendingBatch'
            description = 'Indicates if book account is pending batch completion.')
        global Boolean pendingBatch;
        @invocableVariable(
			required = false
			label = 'List of old federated Ids | failed enrollment statuses'
			description = 'List of comma delimited key value pairs (ex. "key|value"). Values can ONLY be strings, not complex objects as they will not be converted.'
		)
		global List<String> enrollmentStatuses;
        @invocableVariable(label = 'TransactionLogExternalId'
            description = 'The transaction external identifier for the activity.')
        global String TransactionLogExternalId;
    }
    
    global class TransactionLogResponse {
        global String ObjectId {get;set;}
        global String ExternalId {get;set;}
        global String Details {get;set;}
        global String Status {get;set;}
        global String VendorStatus {get;set;}
        global Boolean IsComplete {get;set;}
        global Boolean IsSuccessful {get;set;}
    }
    
    global class CompoundTransactionLogResponse {
        global String ObjectId {get;set;}
        global String ExternalId {get;set;}
        global String Details {get;set;}
        global String Status {get;set;}
        global String VendorStatus {get;set;}
        global Boolean IsComplete {get;set;}
        global Boolean IsSuccessful {get;set;}
        //states used for UI
        global Boolean bookCustomerButtonEnabled { get; set; }
    	global Boolean bookDepositButtonEnabled { get; set; }
    	global Boolean renewLoanButtonEnabled { get; set; }
    	global Boolean modifyLoanButtonEnabled { get; set; }
    	global Boolean reserveLoanButtonEnabled { get; set; }
    	global Boolean bookToCoreButtonEnabled { get; set; }
    }
    
    //batch callout input parameters
    
    global class ABLoanCalloutInputParams {
        
        @invocableVariable(required = true
            label = 'loanId'
            description = 'Is the Salesforce loan id to be used for the context base for the loan booking.')
        global String loanId;
        
        @invocableVariable(required = true
            label = 'userSessionId'
            description = 'Is the users session id since the future callout will not have context of that through batch.')
        global String userSessionId;
        
        @invocableVariable(required = false
            label = 'requestedByUserId'
            description = 'Is the user id requesting the log to be created - used only during the log creation.')
        global String requestedByUserId;
        
        @invocableVariable(required = false
            label = 'externalReferenceId'
            description = 'Is the external reference id for the log that has been created as a placeholder for the flow, leave blank if you do not require it for your flow use')
        global String externalReferenceId;
        
        @invocableVariable(
			required = false
			label = 'Key Value List'
			description = 'List of pipe delimited key value pairs (ex. "key|value"). Values can ONLY be strings, not complex objects as they will not be converted.'
		)
		global List<String> additionalProperties;
        
    }
    global class ABCustomerCalloutInputParams {
        
        @invocableVariable(required = true
            label = 'relationshipId'
            description = 'Is the Salesforce relationship id (Account Id) to be used for the context base for the customer booking.')
        global String relationshipId;
        
        @invocableVariable(required = true
            label = 'userSessionId'
            description = 'Is the users session id since the future callout will not have context of that through batch.')
        global String userSessionId;
        
        @invocableVariable(required = false
            label = 'requestedByUserId'
            description = 'Is the user id requesting the log to be created - used only during the log creation.')
        global String requestedByUserId;
        
        @invocableVariable(required = false
            label = 'externalReferenceId'
            description = 'Is the external reference id for the log that has been created as a placeholder for the flow, leave blank if you do not require it for your flow use')
        global String externalReferenceId;
        
        @invocableVariable(
			required = false
			label = 'Key Value List'
			description = 'List of pipe delimited key value pairs (ex. "key|value"). Values can ONLY be strings, not complex objects as they will not be converted.'
		)
		global List<String> additionalProperties;
        
    }
    global class ABDepositCalloutInputParams {
        
        @invocableVariable(required = true
            label = 'depositId'
            description = 'Is the Salesforce deposit id to be used for the context base for the deposit booking.')
        global String depositId;
        
        @invocableVariable(required = true
            label = 'userSessionId'
            description = 'Is the users session id since the future callout will not have context of that through batch.')
        global String userSessionId;
        
        @invocableVariable(required = false
            label = 'requestedByUserId'
            description = 'Is the user id requesting the log to be created - used only during the log creation.')
        global String requestedByUserId;
        
        @invocableVariable(required = false
            label = 'externalReferenceId'
            description = 'Is the external reference id for the log that has been created as a placeholder for the flow, leave blank if you do not require it for your flow use')
        global String externalReferenceId;
        
        @invocableVariable(
			required = false
			label = 'Key Value List'
			description = 'List of pipe delimited key value pairs (ex. "key|value"). Values can ONLY be strings, not complex objects as they will not be converted.'
		)
		global List<String> additionalProperties;
        
    }
    
    
    
    
    
    //non batch callout input parameters
    global class ABNonBatchLoanCalloutInputParams {
        
        @invocableVariable(required = true
            label = 'loanId'
            description = 'Is the Salesforce loan id to be used for the context base for the loan booking.')
        global String loanId;
        
        @invocableVariable(required = false
            label = 'externalReferenceId'
            description = 'Is the external reference id for the log that has been created as a placeholder for the flow, leave blank if you do not require it for your flow use')
        global String externalReferenceId;
        
        @invocableVariable(
			required = false
			label = 'Key Value List'
			description = 'List of pipe delimited key value pairs (ex. "key|value"). Values can ONLY be strings, not complex objects as they will not be converted.'
		)
		global List<String> additionalProperties;
        
    }
    global class ABNonBatchCustomerCalloutInputParams {
        
        @invocableVariable(required = true
            label = 'relationshipId'
            description = 'Is the Salesforce relationship id (Account Id) to be used for the context base for the customer booking.')
        global String relationshipId;
        
        @invocableVariable(required = false
            label = 'externalReferenceId'
            description = 'Is the external reference id for the log that has been created as a placeholder for the flow, leave blank if you do not require it for your flow use')
        global String externalReferenceId;
        
        @invocableVariable(
			required = false
			label = 'Key Value List'
			description = 'List of pipe delimited key value pairs (ex. "key|value"). Values can ONLY be strings, not complex objects as they will not be converted.'
		)
		global List<String> additionalProperties;
        
    }
    global class ABNonBatchDepositCalloutInputParams {
        
        @invocableVariable(required = true
            label = 'depositId'
            description = 'Is the Salesforce deposit id to be used for the context base for the deposit booking.')
        global String depositId;
        
        @invocableVariable(required = false
            label = 'externalReferenceId'
            description = 'Is the external reference id for the log that has been created as a placeholder for the flow, leave blank if you do not require it for your flow use')
        global String externalReferenceId;
        
        @invocableVariable(
			required = false
			label = 'Key Value List'
			description = 'List of pipe delimited key value pairs (ex. "key|value"). Values can ONLY be strings, not complex objects as they will not be converted.'
		)
		global List<String> additionalProperties;
        
    }
    
    
    global class ABTransactionLogInputParams {
        
        @invocableVariable(required = true
            label = 'ExternalId'
            description = 'Is external id of the transaction log to update')
        global String ExternalId;
        
        @invocableVariable(required = false
            label = 'TransactionDetails'
            description = 'The transaction details')
        global String TransactionDetails;
        
        @invocableVariable(required = false
            label = 'Status'
            description = 'The Status to update the log to')
        global String Status;
        
        @invocableVariable(required = false
            label = 'VendorStatus'
            description = 'The Vendor Status to update the log to')
        global String VendorStatus;
        
        
    }
}