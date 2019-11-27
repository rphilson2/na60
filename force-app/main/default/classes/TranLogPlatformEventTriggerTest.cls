@isTest
public class TranLogPlatformEventTriggerTest {
    
    @isTest 
    private static void testCreateTransactionLogTrigger() {

        // Create test event instance
        // Create an instance of the event and store it in the transactionLogEvent variable
		Transaction_Logs__e transactionLogEvent = new Transaction_Logs__e (
        	Action__c = PLUGIN_ACTION,
			App_Plugin__c = PLUGIN_NAME,
			Transaction_Detail__c = 'This is a test transaction detail',
			Transaction_Status__c = 'Complete',
			User_Id__c	= UserInfo.getUserId());
        
        Test.startTest();
        
        // Call method to publish events
        Database.SaveResult sr = EventBus.publish(transactionLogEvent);
        
        Test.stopTest();
        
        // Perform validation here
        // Verify that the publish was successful
        System.assertEquals(true, sr.isSuccess());
        
        // Check that the tranLog that the trigger created is present
        List<nFUSE__Transaction_Log__c> tranLog = [SELECT Id FROM nFUSE__Transaction_Log__c];
        
        // Validate that the tranLog was found.
        // There is only one test tranLog created
        System.assertEquals(1, tranLog.size());
    }

    private static final String 
		PLUGIN_NAME = 'SingleSignOn',
        PLUGIN_ACTION = 'sign_on';

}