// Apex test methods for the TestVolActivitySendReminderControllerExt class.
@isTest
private class TestVolActivitySendReminderControllerExt{
	
    private VolActivitySendReminderControllerExt setupController( Volunteer_Activity__c va ){
    	
        ApexPages.StandardController standardcontroller = new ApexPages.StandardController( va );
        VolActivitySendReminderControllerExt controller = new VolActivitySendReminderControllerExt( standardcontroller );
    
        PageReference p = Page.VolActivitySendReminderPopup;
        p.getParameters().put( 'id', va.id );
        Test.setCurrentPage( p );
        
        System.assert( controller != null );
        return controller;
    }
    
    public static testMethod void reminderTest(){
    	            
        TestVolActivitySendReminderControllerExt testclass = new TestVolActivitySendReminderControllerExt();
        
        VolActivitySendReminderControllerExt controller = testclass.setupController(TestCommon.setupActivity(TestCommon.setupVolunteerOrganization(), 1));
        controller.sendReminder();
        controller.incrementCounter();
        
        System.assertNotEquals( null, controller.getVolunteerforceImageUrl );
    }
}