// Apex test methods for the VolActivityMassSignUpControllerExt class.
@isTest
private class TestVolActivityMassSignUpControllerExt{
	    
    private VolActivityMassSignUpControllerExt setupController( Volunteer_Activity__c va ){
    
        // Construct the controller that will be returned by this setup method.
        ApexPages.StandardController standardcontroller = new ApexPages.StandardController( va ) ;
        VolActivityMassSignUpControllerExt controller 	= new VolActivityMassSignUpControllerExt( standardcontroller );
     
        // Create a page for use in the test.
        PageReference p = Page.VolActivityMassSignUpPage;
        
        // Set the case ID in the context for use by the controller.
        p.getParameters().put( 'id', va.id );
        
        // Set the case ID in the context for use by the controller.
        Test.setCurrentPage( p );
        
        System.assert( controller != null );
        return controller;
    }
    
    private Volunteer_Activity__c setupTestCaseVA(){
    	
        datetime myDateTime = datetime.now();
        
        Volunteer_Activity__c va1 = new Volunteer_Activity__c(Street__c='a1',City__c='b2',
                Date_and_Time__c=myDateTime,IsOpportunity__c=false,duration_hours__c=1.0,
                Max_Number_of_Participants__c=1);
        try{
        	insert va1;
        	System.assert( true );
        }catch( Exception ex ){
        	System.assert( false );
        }
                
        return va1;
    }
        
    public static testMethod void massSignUpTest(){
    	
        TestVolActivityMassSignUpControllerExt testclass = new TestVolActivityMassSignUpControllerExt();
        
        Volunteer_Activity__c va = testclass.setupTestCaseVA();
        Volunteer_Organization__c vo = TestCommon.setupVolunteerOrganization();
        
        VolActivityMassSignUpControllerExt cont = new VolActivityMassSignUpControllerExt( new ApexPages.Standardcontroller( TestCommon.setupActivity( vo, 2 ) ));
        cont.getRenderMaxParticipants();
        cont.massSignUp();
        
        VolActivityMassSignUpControllerExt controller = testclass.setupController( va );
        
        controller.getUserList( va.id, 0 );
        
        controller.init();
        controller.nextPage();
        controller.prevPage();
        controller.getRenderNext();
        controller.getRenderPrev();
        
        String[] selectedUsers = new String[1];
        selectedUsers[0] = TestCommon.setupUser().id;
        
        controller.setSelUsers( selectedUsers );
        System.assertEquals( controller.getSelUsers().size(), 1 );
        
        controller.getCount();
        controller.fname = 'm';        
        controller.search();
        controller.getUserList( va.id, 5 );
        controller.getRenderNext();
        controller.getRenderPrev();
        
        controller.lname = 'm';
        controller.search();
        controller.getUserList( va.id, 0 );
        controller.getItems();

        controller.fname = 'g';
        controller.lname = 'r';
        controller.search();
        controller.getUserList( va.id, 0 ); 
        controller.getItems();

        controller.fname = 'g';
        controller.lname = 'r';
        controller.dept = 'e';
        controller.search();
        controller.getUserList( va.id, 0 );
        controller.getItems();
        
        controller.nextPage();
        controller.prevPage();
        controller.getRenderNext();
        controller.getRenderPrev();
        
        Test.startTest();
        Test.stopTest();     
    }
}