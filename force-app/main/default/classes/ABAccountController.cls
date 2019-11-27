global with sharing class ABAccountController {
    
    public Id objectId { get; set; }
    public ApexPages.StandardController controller;
    
    public ABAccountController(ApexPages.StandardController controller) {
		this.controller = controller;
		this.objectId = (String)controller.getId();
		enableOrDisableButtons();
	}

	public ABAccountController() {
	    this.objectId = Apexpages.currentPage().getParameters().get('id');
		//this.controller = new ApexPages.StandardController([SELECT LLC_BI__lookupKey__c FROM Account WHERE Id=:this.objectId][0]);
		enableOrDisableButtons();
	}
    
    @TestVisible private class ControllerException extends Exception {}
    
    @testVisible
    private static Boolean forceTestingException = false;
    
    @testVisible
    private static IABOrchestrator orchestrator = new ABOrchestrator();
    @testVisible
    private static IABConfiguration configuration = new ABConfiguration();
    
    public Boolean bookCustomerButtonEnabled { get; private set; }
	
	private class ButtonStates{
	    public Boolean bookCustomerButtonEnabled { get; set; }
	}
	
	private static ButtonStates getButtonStates(String accountId) {
        
        ButtonStates states = new ButtonStates();
        
        //default to false
		states.bookCustomerButtonEnabled = false;
		
		//logic that enables this or disables this below
		List<Account> accounts = [SELECT LLC_BI__lookupKey__c FROM Account WHERE Id = :accountId];
		if(!accounts.isEmpty()){
		    String bookedCustomerNumber = accounts[0].LLC_BI__lookupKey__c;
    		//System.Debug('bookedCustomerNumber'+bookedCustomerNumber);
    		states.bookCustomerButtonEnabled = String.isBlank(bookedCustomerNumber);
		}
		
		return states;
		
    }
    
    @RemoteAction
	global static Map<String,Object> getCoreMessage(Id objectId, String type) {
        return orchestrator.GetBookingMessage(type,null,objectId);
	}
    
    public void enableOrDisableButtons() {
		//default to false
		this.bookCustomerButtonEnabled = false;
		
		ButtonStates states = ABAccountController.getButtonStates(this.objectId);
		
		this.bookCustomerButtonEnabled = states.bookCustomerButtonEnabled;
		
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
        compoundLog.bookCustomerButtonEnabled = states.bookCustomerButtonEnabled;
        return compoundLog;
    }
    
    
    @RemoteAction
    global static ABEntities.AutomatedBookingResponse bookCustomer(String accountId){
        ABEntities.AutomatedBookingResponse res = new ABEntities.AutomatedBookingResponse();
        try{
            
            res = orchestrator.BookCustomer(accountId, null, null, null, null);
            
            if(forceTestingException)
                throw new ControllerException();
                    
        }catch(Exception e){
            res.IsSuccessful = false;
            res.Messages = String.format(System.Label.ABSendServiceOrchestrationException, 
                    new String[]{
                        System.Label.CustomerBooking,
                        e.getMessage()
                    });
        }
        return res;
    }
}