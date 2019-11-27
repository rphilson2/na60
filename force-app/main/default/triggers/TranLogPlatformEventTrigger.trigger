trigger TranLogPlatformEventTrigger on Transaction_Logs__e (after insert) {

    List<nFUSE__Transaction_Log__c> tranLogs = new List<nFUSE__Transaction_Log__c>();
    
    // Iterate through each tran log notification.
    for (Transaction_Logs__e event : Trigger.New) {
        tranLogs.add(createTransactionLog(event));
	}
    
    if (tranLogs.size() > 0) {
		insert tranLogs;
    }

    public static nFUSE__Transaction_Log__c createTransactionLog(Transaction_Logs__e event) {

		nFUSE__Transaction_Log__c tranLog = new nFUSE__Transaction_Log__c(
            nFUSE__External_Id__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(40),
            nFUSE__Action__c = event.Action__c, 
            nFUSE__Api_Version__c = '1.0.0.0', 
            nFUSE__App_Plugin__c = event.App_Plugin__c, 
            nFUSE__Primary_Object_Id__c = event.User_Id__c, 
            nFUSE__Requested_By_User_Id__c = event.User_Id__c,
            nFUSE__Transaction_Detail__c = event.Transaction_Detail__c,
            nFUSE__Transaction_Status__c = event.Transaction_Status__c,
            nFUSE__Vendor_Status__c = event.Transaction_Status__c
        );
        
        return tranLog;
    }
}