// Apex test methods for the VolActivitySignMeUpControllerExt class.
@isTest
private with sharing class TestVolActivitySignMeUpControllerExt{
	
    public static testMethod void sigmeupTest(){
    	
        TestVolActivitySignMeUpControllerExt testclass = new TestVolActivitySignMeUpControllerExt();
        
        datetime myDateTime = datetime.now(); 
        
        Volunteer_Activity__c va = new Volunteer_Activity__c( Street__c='a1',City__c='b2',Duration_Hours__c=1.0,Date_and_Time__c=myDateTime,IsOpportunity__c=false);
        insert( va );
        
        Volunteer_Activity_Participant__c p1 = new Volunteer_Activity_Participant__c( Volunteer_Activity__c = va.Id, User__c = TestCommon.setupUser().id, Duration_hours__c = 1.0 );
        
        // Construct the controller that will be returned by this setup method.
        ApexPages.StandardController standardcontroller = new ApexPages.StandardController( va ) ;
        VolActivitySignMeUpControllerExt controller 	= new VolActivitySignMeUpControllerExt( standardcontroller );
    
        // Create a page for use in the test.
        PageReference p = Page.VolActivitySignMeUpConfirmation;
        
        // Set the case ID in the context for use by the controller.
        p.getParameters().put( 'id', va.id );
        
        // Set the case ID in the context for use by the controller.
        Test.setCurrentPage( p );
        
        System.assertEquals( null, controller.signUp() );
        
    }
}