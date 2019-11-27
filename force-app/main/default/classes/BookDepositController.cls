public without sharing class BookDepositController {
    
    public class BookDepositController_Exception extends Exception {}
    
    public class ReturnDetails{
        public String status;
        public String url;
    }
    
    public static ReturnDetails sendRequest(Id appIdString, String mockCalloutResponse){
        Id applicationId = (ID) appIdString;
        String ip;
        String calloutResponse;
        if(Test.isRunningTest()){
            ip = '127.0.0.1';
	        calloutResponse = mockCalloutResponse;
        } else {
	        ip = Auth.SessionManagement.getCurrentSession().get('SourceIp');
            calloutResponse = SUCCESS;
        }
        ID userId = Userinfo.getUserId();
        Boolean existingCustomer = false;
        
        // variable to hold information to write to the transaction log for any failures 
        // that prevent book account from happening
        String transactionLogDetail = null;
        String contextId = null;
        
        // Get the context Id from the application and current user....
        String strObjAPIName = (applicationId).getSObjectType().getDescribe().getName();
        if(strObjAPIName == 'LLC_BI__Application__c'){

            // Find the context record to update when the integration completes.
            List<nPortal__Context__c> Ctxlist = new List<nPortal__Context__c>([
                SELECT 
                Id
                , nPortal__User__c
                , nPortal__User__r.FirstName
                , nPortal__User__r.AccountID
                , nPortal__User__r.ContactID
                , nPortal__User__r.Contact.Applicant_is_Existing_Customer__c
                , nPortal__User__r.FederationIdentifier 
                , SourceIP__c 
                , nPortal__Application__r.nPortal__Artifact_Id__c
                , nPortal__Application__r.nPortal__Status__c
                , Account_Booking_Status__c
                , PreciseIdDecision__c
                , QualifileDecision__c
                FROM nPortal__Context__c
                WHERE nPortal__User__c = :userId
                AND nPortal__Application__c = :applicationId
                ORDER BY nPortal__Context_Start__c DESC NULLS LAST 
                LIMIT 1
            ]);
            
            if(ctxList.size() > 0){
                nPortal__Context__c ctxItem = ctxList[0];
                existingCustomer = (ctxItem.nPortal__User__r.FederationIdentifier.right(EXISTING_CUSTOMER_FI_SUFFIX.length())==EXISTING_CUSTOMER_FI_SUFFIX);
                Id artifactId = (Id) ctxItem.nPortal__Application__r.nPortal__Artifact_Id__c;
                contextId = ctxItem.Id;
                String accountBookingStatus = ctxItem.Account_Booking_Status__c;
                if(ctxItem.nPortal__Application__r.nPortal__Status__c == ID_VERIFICATION_DEPOSIT_FAIL_STATUS){
                    transactionLogDetail = 'The application failed in a prior step and cannot be booked.';
                    calloutResponse = System.Label.ApplicationFailed; //'The application failed in a prior step and cannot be booked.';
                // do not allow book account if the application status on the context record is not empty
                // this means that the page has been submitted more than once
                // this logic will not prevent 100% of multi submit issues but will catch most - there is a small chance of 
                // two bookings happening if a customer hit refresh very quickly after submitting the application
                } else if (String.isNotEmpty(accountBookingStatus)) {
                    transactionLogDetail = 'Multi submit issue occurred.  Application was in the following status when multi submit occurred: ' + accountBookingStatus + '.';
                    // show the same "success" page that the customer saw before the multiple submit happened
                    // the customer will not get more than one email if this happens since the following code only updates the message on the page
                    switch on accountBookingStatus {
                        when 'Success' {
                    		calloutResponse = SUCCESS;
                        }
                        when 'PendingBatch' {
                    		calloutResponse = PENDING;
                        }
                        when 'EnrollmentFailed' {
                    		calloutResponse = FAILED_ENROLLMENT;
                        }
                        when 'AgreementFailed' {
                    		calloutResponse = AGREEMENT_FAILED;
                        }
                   		// if not "successful", show generic "failure" message
                        when else {
                    		calloutResponse = System.Label.BookingAlreadySubmitted; // The application was already submitted for booking
                        }
                    }
                } else {
                    if(artifactId != null && artifactId.getSObjectType().getDescribe().getName() == 'LLC_BI__Deposit__c'){
                        String depositId = (String) artifactId;
                        List<LLC_BI__Deposit__c> depositList = new List<LLC_BI__Deposit__c>([
                            SELECT 
                              ID
                            , LLC_BI__lookupKey__c 
                            , Online_Application_Booking_Errors__c
                            , CreatedBy.Account.Special_Code__pc
							, LLC_BI__Deposit__c.Name
							, CreatedBy.Account.a_Anticipated_Wire_Activity_c__c
							, CreatedBy.Account.a_Send_Receive_International_Wires__c
							, CreatedBy.Account.a_Other_Anticipated_International_Activi__c
							, CreatedBy.Account.LLC_BI__Identity_Verification_Status__pc
                            FROM LLC_BI__Deposit__c
                            WHERE id = :depositId
                            LIMIT 1
                        ]);
                        if(depositList.size()>0) {
                            if(depositList[0].LLC_BI__lookupKey__c == null && depositList[0].Online_Application_Booking_Errors__c == null){
                                // Determine how many agreements where checked for the application
                                Integer agreementCount = 
                                    [SELECT count() 
                                        FROM nFORCE__Route_Agreement__c 
                                        WHERE nPortal__Application__c = :applicationId
                                        and nFORCE__Agreed__c = true];
    
                                // there are a minimum of 8 agreements that must be accepted before book account can be done
                                // three on the first page and the remaining agreements on the review and submit page
                                Integer requiredAgreements = 8;
                                // premier checking has one more agreement shown on the review and submit page
                                if (depositList[0].Name == 'Premier Checking') {
                                    requiredAgreements += 1;
                                }
                                // if there is a special code, one more agreement will be shown on the review and submit page
                                String specialCode = depositList[0].CreatedBy.Account.Special_Code__pc;
                                if (specialCode != null && String.isNotEmpty(specialCode)) {
                                    requiredAgreements += 1;
                                }
								// check to see if the customer is net new and then make sure they passed precise id, qualifile, and IDology (Identity Verification Status) 
								// and they have entered something on the three required activity drops down from account activity before allowing book account to be done
								// this logic is to prevent book account from happening when a customer gets past the page validation due to the "Next" button not working correctly
								Boolean customerFlowCorrect = false;
								if (ctxItem.nPortal__User__r.FederationIdentifier.right(EXISTING_CUSTOMER_FI_SUFFIX.length()) != EXISTING_CUSTOMER_FI_SUFFIX) {
									if (ctxItem.PreciseIdDecision__c == true 
									&& ctxItem.QualifileDecision__c == true
									&& depositList[0].CreatedBy.Account.a_Anticipated_Wire_Activity_c__c != null
									&& depositList[0].CreatedBy.Account.a_Send_Receive_International_Wires__c != null
									&& depositList[0].CreatedBy.Account.a_Other_Anticipated_International_Activi__c != null
									&& depositList[0].CreatedBy.Account.LLC_BI__Identity_Verification_Status__pc == 'Pass') {
										customerFlowCorrect = true;
                                    } else {
                                        // add information to transaction log variable for logging at end
                                        transactionLogDetail = '';
                                        if (ctxItem.PreciseIdDecision__c != true 
                                            || ctxItem.QualifileDecision__c != true) {
                                            transactionLogDetail += 'Booking did not occur because ID check (qualifile/precise ID) was not done. ';
                                        }
                                        if (depositList[0].CreatedBy.Account.LLC_BI__Identity_Verification_Status__pc != 'Pass') {
                                            transactionLogDetail += 'Booking did not occur because IDology was not done. ';
                                        }
                                        if (depositList[0].CreatedBy.Account.a_Anticipated_Wire_Activity_c__c == null
                                            || depositList[0].CreatedBy.Account.a_Send_Receive_International_Wires__c == null
                                            || depositList[0].CreatedBy.Account.a_Other_Anticipated_International_Activi__c == null) {
                                            transactionLogDetail += 'Booking did not occur because account activity was not done.';
                                        }
                                    }
								// if existing customer, the account activity, IDology, and ID checks do NOT apply
								} else {
									customerFlowCorrect = true;
								}

                                // determine if the number of agreements checked equals the number of agreements required
                                // and also if all the account verification and id checks were correct
                                Boolean bookAccount = false;
								if (agreementCount == requiredAgreements && customerFlowCorrect) {
                                    bookAccount = true;
                                }
                                try{
                                    ABEntities.AutomatedBookingResponse res;
                                    if(Test.isRunningTest()){
                                        res = new ABEntities.AutomatedBookingResponse();
        								String oldFederatedId = 'abc@gmail.com';
        								Boolean failedEnrollment = null;
        								if(calloutResponse == PENDING) {
        									failedEnrollment = false;
        								} else {
        									failedEnrollment = true;
        								}
										List<String> enrollmentStatuses = new List<String>();
	    								enrollmentStatuses.add(oldFederatedId + ',' + failedEnrollment);
        								res.enrollmentStatuses = enrollmentStatuses;
                                        if(calloutResponse == ERROR) {
                                            throw new BookDepositController_Exception(calloutResponse);
                                        } else if(calloutResponse == FAIL){
                                            res.Messages = calloutResponse;
                                            res.IsSuccessful = false;
                                            res.pendingBatch = false;
                                            res.TransactionLogExternalId = '';                                            
                                        } else if(calloutResponse == PENDING){
                                            res.Messages = '';
                                            res.IsSuccessful = true;
                                            res.pendingBatch = true;
                                            res.TransactionLogExternalId = '';
                                        } else {
                                            res.Messages = '';
                                            res.IsSuccessful = true;
                                            res.pendingBatch = false;
                                            res.TransactionLogExternalId = '';
                                        }
                                    } else {
                                        // check bookAccount boolean to make sure booking should occur
                                        if (bookAccount) {
                                            res = ABDepositController.bookDeposit(depositId);
                                        // if ALL requirement agreements were NOT selected, set the message to agreement failed
                                        } else {
											res = new ABEntities.AutomatedBookingResponse();
                                            res.IsSuccessful = false;
                                            // if book account did not run because of the wrong number of agreements,
                                            // set messages to agreement failed to show a different "failure" message to the customer
                                            if (agreementCount != requiredAgreements) {
                                                res.Messages = AGREEMENT_FAILED;
                                            }
                                        }
                                        
                                    }
                                    if(!res.IsSuccessful) {
                                        calloutResponse = res.Messages;
                                    }
            
							      	// loop through the context record(s)
							        // capture information in a list to be used for updates outside the loop
							        List<nPortal__Context__c> contextsToUpdate = new List<nPortal__Context__c>();
							        for (nPortal__Context__c ctxRecord : Ctxlist) {
								        
								        // determine if the federationIdentifier was existing (if ends in @fnbo.com) or net new (email address)
								        // on entry to the application (before book account updates the field) - SAML assertion value
							         	String federationIdentifier = ctxRecord.nPortal__User__r.FederationIdentifier;
							           	if (federationIdentifier != null) {
									        if (federationIdentifier.right(EXISTING_CUSTOMER_FI_SUFFIX.length())==EXISTING_CUSTOMER_FI_SUFFIX) {
									            ctxRecord.Net_New_or_Existing_Customer__c = 'Existing Customer';
									        } else {
									            ctxRecord.Net_New_or_Existing_Customer__c = 'Net New';
									        }
							           	}
							            	
							           	// update all context records with the status after book account is done
							           	if (res.IsSuccessful) {
                                    		// loop through enrollment statuses in response to find the correct record
                                    		// the list is of Strings with comma delimited values of old federated id and failed enrollment of true/false
                                    		Boolean failedEnrollment = false;
                                      		if (res.enrollmentStatuses != null) {
                                           		for (String enrollmentStatus : res.enrollmentStatuses) {
                                           			List<String> enrollmentStatusList = enrollmentStatus.split(',');
                                              		if (enrollmentStatusList.get(0) == ctxRecord.nPortal__User__r.FederationIdentifier) {
                                               			failedEnrollment = enrollmentStatusList.get(1) == 'true' ? true : false;
                                                 		break;
                                               		}
                                            	}
                                         	}
							           		if (res.pendingBatch) {
							           			ctxRecord.Account_Booking_Status__c = 'PendingBatch';
							           			calloutResponse = PENDING;
                                       		// if enrollment failed and the customer came in as a net new customer, display a different message
                                            } else if (failedEnrollment && ctxRecord.Net_New_or_Existing_Customer__c == 'Net New') {
                                                ctxRecord.Account_Booking_Status__c = 'EnrollmentFailed';
                                                // Only update the calloutResponse to failed if the user who failed is the user 
                                                // who is coming through book account (e.g. co-owner)
                                                if (userId == ctxRecord.nPortal__User__c) {
                                            	   	calloutResponse = FAILED_ENROLLMENT;
                                                }
							           		} else {
							           			ctxRecord.Account_Booking_Status__c = 'Success';
							           		}
							           	} else {
                                            // If "Agreement Failed", this means that not all required agreements where checked
                                            // The failure message to the customer will be different for this scenario
                                            if (res.Messages == AGREEMENT_FAILED) {
                                            	transactionLogDetail = 'Booking was not done because customer did not acknowledge all agreements.';
												ctxRecord.Account_Booking_Status__c = 'AgreementFailed';
                                            // Everything else will fall through to the generic failure
                                            } else { 
                                            	ctxRecord.Account_Booking_Status__c = 'Failure';
                                            }
							           	}
							           	
							           	// add context record to list
							           	contextsToUpdate.add(ctxRecord);
							        }
							            
							        // update the contexts outside the loop
							        if (contextsToUpdate.size() > 0) {
							         	nFORCE.DmlUtility.updateObj(contextsToUpdate);
							        }
                                    
                                } catch(Exception ex) {
                                    calloutResponse = 'Cause: ' + ex.getCause() + ' Line: ' + ex.getLineNumber() + ' Message: ' + ex.getMessage() + ' StackTrace: ' + ex.getStackTraceString();
                                 	transactionLogDetail = 'Booking was not done because an exception was thrown in the code: Cause: ' 
                                        + ex.getCause() + ' Line: ' + ex.getLineNumber() + ' Message: ' + ex.getMessage();
                                }
                            } else { // Already booked.
                                if(depositList[0].Online_Application_Booking_Errors__c != null){
                                    calloutResponse = depositList[0].Online_Application_Booking_Errors__c;
                                 	transactionLogDetail = 'Booking was not done because the booking was already run.  Booking errors: ' + calloutResponse + '.';
                                } else {
                                    calloutResponse = SUCCESS; 
                                }
                            }
                        }
                    } else {
                    	transactionLogDetail = 'Booking was not done because the artifact ID on the application does not refer to a deposit record.';
                        calloutResponse = System.Label.NotDepositArtifact; // 'The Artifact ID on the application does not refer to a Deposit record.';
                    }
                }
            } else {
             	transactionLogDetail = 'Booking was not done because there is no related context record for the application and user provided.';
                calloutResponse = System.Label.NoRelatedContext; // 'There is no related Context record for the Application and User provided.';
            }
        } else {
           	transactionLogDetail = 'Booking was not done because the application ID provided is invalid: ' + applicationId;
            calloutResponse = System.Label.InvalidApplicationID; // 'The Application ID provided is invalid.';
        }
        
        // if something was added to the transactionLogDetail variable
        // this means something happened that prevented book account and should be logged
        // transaction log can only be written if the context ID is not empty (null)
        if (String.isNotEmpty(transactionLogDetail) && String.isNotEmpty(contextId)) {
            writeTransactionLog(transactionLogDetail, userId, contextId, appIdString);
        }
        
        ReturnDetails resp = new ReturnDetails();
        resp.status = calloutResponse;
        if (existingCustomer) {
            resp.url = System.Label.ExistingCustomerURL;
        }else {
            resp.url = System.Label.NewCustomerURL;
        }
        return resp;
        
    }

    @remoteAction
    public static ReturnDetails sendRequest(Id appIdString) {
        return sendRequest(appIdString, '');
    }

    public static void writeTransactionLog(String transactionLogDetail, Id userId, Id contextId, String appIdString) {

        nFUSE__Transaction_Log__c tranLog = new nFUSE__Transaction_Log__c(
            nFUSE__External_Id__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(40),
            nFUSE__Action__c = PLUGIN_ACTION, 
            nFUSE__Api_Version__c = PLUGIN_VERSION, 
            nFUSE__App_Plugin__c = PLUGIN_NAME, 
            nFUSE__Primary_Object_Id__c = contextId, 
            nFUSE__Requested_By_User_Id__c = userId,
            nFUSE__Transaction_Detail__c = transactionLogDetail + ' App id: ' + appIdString,
            nFUSE__Transaction_Status__c = 'In Progress',
            nFUSE__Vendor_Status__c = 'failure'
        );

        insert tranLog;
    }

    @testVisible
    private static String 
        SUCCESS = 'Success',
        PENDING = 'Pending',
        FAILED_ENROLLMENT = 'FailedEnrollment',
        AGREEMENT_FAILED = 'AgreementFailed',
        ERROR = 'Error',
        FAIL = 'Failure',
		ID_VERIFICATION_DEPOSIT_FAIL_STATUS = 'Declined',
        EXISTING_CUSTOMER_FI_SUFFIX = System.Label.ExistingCustomerFISuffix,
        PLUGIN_NAME = 'AutomatedBooking',
        PLUGIN_VERSION = '1.0.0.0',
        PLUGIN_ACTION = 'book_deposit';

}