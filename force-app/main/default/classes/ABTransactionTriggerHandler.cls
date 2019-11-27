public with sharing class ABTransactionTriggerHandler {

	@testVisible
    private ABConfiguration configuration = new ABConfiguration();
    
	public void beforeUpdate(List<sObject> newObjs, List<sObject> oldObjs, Set<Id> objIds) {
		List<nFUSE__Transaction_Log__c> newLogs = (List<nFUSE__Transaction_Log__c>) newObjs;
		
		//create subsets of loan, customer or deposit collections
		List<sObject> loanLogs = new List<sObject>();
		List<sObject> customerLogs = new List<sObject>();
		List<sObject> depositLogs = new List<sObject>();
		
		for (nFUSE__Transaction_Log__c transLog : newLogs) {
			if((transLog.nFUSE__Action__c == ABConfiguration.LOANMODIFICATIONACTION || 
				transLog.nFUSE__Action__c == ABConfiguration.LOANRENEWALACTION ||
					transLog.nFUSE__Action__c == ABConfiguration.LOANRESERVATIONACTION ||
						transLog.nFUSE__Action__c == ABConfiguration.LOANBOOKACTION) && transLog.nFUSE__App_Plugin__c == ABConfiguration.PLUGIN_NAME){
				loanLogs.add(transLog);
			}else if(transLog.nFUSE__Action__c == ABConfiguration.CUSTOMERBOOKACTION && transLog.nFUSE__App_Plugin__c == ABConfiguration.PLUGIN_NAME){
				customerLogs.add(transLog);
			}else if(transLog.nFUSE__Action__c == ABConfiguration.DEPOSITBOOKACTION && transLog.nFUSE__App_Plugin__c == ABConfiguration.PLUGIN_NAME){
				depositLogs.add(transLog);
			}else{
				//unhandled by this trigger
			}
		}
		
		if(loanLogs.size()>0) handleLoanUpdates(loanLogs);
		if(customerLogs.size()>0) handleCustomerUpdates(customerLogs);
		if(depositLogs.size()>0) handleDepositUpdates(depositLogs);
		
	}

	
	private void handleLoanUpdates(List<sObject> newObjs){
		
		List<nFUSE__Transaction_Log__c> newLogs = (List<nFUSE__Transaction_Log__c>) newObjs;
		List<Map<String, String>> listOfValidDetailMaps = new List<Map<String, String>>();
		Set<String> contextIdSet = new Set<String>();
		
		String externalIdField = ABConfiguration.EXTERNAL_APP_ID_FIELD;
		Boolean reservationsEnabled = configuration.GetPropertyByKey(System.Label.ENABLE_RESERVE_LOAN_BUTTON) == 'true';
		
		String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
        String loanPropertyKey = configuration.GetPropertyByKey(translatedKey);
        
        String reservedLoanTranslatedKey = configuration.GetTranslatedKey(System.Label.EXT_APP_ID);
        String reservedLoanPropertyKey = configuration.GetPropertyByKey(reservedLoanTranslatedKey);
		
		for (nFUSE__Transaction_Log__c transLog : newLogs) {
			if ((transLog.nFUSE__Vendor_Status__c == ABConfiguration.LOAN_RESERVED_COMPLETE || transLog.nFUSE__Vendor_Status__c == ABConfiguration.LOAN_COMPLETE)) {
				Map<String, String> detailsMap;
				try {
					detailsMap = (Map<String, String>) JSON.deserializeStrict(transLog.nFUSE__Transaction_Detail__c, Map<String, String>.class);
				} catch (Exception ee) {
					continue;
				}
				if (detailsMap != null) {
					contextIdSet.add(transLog.nFUSE__Primary_Object_Id__c);
					detailsMap.put(loanPropertyKey, transLog.nFUSE__Primary_Object_Id__c);
					detailsMap.put('nFUSE__Vendor_Status__c', transLog.nFUSE__Vendor_Status__c);
					listOfValidDetailMaps.add(detailsMap);
				}
			}
		}

		if (!listOfValidDetailMaps.isEmpty()) {
			createExternalApplicationLookups(reservedLoanPropertyKey, loanPropertyKey, reservationsEnabled, contextIdSet, listOfValidDetailMaps, externalIdField);
		}
		
	}
	private void handleCustomerUpdates(List<sObject> newObjs){
		List<nFUSE__Transaction_Log__c> newLogs = (List<nFUSE__Transaction_Log__c>) newObjs;
		List<Account> customersToUpdate = new List<Account>();
		
		String externalIdField = ABConfiguration.EXTERNAL_APP_ID_FIELD;
		
        String bookedCustomerTranslatedKey = configuration.GetTranslatedKey(System.Label.EXT_CUST_ID);
        String bookedCustomerPropertyKey = configuration.GetPropertyByKey(bookedCustomerTranslatedKey);
        
		for (nFUSE__Transaction_Log__c transLog : newLogs) {
			if (transLog.nFUSE__Vendor_Status__c == ABConfiguration.CUSTOMER_COMPLETE) {
				Map<String, String> detailsMap;
				try {
					detailsMap = (Map<String, String>) JSON.deserializeStrict(transLog.nFUSE__Transaction_Detail__c, Map<String, String>.class);
				} catch (Exception ee) {
					continue;
				}
				if (detailsMap != null && detailsMap.get(bookedCustomerPropertyKey) != null) {
					
					Account tempCustomer = new Account(Id = transLog.nFUSE__Primary_Object_Id__c);
					tempCustomer.put(externalIdField, detailsMap.get(bookedCustomerPropertyKey));
					customersToUpdate.add(tempCustomer);
				
				}
			}
		}
		
		if(customersToUpdate.size()>0) nFORCE.DmlUtility.updateObj(customersToUpdate);
		
	}
	private void handleDepositUpdates(List<sObject> newObjs){
		List<nFUSE__Transaction_Log__c> newLogs = (List<nFUSE__Transaction_Log__c>) newObjs;
		List<LLC_BI__Deposit__c> depositsToUpdate = new List<LLC_BI__Deposit__c>();
            
		String externalIdField = ABConfiguration.EXTERNAL_APP_ID_FIELD;
		
        String bookedDepositTranslatedKey = configuration.GetTranslatedKey(System.Label.EXT_DEP_ID);
        String bookedDepositPropertyKey = configuration.GetPropertyByKey(bookedDepositTranslatedKey);
        
		for (nFUSE__Transaction_Log__c transLog : newLogs) {
			if (transLog.nFUSE__Vendor_Status__c == ABConfiguration.DEPOSIT_COMPLETE) {
                
                // BEGIN FNNI Customization

                /*
				Map<String, String> detailsMap;
				try {
					detailsMap = (Map<String, String>) JSON.deserializeStrict(transLog.nFUSE__Transaction_Detail__c, Map<String, String>.class);
				} catch (Exception ee) {
					continue;
				}
				if (detailsMap != null && detailsMap.get(bookedDepositPropertyKey) != null) {
					
					LLC_BI__Deposit__c tempDeposit = new LLC_BI__Deposit__c(Id = transLog.nFUSE__Primary_Object_Id__c);
					tempDeposit.put(externalIdField, detailsMap.get(bookedDepositPropertyKey));
					depositsToUpdate.add(tempDeposit);
				
				} */
                
                // END FNNI Customization
			}
		}
		
		if(depositsToUpdate.size()>0) nFORCE.DmlUtility.updateObj(depositsToUpdate);
	}    
    
	private void createExternalApplicationLookups(String reservedLoanPropertyKey, String loanPropertyKey, Boolean reservationsEnabled, Set<String> contextIdSet, List<Map<String, String>> listOfValidDetailMaps, String externalIdFieldName) {
		Map<String,LLC_BI__External_Application_Lookup__c> existingExternalApps = getExistingExternalApplications(contextIdSet);
		List<LLC_BI__External_Application_Lookup__c> toInsertApps = new List<LLC_BI__External_Application_Lookup__c>();
		List<LLC_BI__External_Application_Lookup__c> toUpdateApps = new List<LLC_BI__External_Application_Lookup__c>();
		List<LLC_BI__Loan__c> loansToUpdate = new List<LLC_BI__Loan__c>();
		List<LLC_BI__External_Application_Lookup__c> externalAppsToDelete = new List<LLC_BI__External_Application_Lookup__c>();
		LLC_BI__Loan__c tempLoan;
		LLC_BI__External_Application_Lookup__c tempEAL;
		for (Map<String, String> detailMapper : listOfValidDetailMaps) {
			
			//System.debug('detailMapper:'+detailMapper);
			
			String vendorStatus = detailMapper.get('nFUSE__Vendor_Status__c');
			
			//System.debug('vendorStatus:'+vendorStatus);
			
			//System.debug('existingExternalApps:'+existingExternalApps);
			
			if (!existingExternalApps.containsKey(detailMapper.get(loanPropertyKey))) {
				
				if(vendorStatus == ABConfiguration.LOAN_RESERVED_COMPLETE){
					LLC_BI__External_Application_Lookup__c newExtApp = new LLC_BI__External_Application_Lookup__c(
						LLC_BI__External_Id__c = detailMapper.get(reservedLoanPropertyKey),
						LLC_BI__Context_Id__c = detailMapper.get(loanPropertyKey),
						Name = ABConfiguration.LOANRESERVATIONLOOKUPKEY
					);
					toInsertApps.add(newExtApp);
				}
				
				if(!reservationsEnabled){
					
					if(vendorStatus == ABConfiguration.LOAN_COMPLETE){
						//System.debug('1 has loan property key and reservationsEnabled=false');
						
						//this needs to happen if the enable reserve is disabled
						tempLoan = new LLC_BI__Loan__c(Id = detailMapper.get(loanPropertyKey));
						tempLoan.put(externalIdFieldName, detailMapper.get(reservedLoanPropertyKey));
						loansToUpdate.add(tempLoan);
						
					}
					
				}
			}else{
				
				if(reservationsEnabled){
					
					LLC_BI__External_Application_Lookup__c lookup = existingExternalApps.get(detailMapper.get(loanPropertyKey));
						
					//it does contain an existing one, so we will need to update it
					if(vendorStatus == ABConfiguration.LOAN_RESERVED_COMPLETE){
						//update existing one
						if(lookup!=null){
							//only work with the first one
							lookup.LLC_BI__External_Id__c = detailMapper.get(reservedLoanPropertyKey);
							toUpdateApps.add(lookup);
						}
					}	
					
					//if complete, handle it here
					if(vendorStatus == ABConfiguration.LOAN_COMPLETE){
						
						//if loan was complete, and reservation was enabled, then we assume that the external application lookup has the latest reserved number
						//we do not have a dependency on it existing in the response payload
						//this happens if the enable reserve is enabled and we were working with the resrved number
						tempLoan = new LLC_BI__Loan__c(Id = detailMapper.get(loanPropertyKey));
						tempLoan.put(externalIdFieldName, lookup.LLC_BI__External_Id__c);
						loansToUpdate.add(tempLoan);
						//also delete the external application lookup entry
						externalAppsToDelete.add(lookup);
						
					}
				}
			}
			
		}
		nFORCE.DmlUtility.insertObj(toInsertApps);
		nFORCE.DmlUtility.updateObj(toUpdateApps);
		nFORCE.DmlUtility.updateObj(loansToUpdate);
		nFORCE.DmlUtility.deleteObj(externalAppsToDelete);
	}

	// private Set<String> getExistingExternalApplications(Set<String> idSet) {
	// 	Set<String> existingStrings = new Set<String>();
	// 	List<LLC_BI__External_Application_Lookup__c> existingExternalApps = [
	// 		SELECT
	// 			Id,
	// 			Name,
	// 			LLC_BI__Context_Id__c,
	// 			LLC_BI__External_Id__c
	// 		FROM
	// 			LLC_BI__External_Application_Lookup__c
	// 		WHERE
	// 			Name = :ABConfiguration.LOANRESERVATIONLOOKUPKEY
	// 		AND
	// 			LLC_BI__Context_Id__c IN :idSet
	// 	];

	// 	for (LLC_BI__External_Application_Lookup__c extAL : existingExternalApps) {
	// 		existingStrings.add(extAL.LLC_BI__Context_Id__c);
	// 	}

	// 	return existingStrings;
	// }
	
	private Map<String,LLC_BI__External_Application_Lookup__c> getExistingExternalApplications(Set<String> idSet) {
		Map<String,LLC_BI__External_Application_Lookup__c> existing = new Map<String,LLC_BI__External_Application_Lookup__c>();
		List<LLC_BI__External_Application_Lookup__c> existingExternalApps = [
			SELECT
				Id,
				Name,
				LLC_BI__Context_Id__c,
				LLC_BI__External_Id__c
			FROM
				LLC_BI__External_Application_Lookup__c
			WHERE
				Name = :ABConfiguration.LOANRESERVATIONLOOKUPKEY
			AND
				LLC_BI__Context_Id__c IN :idSet
		];

		for (LLC_BI__External_Application_Lookup__c extAL : existingExternalApps) {
			existing.put(extAL.LLC_BI__Context_Id__c,extAL);
		}

		return existing;
	}

	public static final String BEAN_NAME =
		nFORCE.BeanRegistry.getInstance().generateUniqueBeanName(
			LLC_BI.ATriggerHandler.class,
			'generic-automated-booking-transaction-log-trigger-handler');
}