global with sharing class ABLoanController {
    
    public Id objectId { get; set; }
    public ApexPages.StandardController controller;
    
    public ABLoanController(ApexPages.StandardController controller) {
		this.controller = controller;
		this.objectId = (String)controller.getId();
		enableOrDisableButtons();
	}

	public ABLoanController() {
		this.objectId = Apexpages.currentPage().getParameters().get('id');
		enableOrDisableButtons();
	}
    
    @TestVisible private class ControllerException extends Exception {}
    
    @testVisible
    private static Boolean forceTestingException = false;
    
    @testVisible
    private static IABOrchestrator orchestrator = new ABOrchestrator();
    
    @testVisible
    private static IABConfiguration configuration = new ABConfiguration();
    
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
		
		ButtonStates states = ABLoanController.getButtonStates(this.objectId);
		
		this.renewLoanButtonEnabled = states.renewLoanButtonEnabled;
		this.modifyLoanButtonEnabled = states.modifyLoanButtonEnabled;
		this.reserveLoanButtonEnabled = states.reserveLoanButtonEnabled;
		this.bookToCoreButtonEnabled = states.bookToCoreButtonEnabled;
		
		//System.debug(states);
		
	}
	
    @RemoteAction
    global static ABEntities.CompoundTransactionLogResponse getTransactionStatus(String externalId){
        ABEntities.TransactionLogResponse log = orchestrator.GetTransactionLogDetails(externalId);
        
        ABEntities.CompoundTransactionLogResponse compoundLog = new ABEntities.CompoundTransactionLogResponse();
        compoundLog.ObjectId = log.ObjectId;
        compoundLog.ExternalId = log.ExternalId;
        compoundLog.Details = log.Details;
        compoundLog.Status = log.Status;
        compoundLog.VendorStatus = log.VendorStatus;
        compoundLog.IsComplete = log.IsComplete;
        compoundLog.IsSuccessful = log.IsSuccessful;
        
        ButtonStates states = getButtonStates(compoundLog.ObjectId);
        compoundLog.renewLoanButtonEnabled = states.renewLoanButtonEnabled;
        compoundLog.modifyLoanButtonEnabled = states.modifyLoanButtonEnabled;
        compoundLog.reserveLoanButtonEnabled = states.reserveLoanButtonEnabled;
        compoundLog.bookToCoreButtonEnabled = states.bookToCoreButtonEnabled;
        return compoundLog;
    }
    
    @RemoteAction
	global static Map<String,Object> getCoreMessage(Id objectId, String type) {
	    String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
        String key = configuration.GetPropertyByKey(translatedKey);
        return orchestrator.GetBookingMessage(type,key,objectId);
	}
    
    @RemoteAction
    global static ABEntities.AutomatedBookingResponse renewLoan(String loanId){
        ABEntities.AutomatedBookingResponse res = new ABEntities.AutomatedBookingResponse();
        try{
            
            String overrideLoanId = null;
		
    		overrideLoanId = orchestrator.GetBookedLoanNumberByLoanId(loanId,true,orchestrator.GetConfigValue('REN_NAME_FORMAT'));
    		
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
		
		    res = orchestrator.RenewLoan(loanId, null, null, null, additionalProperties);
            
            if(forceTestingException)
                throw new ControllerException();
                    
        }catch(Exception e){
            res.IsSuccessful = false;
            res.Messages = String.format(System.Label.ABSendServiceOrchestrationException, 
                    new String[]{
                        System.Label.LoanBooking,
                        e.getMessage()
                    });
        }
        return res;
    }
    @RemoteAction
    global static ABEntities.AutomatedBookingResponse modifyLoan(String loanId){
        ABEntities.AutomatedBookingResponse res = new ABEntities.AutomatedBookingResponse();
        try{
            
            //get the resrved loan id if it exists
    		String overrideLoanId = null;
    		
    		overrideLoanId = orchestrator.GetBookedLoanNumberByLoanId(loanId,true,orchestrator.GetConfigValue('MOD_NAME_FORMAT'));
    		
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
    		
    		res = orchestrator.ModifyLoan(loanId, null, null, null, additionalProperties);
            
            if(forceTestingException)
                throw new ControllerException();
                    
        }catch(Exception e){
            res.IsSuccessful = false;
            res.Messages = String.format(System.Label.ABSendServiceOrchestrationException, 
                    new String[]{
                        System.Label.LoanBooking,
                        e.getMessage()
                    });
        }
        return res;
    }
    @RemoteAction
    global static ABEntities.AutomatedBookingResponse reserveLoan(String loanId){
        ABEntities.AutomatedBookingResponse res = new ABEntities.AutomatedBookingResponse();
        try{
            
            res = orchestrator.ReserveLoan(loanId, null, null, null, null);
            
            if(forceTestingException)
                throw new ControllerException();
                    
        }catch(Exception e){
            res.IsSuccessful = false;
            res.Messages = String.format(System.Label.ABSendServiceOrchestrationException, 
                    new String[]{
                        System.Label.LoanBooking,
                        e.getMessage()
                    });
        }
        return res;
    }
    @RemoteAction
    global static ABEntities.AutomatedBookingResponse bookLoan(String loanId){
        
        ABEntities.AutomatedBookingResponse res = new ABEntities.AutomatedBookingResponse();
        try{
            //get the resrved loan id if it exists
    		String overrideLoanId = null;
    		
    		overrideLoanId = orchestrator.GetReservedLoanNumberByLoanId(loanId);
    		
    		Map<String,String> additionalProperties = null;
    		if(!String.isBlank(overrideLoanId)){
    			additionalProperties = new Map<String, String>();
    			//as long as this is here, it will be present in the properties collection in the outbound message
    			String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
                String key = configuration.GetPropertyByKey(translatedKey);
    			additionalProperties.put(key,overrideLoanId);
    		}
    		
    		res = orchestrator.BookLoan(loanId, null, null, null, additionalProperties);
            
            if(forceTestingException)
                throw new ControllerException();
                    
        }catch(Exception e){
            res.IsSuccessful = false;
            res.Messages = String.format(System.Label.ABSendServiceOrchestrationException, 
                    new String[]{
                        System.Label.LoanBooking,
                        e.getMessage()
                    });
        }
        return res;
    }
}