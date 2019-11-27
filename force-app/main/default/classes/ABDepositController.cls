global with sharing class ABDepositController {
    
    public Id objectId { get; set; }
    public ApexPages.StandardController controller;
    
    public ABDepositController(ApexPages.StandardController controller) {
		this.controller = controller;
		this.objectId = (String)controller.getId();
		enableOrDisableButtons();
	}

	public ABDepositController() {
		this.objectId = Apexpages.currentPage().getParameters().get('id');
		//this.controller = new ApexPages.StandardController([SELECT LLC_BI__lookupKey__c FROM LLC_BI__Deposit__c WHERE Id=:this.objectId][0]);
		enableOrDisableButtons();
	}
	
    
    @TestVisible private class ControllerException extends Exception {}
    
    @testVisible
    private static Boolean forceTestingException = false;
    
    @testVisible
    private static IABOrchestrator orchestrator = new ABOrchestrator();
    @testVisible
    private static IABConfiguration configuration = new ABConfiguration();
    
    public Boolean bookDepositButtonEnabled { get; private set; }
	
	private class ButtonStates{
	    public Boolean bookDepositButtonEnabled { get; set; }
	}
	
	private static ButtonStates getButtonStates(String depositId) {
        
        ButtonStates states = new ButtonStates();
        
        //default to false
		states.bookDepositButtonEnabled = false;
		
		//logic that enables this or disables this below
		List<LLC_BI__Deposit__c> deposits = [SELECT LLC_BI__lookupKey__c FROM LLC_BI__Deposit__c WHERE Id = :depositId];
		if(!deposits.isEmpty()){
		    String bookedDepositNumber = deposits[0].LLC_BI__lookupKey__c;
    		//System.Debug('bookedDepositNumber'+bookedDepositNumber);
    		states.bookDepositButtonEnabled = String.isBlank(bookedDepositNumber);
		}
		
		return states;
		
    }
    
    @RemoteAction
	global static Map<String,Object> getCoreMessage(Id objectId, String type) {
        return orchestrator.GetBookingMessage(type,null,objectId);
	}
    
    public void enableOrDisableButtons() {
		//default to false
		this.bookDepositButtonEnabled = false;
		
		ButtonStates states = ABDepositController.getButtonStates(this.objectId);
		
		this.bookDepositButtonEnabled = states.bookDepositButtonEnabled;
		
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
        compoundLog.bookDepositButtonEnabled = states.bookDepositButtonEnabled;
        return compoundLog;
    }
    
    @RemoteAction
    global static ABEntities.AutomatedBookingResponse bookDeposit(String depositId){
        ABEntities.AutomatedBookingResponse res = new ABEntities.AutomatedBookingResponse();
        try{
            
            res = orchestrator.BookDeposit(depositId, null, null, null, null);
            
            if(forceTestingException)
                throw new ControllerException();
                
        }catch(Exception e){
            res.IsSuccessful = false;
            res.Messages = String.format(System.Label.ABSendServiceOrchestrationException, 
                    new String[]{
                        System.Label.DepositBooking,
                        e.getMessage()
                    });
        }
        return res;
    }
}