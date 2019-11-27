global with sharing class ABEnhancedLoanController {
	
	public class ABLoanControllerException extends Exception {}
	
	@TestVisible
	private static IABConfiguration configuration = (IABConfiguration)Type.forName('ABConfiguration').newInstance();
	
	@TestVisible
    private static IABOrchestrator orchestrator = (IABOrchestrator)Type.forName('ABOrchestrator').newInstance();
	
	public ApexPages.StandardController controller;
	public Id objectId { get; set; }
	public static nFUSE.SendService sendService;
	public static nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
	public Boolean renewLoanButtonEnabled { get; private set; }
	public Boolean modifyLoanButtonEnabled { get; private set; }
	public Boolean reserveLoanButtonEnabled { get; private set; }
	public Boolean bookToCoreButtonEnabled { get; private set; }
	private class ButtonStates{
	    public Boolean renewLoanButtonEnabled { get; set; }
    	public Boolean modifyLoanButtonEnabled { get; set; }
    	public Boolean reserveLoanButtonEnabled { get; set; }
    	public Boolean bookToCoreButtonEnabled { get; set; }
	}
	public ABEnhancedLoanController(ApexPages.StandardController controller) {
		this.controller = controller;
		this.objectId = (String)controller.getId();
		enableOrDisableButtons();
	}

	public ABEnhancedLoanController() {
		this.objectId = Apexpages.currentPage().getParameters().get('id');
		enableOrDisableButtons();
	}
	
	private static ButtonStates getButtonStates(String loanId) {
        
        ButtonStates states = new ButtonStates();
        
        //default to false
		states.renewLoanButtonEnabled = false;
		states.modifyLoanButtonEnabled = false;
		states.reserveLoanButtonEnabled = false;
		states.bookToCoreButtonEnabled = false;
		
		Boolean sysPropVal = nFORCE.SystemProperties.getInstance().getPropertyAsBoolean(
			ABConfiguration.PLUGIN_CATEGORY_NAME,
			System.Label.ENABLE_RESERVE_LOAN_BUTTON,
			false
		);
		
		String bookedLoanNumber = orchestrator.GetBookedLoanNumberByLoanId(loanId,false,null);
		String reservedLoanNumber = orchestrator.GetReservedLoanNumberByLoanId(loanId);
		
		if (sysPropVal) {
			
			states.reserveLoanButtonEnabled = String.isBlank(bookedLoanNumber);
			
		} else {
			states.reserveLoanButtonEnabled = false;
		}
		
		Boolean reservationsEnabled = configuration.GetPropertyByKey(System.Label.ENABLE_RESERVE_LOAN_BUTTON) == 'true';
		
		//system.debug('reservationsEnabled'+reservationsEnabled);
		
		Boolean reservationHasBeenMade = false;
		if(!String.isBlank(reservedLoanNumber)){
			reservationHasBeenMade = true;
		}else{
		    reservationHasBeenMade = !reservationsEnabled;
		}
		
		states.bookToCoreButtonEnabled = String.isBlank(bookedLoanNumber) && reservationHasBeenMade;

		if(!String.isBlank(bookedLoanNumber)){
			
			Boolean loanNumberContainsRenewalDelimiter = orchestrator.StringContainsConfigValue(bookedLoanNumber,'REN_NAME_FORMAT');
			Boolean loanNumberContainsModificationDelimiter = orchestrator.StringContainsConfigValue(bookedLoanNumber,'MOD_NAME_FORMAT');
			
			Boolean loanNumberContainsRenewalDelimiterAndModificationDelimiter = loanNumberContainsRenewalDelimiter && loanNumberContainsModificationDelimiter;
			
			String modDelimiter = orchestrator.GetConfigValue('MOD_NAME_FORMAT');
	        String renDelimiter = orchestrator.GetConfigValue('REN_NAME_FORMAT');
	        
	        Boolean intendedRenewal = false;
	        Boolean intendedModification = false;
	        
			if(loanNumberContainsRenewalDelimiterAndModificationDelimiter){
				if(!String.isBlank(renDelimiter))
		        {
		        	String substringBeforeRenewalDelimiter = bookedLoanNumber.substringBefore(renDelimiter);
					//check if it has mod in the small one
					if(orchestrator.StringContainsConfigValue(substringBeforeRenewalDelimiter,'MOD_NAME_FORMAT')){
						//this WAS a renewal since it was last on the renewal delimiter
						intendedRenewal = true;
					}
		        }
				
				if(!String.isBlank(modDelimiter)){
					String substringBeforeModificationDelimiter = bookedLoanNumber.substringBefore(modDelimiter);
					//check if it has ren in the small one
					if(orchestrator.StringContainsConfigValue(substringBeforeModificationDelimiter,'REN_NAME_FORMAT')){
						//this WAS a modification since it was last on the mod delimiter
						intendedModification = true;
					}
				}
			}
			
			states.renewLoanButtonEnabled = !states.bookToCoreButtonEnabled && (
					(loanNumberContainsRenewalDelimiter && intendedRenewal) 
						|| (loanNumberContainsRenewalDelimiter && !intendedModification)
				);
			states.modifyLoanButtonEnabled = !states.bookToCoreButtonEnabled && (
					(loanNumberContainsModificationDelimiter && intendedModification) 
						|| (loanNumberContainsModificationDelimiter && !intendedRenewal)
				);
			
		}
		
		return states;
		
    }
	
	public void enableOrDisableButtons() {
		//default to false
		this.renewLoanButtonEnabled = false;
		this.modifyLoanButtonEnabled = false;
		this.reserveLoanButtonEnabled = false;
		this.bookToCoreButtonEnabled = false;
		
		ButtonStates states = ABEnhancedLoanController.getButtonStates(this.objectId);
		
		this.renewLoanButtonEnabled = states.renewLoanButtonEnabled;
		this.modifyLoanButtonEnabled = states.modifyLoanButtonEnabled;
		this.reserveLoanButtonEnabled = states.reserveLoanButtonEnabled;
		this.bookToCoreButtonEnabled = states.bookToCoreButtonEnabled;
		
		//System.debug(states);
		
	}
	
	@RemoteAction
    global static String getButtonStatuses(String loanId){
        ButtonStates states = getButtonStates(loanId);
        return LLC_BI.Utility.htmlEncodeJsonSerialize(states);
    }
	
	public String getRequestHistory() {
		List<nFUSE__Transaction_Log__c> transactionLogs = getTransactionLogsById(this.objectId);
		List<RequestHistoryItem> toReturn = new List<RequestHistoryItem>();

		for(nFUSE__Transaction_Log__c transLog : transactionLogs){
			toReturn.add(createRequestHistoryItem(transLog));
		}
		return LLC_BI.Utility.htmlEncodeJsonSerialize(toReturn);
	}

	@RemoteAction
	global static Map<String,Object> getCoreMessage(Id objectId, String type) {
        String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
        String key = configuration.GetPropertyByKey(translatedKey);
		return orchestrator.GetBookingMessage(type,key,objectId);
	}

	@RemoteAction
	global static RequestHistoryItem getLogInfo(String extId) {
		List<nFUSE__Transaction_Log__c> transactionLogs = getTransactionLogsById(extId);
		RequestHistoryItem retItem;
		if (transactionLogs.size() == 1) {
			retItem = createRequestHistoryItem(transactionLogs[0]);
		}
		return retItem;
	}

	@RemoteAction
	global static String initiateBooking(Id objectId) {
		
		//get the resrved loan id if it exists
		String overrideLoanId = null;
		
		overrideLoanId = orchestrator.GetReservedLoanNumberByLoanId(objectId);
		
		Map<String,String> additionalProperties = null;
		if(!String.isBlank(overrideLoanId)){
			additionalProperties = new Map<String, String>();
			//as long as this is here, it will be present in the properties collection in the outbound message
			String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
            String key = configuration.GetPropertyByKey(translatedKey);
			additionalProperties.put(key,overrideLoanId);
		}
		
		ABEntities.AutomatedBookingResponse response = orchestrator.BookLoan(objectId, null, null, null, additionalProperties);
		
		if(response.IsSuccessful)
			return system.today().format();
		
		//there was an error
		throw new ABLoanControllerException(response.Messages);
	}
	
	@RemoteAction
	global static String initiateReservation(Id objectId) {
		System.debug('will call reserve loan in orchestrator');
		ABEntities.AutomatedBookingResponse response = orchestrator.ReserveLoan(objectId, null, null, null, null);
		
		if(response.IsSuccessful)
			return system.today().format();
		
		System.debug('there was an issue within orchestration.');
		//there was an error
		throw new ABLoanControllerException(response.Messages);
	}
	
	@RemoteAction
	global static String initiateRenewal(Id objectId) {
		System.debug('will call renew loan in orchestrator');
		
		//get the resrved loan id if it exists
		String overrideLoanId = null;
		
		overrideLoanId = orchestrator.GetBookedLoanNumberByLoanId(objectId,true,orchestrator.GetConfigValue('REN_NAME_FORMAT'));
		
		Map<String,String> additionalProperties = null;
		if(!String.isBlank(overrideLoanId)){
			String modDelimiter = orchestrator.GetConfigValue('MOD_NAME_FORMAT');
    		if(!String.isBlank(modDelimiter)) overrideLoanId = overrideLoanId.substringBefore(modDelimiter);
			additionalProperties = new Map<String, String>();
			//as long as this is here, it will be present in the properties collection in the outbound message
			String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
            String key = configuration.GetPropertyByKey(translatedKey);
			additionalProperties.put(key,overrideLoanId);
		}
		
		System.debug(additionalProperties);
		
		ABEntities.AutomatedBookingResponse response = orchestrator.RenewLoan(objectId, null, null, null, additionalProperties);
		
		if(response.IsSuccessful)
			return system.today().format();
		
		System.debug('there was an issue within orchestration.');
		//there was an error
		throw new ABLoanControllerException(response.Messages);
	}
	
	@RemoteAction
	global static String initiateModification(Id objectId) {
		System.debug('will call modify loan in orchestrator');
		
		//get the resrved loan id if it exists
		String overrideLoanId = null;
		
		overrideLoanId = orchestrator.GetBookedLoanNumberByLoanId(objectId,true,orchestrator.GetConfigValue('MOD_NAME_FORMAT'));
		
		Map<String,String> additionalProperties = null;
		if(!String.isBlank(overrideLoanId)){
			String renDelimiter = orchestrator.GetConfigValue('REN_NAME_FORMAT');
			if(!String.isBlank(renDelimiter)) overrideLoanId = overrideLoanId.substringBefore(renDelimiter);
    		additionalProperties = new Map<String, String>();
			//as long as this is here, it will be present in the properties collection in the outbound message
			String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
            String key = configuration.GetPropertyByKey(translatedKey);
			additionalProperties.put(key,overrideLoanId);
		}
		
		System.debug(additionalProperties);
		
		ABEntities.AutomatedBookingResponse response = orchestrator.ModifyLoan(objectId, null, null, null, additionalProperties);
		
		if(response.IsSuccessful)
			return system.today().format();
		
		System.debug('there was an issue within orchestration.');
		//there was an error
		throw new ABLoanControllerException(response.Messages);
	}

	
	private static RequestHistoryItem createRequestHistoryItem(nFUSE__Transaction_Log__c transLog) {
		Datetime tempDatetime = DateTime.newInstance(
			transLog.CreatedDate.year(),
			transLog.CreatedDate.month(),
			transLog.CreatedDate.day(),
			transLog.CreatedDate.hour(),
			transLog.CreatedDate.minute(),
			transLog.CreatedDate.second()
		);
		Map<String,String> detailMap = new Map<String, String>();
		try {
			detailMap = (Map<String, String>) JSON.deserializeStrict(transLog.nFUSE__Transaction_Detail__c, Map<String, String>.class);
		} catch (Exception e) {}

		return new RequestHistoryItem(
			transLog.nFUSE__Transaction_Status__c,
			transLog.nFUSE__Vendor_Status__c,
			transLog.nFUSE__External_Id__c,
			detailMap.get(PROP_ERROR_MESSAGE),
			tempDatetime.format()
		);
	}

	private static List<nFUSE__Transaction_Log__c> getTransactionLogsById(String tId) {
		return [
			SELECT
				nFUSE__Vendor_Status__c,
				nFUSE__Transaction_Status__c,
				nFUSE__External_Id__c,
				nFUSE__Transaction_Detail__c,
				nFUSE__App_Plugin__c,
				CreatedDate
			FROM
				nFUSE__Transaction_Log__c
			WHERE
				nFUSE__App_Plugin__c = :ABConfiguration.PLUGIN_NAME
			AND
				(nFUSE__External_Id__c = :tId OR nFUSE__Primary_Object_Id__c = :tId)
			ORDER BY
				CreatedDate DESC
		];
	}


	global class RequestHistoryItem {
		public String action;
		public String status;
		public String requestDate;
		public String extId;
		public String errorMessage;

		public RequestHistoryItem(String status, String action, String externalId, String errorMsg, String requestDate) {
			//initial state support
			if (action == ABConfiguration.LOANBOOKACTION) {
				this.action = Label.AB_Book_To_Core;
			} else if (action == ABConfiguration.LOANRESERVATIONACTION) {
				this.action = Label.AB_Reserve_Loan_Number;
			} else if (action == ABConfiguration.LOANRENEWALACTION) {
				this.action = Label.AB_Renew_Loan;
			} else if (action == ABConfiguration.LOANMODIFICATIONACTION) {
				this.action = Label.AB_Modify_Loan;
			} else {
				
				//completion or error support
				if (action == ABConfiguration.LOAN_COMPLETE) {
					this.action = Label.AB_TABLE_ACTION_LOANBOOKING_COMPLETE;
				} else if (action == ABConfiguration.LOAN_RESERVED_COMPLETE) {
					this.action = Label.AB_TABLE_ACTION_LOANRESERVE_COMPLETE;
				} else if (action == ABConfiguration.LOAN_RENEWAL_COMPLETE) {
					this.action = Label.AB_TABLE_ACTION_LOANRENEWAL_COMPLETE;
				} else if (action == ABConfiguration.LOAN_MODIFICATION_COMPLETE) {
					this.action = Label.AB_TABLE_ACTION_LOANMOD_COMPLETE;
				} else {
					this.action = action;	
				}
				
			}
			this.extId = externalId;
			this.status = status;
			this.requestDate = requestDate;
			this.errorMessage = errorMsg;
		}
	}

	@TestVisible
	private static final String
		NFUSE_SERVICE = 'nFUSE.LoanGetXPkg',
		INPUT_REQUEST = 'request',
		INPUT_LOAN_IDS = 'loan_ids',
		OUTPUT_LOANS = 'loans',
		PROP_LOAN_KEY = 'loanKey',
		PROP_ERROR_MESSAGE = 'errorMsg',
		IN_PROGRESS_STATUS = 'In Progress';
}