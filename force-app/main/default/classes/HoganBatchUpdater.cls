@RestResource(urlMapping='/applications/*')
global with sharing class HoganBatchUpdater {
    
    @HttpPut
    global static void updateSalesforce(Boolean bookAccountSuccessful, 
    	String accountType, String accountToken, List<String> infoMessages, List<Customer> accountHolder) {
            
        RestRequest request = RestContext.request;
        
        // grab the application ID from the end of the URL
        Id applicationId = request.requestURI.substring(
              request.requestURI.lastIndexOf('/') +1);

        // lookup information from context, user, and account based on application id
        List<nPortal__Context__c> ctxlist = selectSalesforceContext(applicationId);
        
        // get the deposit id based on the application id and update the deposit record with the accountToken
        String userId = null;
		if (ctxlist.size() > 0) {
			userId = ctxlist[0].nPortal__User__c;
        }
        Id depositId = updateDeposit(applicationId, accountToken, userId);
        
        // update the context record with the correct account booking status
        // this will trigger the correct email to the customer (e.g. success, falure, enrollment failed)
        updateContextUserAccount(ctxlist, bookAccountSuccessful, accountHolder, depositId, applicationId,
			accountToken, accountType, infoMessages);
    }
    
    @testVisible
    private static List<nPortal__Context__c> selectSalesforceContext(Id applicationId) {
	
        // Lookup information from context, user, and account based on application id
		List<nPortal__Context__c> ctxlist = new List<nPortal__Context__c>([
			SELECT 
                Id
                , nPortal__User__c
                , nPortal__User__r.FederationIdentifier 
                , nPortal__User__r.AccountId
				, nPortal__User__r.Account.FNB_System_of_record_id__c
			FROM nPortal__Context__c
			WHERE nPortal__Application__c = :applicationId
		]);
        
        return ctxList;
    }
    
    @testVisible
    private static Id updateDeposit(Id applicationId, String accountToken, String userId) {
	
        // Lookup the deposit id from the application id
		Id depositId = [
			SELECT 
                Id
			FROM LLC_BI__Deposit__c
			WHERE LLC_BI__Application__c = :applicationId
            LIMIT 1
		].Id;
        
        // update deposit if list is not empty (should not happen)
        if (depositId != null) {
            updateDepositLookupKey(depositId, accountToken, userID);
        }
        
        return depositId;
    }

    @testVisible
    private static void updateDepositLookupKey(Id depositId, String accountToken, String userId) {
 
        LLC_BI__Deposit__c deposit = new LLC_BI__Deposit__c(
            id = depositId,
            LLC_BI__lookupKey__c = accountToken
        );
        
        // attempt to update the deposit record and write a transaction detail if it fails for duplicate lookup key
        String transactionDetail = null;
        try {
			update deposit;
        } catch (Exception e) {
            transactionDetail = '- Deposit update failed for depositId: ' + depositId + ' - for account token: ' 
                + accountToken + '- with error: ' + e.getMessage();
        }
            
        // write transaction log if there was a failure
        writeFailureTranLog(transactionDetail, userId, depositId);
        
    }
    
    // Update context record(s) with the account booking status based on whether the booking was successful and the enrollment failed
    @testVisible
   	private static void updateContextUserAccount(List<nPortal__Context__c> ctxlist, boolean bookAccountSuccessful, 
		List<Customer> customers, Id depositId, Id applicationId, String accountToken, String accountType, List<String> infoMessages) {

        List<nPortal__Context__c> contextsToUpdate = new List<nPortal__Context__c>();
        List<User> usersToUpdate = new List<User>();
        List<Account> accountsToUpdate = new List<Account>();
        List<nFUSE__Transaction_Log__c> tranLogsToInsert = new List<nFUSE__Transaction_Log__c>();
        Id userId;
        for (nPortal__Context__c ctxRecord : ctxlist) {
           	// update context record with correct values and add to list
            ctxRecord.nPortal__Context_Complete__c = Datetime.now();
            if (isFailedEnrollment(customers, ctxRecord.nPortal__User__r.FederationIdentifier)) {
                ctxRecord.Account_Booking_Status__c = 'EnrollmentFailed';
            } else {
                ctxRecord.Account_Booking_Status__c = bookAccountSuccessful ? 'Success' : 'Failure';
            }
            contextsToUpdate.add(ctxRecord);
            
            // determine if user record should be updated and add to list when applicable
            // save the user Id in case of issues updating/inserts to Salesforce - it doesn't matter which one for co-owner
            userId = ctxRecord.nPortal__User__c;
            User userRecord = determineUpdateUser(customers, 
				ctxRecord.nPortal__User__r.FederationIdentifier, ctxRecord.nPortal__User__c);
            if (userRecord != null) {
                usersToUpdate.add(userRecord);
                
                // if userRecord is not null, account also should be updated
                Account accountRecord = determineUpdateAccount(ctxRecord.nPortal__User__r.Account.FNB_System_of_record_id__c, 
                	userRecord.federationIdentifier, ctxRecord.nPortal__User__r.AccountId);
                if (accountRecord != null) {
                    accountsToUpdate.add(accountRecord);
                }
            }
            
            // insert transaction log
			tranLogsToInsert.add(buildTranLog(bookAccountSuccessful, ctxRecord.nPortal__User__c, depositId, 
				applicationId, customers, accountToken, accountType, infoMessages));
        }
            
        // do updates / inserts - handle any errors
       	persistInformation(contextsToUpdate, usersToUpdate, accountsToUpdate, tranLogsToInsert, userId, depositId, applicationId);
    }

  	// Do updates/inserts to Salesforce
    @testVisible
	private static void persistInformation(List<nPortal__Context__c> contextsToUpdate, List<User> usersToUpdate,
		List<Account> accountsToUpdate, List<nFUSE__Transaction_Log__c> tranLogsToInsert, Id userId, Id depositId, Id applicationId) {

		String transactionDetail = '';
            
        if (contextsToUpdate.size() > 0) {
            try {
				update contextsToUpdate;
            } catch (Exception e) {
                transactionDetail += '- Context update failed for application id: ' + applicationId + '- with error: '  + e.getMessage();
            }
		}
       	if (usersToUpdate.size() > 0) {
            try {
				update usersToUpdate;
            } catch (Exception e) {
                transactionDetail += '- User update failed for application id: ' + applicationId 
                    + '- with error: '  + e.getMessage();
            }
		}
       	if (accountsToUpdate.size() > 0) {
            try {
				update accountsToUpdate;
            } catch (Exception e) {
                transactionDetail += '- Account update failed for application id: ' + applicationId + '- with error: '  + e.getMessage();
            }
		}
       	if (tranLogsToInsert.size() > 0) {
            try {
				insert tranLogsToInsert;
            } catch (Exception e) {
                transactionDetail += '- Insert tran log failed for application id: ' + applicationId + '- with error: '  + e.getMessage();
            }
		}
            
        // write transaction log if there was a failure
        writeFailureTranLog(transactionDetail, userId, depositId);
    }
    
    // write failure transaction detail
    @testVisible
    private static void writeFailureTranLog(String transactionDetail, String userId, String depositId) {
        // if transactionDetail is not empty, write a tranlog
        if (String.isNotEmpty(transactionDetail)) {
            System.debug('BATCH UPDATE FAILURE: ' + transactionDetail);
      		String vendorStatus = 'failure';
        	String transactionStatus = 'In Progress';
        	insert createTranLog(userId, depositId, 'BATCH UPDATE FAILURE: ' + transactionDetail, transactionStatus, vendorStatus);
        }
    }
    
  	// Determine if the current customer record had a failed enrollment
    @testVisible
	private static Boolean isFailedEnrollment(List<Customer> customers, String federationIdentifier) {

        Boolean failedEnrollment = false;
        for (Customer customer : customers) {
            if (customer.oldFederatedId == federationIdentifier) {
            	failedEnrollment = customer.failedEnrollment;
            	break;
            }
        }
        return failedEnrollment;
    }

  	// Determine if user federated id should be updated in user
    @testVisible
	private static User determineUpdateUser(List<Customer> customers, String federationIdentifier, Id userId) {

        User userRecord = null;
        for (Customer customer : customers) {
            String updatedFederatedId = customer.updatedFederatedId;
            
            // find the matching federated ID in the response so the right record is updated
	    	// if the updated federated ID is NOT equal to the old federated Id
	    	// and the updated federated ID ends in @fnbo.com meaning that enrollment worked and the CIXF ID was returned
	    	// update "FederationIdentifier" in the User record(s)if (customer.oldFederatedId == federationIdentifier) {
            if (updatedFederatedId != null
		    	&& federationIdentifier ==  customer.oldFederatedId
		    	&& customer.oldFederatedId !=  updatedFederatedId
		    	&& updatedFederatedId.endsWith('@fnbo.com')) {
                    userRecord = new User(
            			id = userId,
            			federationIdentifier = updatedFederatedId
        			);
            		break;
            }
        }
        return userRecord;
    }

  	// Determine value to update Account with for FNB System of Record ID
    @testVisible
	private static Account determineUpdateAccount(String fnbSystemOfRecordId, String updatedFederatedId, Id accountId) {
        
        Account accountRecord = null;
        // update accounts(s) if the current FNB system of record id is NOT populated
        if (fnbSystemOfRecordId == null) {
            // strip the @fnbo.com so just the customer token (CIXF ID) is updated in Account
            String updatedFnbSystemOfRecordId = updatedFederatedId.substring(0,
		    	updatedFederatedId.indexOf('@fnbo.com'));
			accountRecord = new Account(
				id = accountId,
				FNB_System_of_record_id__c = updatedFnbSystemOfRecordId
			);
        }
        
        return accountRecord;
        
    }

  	// Create a tran log for the booking
    @testVisible
	private static nFUSE__Transaction_Log__c buildTranLog(boolean bookAccountSuccessful, Id userId, Id depositId, 
		Id applicationId, List<Customer> customers, String accountToken, String accountType, List<String> infoMessages) {

		String transactionStatus;
        String transactionDetail;
        if (bookAccountSuccessful) {
            transactionStatus = 'Done';
            transactionDetail = formatSuccessTranDetail(customers, applicationId, 
					accountToken, accountType, infoMessages);
    	} else {
            transactionStatus = 'In Progress';
            transactionDetail = formatFailureTranDetail(applicationId, accountType, infoMessages);
        }
        
        // create tran log object
        String vendorStatus = 'DepositBooked';
        nFUSE__Transaction_Log__c tranLog = createTranLog(userId, depositId, transactionDetail, transactionStatus, vendorStatus);
            
		return tranLog;
    }

  	// Create a tran log for the booking
    @testVisible
	private static nFUSE__Transaction_Log__c createTranLog(Id userId, Id depositId, 
		String transactionDetail, String transactionStatus, String vendorStatus) {
        
        nFUSE__Transaction_Log__c tranLog = new nFUSE__Transaction_Log__c(
            nFUSE__External_Id__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(40),
            nFUSE__Action__c = PLUGIN_ACTION, 
            nFUSE__Api_Version__c = PLUGIN_VERSION, 
            nFUSE__App_Plugin__c = PLUGIN_NAME, 
            nFUSE__Primary_Object_Id__c = depositId, 
            nFUSE__Requested_By_User_Id__c = userId,
            OwnerId = userId,
           	nFUSE__Transaction_Detail__c = transactionDetail,
            nFUSE__Transaction_Status__c = transactionStatus,
            nFUSE__Vendor_Status__c = vendorStatus
        );
            
		return tranLog;
    }

  	// Format transaction log detail for success
    @testVisible
	private static String formatSuccessTranDetail(List<Customer> customers, Id applicationId, 
		String accountToken, String accountType, List<String> infoMessages) {
	
		List<String> strs = new List<String>();
            
        strs.add('Batch Book Account Response: ');
		strs.add('SUCCESS ');
		strs.add(' - Customer Information: ');
		strs.add(' - ');

		for (Customer customer : customers) {
	    	strs.add('old federated id: ');
	    	strs.add(customer.oldFederatedId);
	   	 	strs.add(' - ');
	    	strs.add('updated federated id: ');
	    	strs.add(customer.updatedFederatedId);
	    	strs.add(' - ');
	    	strs.add('failed enrollment: ');
	    	strs.add(String.valueOf(customer.failedEnrollment));
	    	strs.add(' - ');
		}

		strs.add('app id: ');
		strs.add(applicationId);
		strs.add(' - ');
		strs.add('account number: ');
		strs.add(accountToken);
		strs.add(' - ');
		strs.add('account type: ');
		strs.add(accountType);
		strs.add(' - ');
        strs.add('info message(s): ');
		for (String info : infoMessages) {
			strs.add(' - ');
			strs.add(info);
        }
        
        return String.join(strs, '');
    }

  	// Format transaction log detail for failure
    @testVisible
	private static String formatFailureTranDetail(Id applicationId, String accountType, List<String> infoMessages) {

		List<String> strs = new List<String>();

        strs.add('Batch Book Account Response: ');
        strs.add('FAILED');
        strs.add(' - ');
        strs.add('app id: ');
        strs.add(applicationId);
        strs.add(' - ');
        strs.add('account type: ');
        strs.add(accountType);
        strs.add(' - ');
        strs.add('info message(s): ');
		for (String info : infoMessages) {
			strs.add(' - ');
			strs.add(info);
        }
        
        return String.join(strs, '');
    }
    
	global class Customer {
        global String oldFederatedId {get;set;}
        global String updatedFederatedId {get;set;}
        global boolean failedEnrollment {get;set;}
    }
    
    @testVisible
    private static String 
        PLUGIN_NAME = 'AutomatedBooking',
        PLUGIN_VERSION = '1.0.0.0',
        PLUGIN_ACTION = 'book_deposit';

}