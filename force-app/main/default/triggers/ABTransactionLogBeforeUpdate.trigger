trigger ABTransactionLogBeforeUpdate on nFUSE__Transaction_Log__c (before update) {
	if (nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN)) {
		new ABTransactionTriggerHandler().beforeUpdate(Trigger.new, Trigger.old, Trigger.newMap.keySet());
	}
}