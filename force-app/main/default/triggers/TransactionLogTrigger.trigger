trigger TransactionLogTrigger on nFUSE__Transaction_Log__c (before insert, before update) {
	//TriggerHandler.executeObjectTrigger(Schema.nFUSE__Transaction_Log__c.sObjectType);
	
    if(trigger.isInsert || trigger.isUpdate){
		IDologySetReportIdTriggerHandler.handleAccountUpdate(trigger.new);
    }   
}