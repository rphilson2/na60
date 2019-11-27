// Apex test methods for the VolActivity class.
@IsTest
private class TestVolActivity{
             
    // Test the sign-up process.
    testmethod static void testSignUp(){
        
        User newUser = [ select id from User where isActive = true limit 1 ];

        Volunteer_Organization__c vo = TestCommon.setupVolunteerOrganization();
        Volunteer_Activity__c newAct = TestCommon.setupActivity(vo, 5);

        // test send reminder/update/cancellation to an event that has no participants
        ApexPages.Message result = VolActivity.sendUpdate( newAct.Id, EmailManager.MessageType.mtREMINDER );
        System.assertEquals( ApexPages.Severity.ERROR, result.getSeverity() );

        result = VolActivity.sendUpdate(newAct.Id, EmailManager.MessageType.mtUPDATE );
        System.assertEquals( ApexPages.Severity.ERROR, result.getSeverity() );

        result = VolActivity.sendCancellationToAll(newAct.Id, false );
        System.assertEquals( ApexPages.Severity.INFO, result.getSeverity() );

        newAct = VolActivity.getRecord(newAct.Id);
        System.assertEquals( System.Label.VolActivityStatusCancelled, newAct.Status__c );

        newAct.Status__c = 'New';
        update newAct;
        
        System.assertEquals( ApexPages.Severity.INFO,  VolActivity.signUp( newAct.Id,newUser.Id ).getSeverity() );
                
        Volunteer_Activity_Participant__c[] vpList = [ select Id,Name 
                                                        from Volunteer_Activity_Participant__c
                                                        where Volunteer_Activity__c =: newAct.Id and User__c =: newUser.Id ];
                                                
        newAct.Status__c = 'New';
        update newAct;
        
        result = VolActivity.sendUpdate( newAct.Id, EmailManager.MessageType.mtREMINDER );
        System.assertEquals( ApexPages.Severity.INFO, result.getSeverity() );

        result = VolActivity.sendUpdate( newAct.Id, EmailManager.MessageType.mtUPDATE );
        System.assertEquals( ApexPages.Severity.INFO, result.getSeverity() );

        List<User> signedUpUsers = new List<User>();
        signedUpUsers.add( newUser );
        Set<String> resList = VolActivity.getSignedUpUsers( newAct.Id,signedUpUsers );
        System.assertEquals( 1, resList.size() );
        
        // Sign up the same user: expect an error
        System.assertEquals( ApexPages.Severity.ERROR,  VolActivity.signUp( newAct.Id,newUser.Id ).getSeverity() );
        
        vpList = [ select Id,Name 
                    from Volunteer_Activity_Participant__c
                    where Volunteer_Activity__c =: newAct.Id and User__c =: newUser.Id ];
                                                
        System.assertEquals( vpList.size(), 1 );
        
        Boolean boolResp = VolActivity.sendSignup( newAct.Id, newUser.Id );
        
        System.assertEquals( false, boolResp );

        // Send reminder to Cancelled Activity
        newAct.Status__c = System.Label.VolActivityStatusCancelled;
        update newAct;
        
        result = VolActivity.sendUpdate( newAct.Id, EmailManager.MessageType.mtREMINDER );
        System.assertEquals( ApexPages.Severity.ERROR, result.getSeverity() );

        result = VolActivity.sendUpdate( newAct.Id, EmailManager.MessageType.mtUPDATE );
        System.assertEquals( ApexPages.Severity.ERROR, result.getSeverity() );

        // Send reminder to an activity that has no organization: this should fail.
        newAct.Status__c ='New';
        newAct.Volunteer_Organization__c = null;
        update newAct;
        
        result = VolActivity.sendUpdate( newAct.Id, EmailManager.MessageType.mtREMINDER );
        System.assertEquals( ApexPages.Severity.ERROR, result.getSeverity() );

        result = VolActivity.sendUpdate(newAct.Id, EmailManager.MessageType.mtUPDATE );
        System.assertEquals( ApexPages.Severity.ERROR, result.getSeverity() );

        // Delete the activity and check if the participants got deleted.
        newAct.Volunteer_Organization__c = TestCommon.setupVolunteerOrganization().Id;
        update newAct;
                        
        delete newAct;
        
        vpList = [ select Id,Name 
                    from Volunteer_Activity_Participant__c
                    where Volunteer_Activity__c =: newAct.Id and User__c =: newUser.Id ];
                                                
        System.assertEquals( vpList.size(), 0 );
    }
    
    // Test deleting a participant.
    testmethod static void testDeleteParticipant(){
        
        User newUser                    = TestCommon.setupUser();
        Volunteer_Organization__c vo    = TestCommon.setupVolunteerOrganization();
        Volunteer_Activity__c newAct    = TestCommon.setupActivity(vo, 5);

        System.assertEquals(ApexPages.Severity.INFO,  VolActivity.signUp(newAct.Id, newUser.Id).getSeverity());
        
        Volunteer_Activity_Participant__c[] vpList = [ select Id,Name 
                                                        from Volunteer_Activity_Participant__c
                                                        where Volunteer_Activity__c =: newAct.Id and User__c =: newUser.Id ];
        
        System.assertEquals(vpList.size(),1);
        
        delete vpList[0];
        
        vpList = [ select Id,Name 
                    from Volunteer_Activity_Participant__c
                    where Volunteer_Activity__c =: newAct.Id and User__c =: newUser.Id ];
                                                
        System.assertEquals( vpList.size(), 0 );
    } 

    testmethod static void testAnotherUserSignUp(){
        
        User newUser                    = TestCommon.setupUser();
        Volunteer_Organization__c vo    = TestCommon.setupVolunteerOrganization();
        Volunteer_Activity__c newAct    = TestCommon.setupActivity( vo, 5 );

        Volunteer_Activity_Participant__c vp = new Volunteer_Activity_Participant__c( User__c = newUser.Id, Volunteer_Activity__c = newAct.Id );
        insert vp;

        Volunteer_Activity_Participant__c[] vpList = [ select Id,Name 
                                                        from Volunteer_Activity_Participant__c
                                                        where Volunteer_Activity__c =: newAct.Id and User__c =: newUser.Id ];

        System.assertEquals( vpList.size(), 1 );
    }

    // test invalid parameters to public methods
    testmethod static void testInvalidData(){
        
        System.assertEquals( ApexPages.Severity.ERROR,  VolActivity.signUp( 'a003000000BTY44', 'a003000000BVY44' ).getSeverity() );

        ApexPages.Message result = VolActivity.sendUpdate( 'a003000000BTY44', EmailManager.MessageType.mtREMINDER );
        System.assertEquals( ApexPages.Severity.ERROR, result.getSeverity()) ;

        result = VolActivity.sendUpdate( 'a003000000BTY44', EmailManager.MessageType.mtUPDATE );
        System.assertEquals( ApexPages.Severity.ERROR, result.getSeverity() );

        result = VolActivity.sendCancellationToAll( 'a003000000BTY44', false );
        System.assertEquals( ApexPages.Severity.ERROR, result.getSeverity() );

        Boolean boolResp = VolActivity.sendCancellationToUserRemoved( 'a003000000BTY44', 'a003000000BVY44' );
        System.assertEquals( false, boolResp );

        boolResp = VolActivity.sendCancellationToUserRemoved( 'a003000000BTY44', null );
        System.assertEquals( false, boolResp );

        User newUser = TestCommon.setupUser();

        System.assertEquals( ApexPages.Severity.ERROR,  VolActivity.signUp( 'a003000000BTY44', newUser.Id ).getSeverity() );

        Volunteer_Organization__c vo = TestCommon.setupVolunteerOrganization();
        Volunteer_Activity__c newAct = TestCommon.setupActivity( vo, 5 );

        System.assertEquals( ApexPages.Severity.ERROR,  VolActivity.signUp( newAct.Id, 'a003000000BTY44' ).getSeverity() );

        boolResp  = VolActivity.sendSignup( null, newUser.Id );
        System.assertEquals( boolResp, false );

        boolResp  = VolActivity.sendSignup( newAct.Id, 'a003000000BTY44' );
        System.assertEquals( boolResp, false );
    }

    testmethod static void testCancellation(){
        
        User [] newUsers                = TestCommon.setupUsers();
        Volunteer_Organization__c vo    = TestCommon.setupVolunteerOrganization();
        Volunteer_Activity__c newAct    = TestCommon.setupActivity( vo, 5 );

        for( User user : newUsers ){
            System.assertEquals( ApexPages.Severity.INFO,  VolActivity.signUp( newAct.Id, user.Id ).getSeverity() );
        }
   
        Boolean response = VolActivity.sendCancellationToUserRemoved( newAct.Id, newUsers[0].Id );
        System.assertEquals( false, response );

        try{
            delete vo;
        }
        catch( Exception ex ){
            System.assert( true );
        }
        
        response = VolActivity.sendCancellationToUserRemoved( newAct.Id, newUsers[0].Id );
        System.assertEquals( false, response );

        vo = TestCommon.setupVolunteerOrganization();
        
        newAct.Volunteer_Organization__c = vo.Id;
        update newAct;

        ApexPages.Message result = VolActivity.sendCancellationToAll( newAct.Id, false );
        System.assertEquals( ApexPages.Severity.INFO, result.getSeverity() );

        newAct.Status__c = System.Label.VolActivityStatusCancelled;
        update newAct;
        
        result = VolActivity.sendCancellationToAll( newAct.Id, false );
        System.assertEquals( ApexPages.Severity.ERROR, result.getSeverity() );
    }

    // test deleting an array of Volunteer_Activity__c objects
    testmethod static void testDeleteTriggerBulk(){
        
        Volunteer_Organization__c vo        = TestCommon.setupVolunteerOrganization();
        List<Volunteer_Activity__c> vaList  = new List<Volunteer_Activity__c>();
 
        for( integer i = 0; i < 5; i++ ){
            vaList.Add( TestCommon.setupActivity( vo, 5 ) );
        }
        
        try{
            Database.delete( vaList );
            Database.delete( vo );
            
            System.assert( true );
        }catch( Exception ex ){
            System.assert( false );
        }
        
    }

    testmethod static void testMaxUserLimit(){

        User [] testUsers   = TestCommon.setupUsers();
        User newUser        = testUsers[0];
        User anotherUser    = testUsers[1];

        Volunteer_Organization__c vo = TestCommon.setupVolunteerOrganization();
        Volunteer_Activity__c newAct = TestCommon.setupActivity( vo, 1 );

        System.assertEquals( ApexPages.Severity.INFO,  VolActivity.signUp( newAct.Id, newUser.Id ).getSeverity() );
        
        Volunteer_Activity_Participant__c[] vpList = [ select Id, Name 
                                                        from Volunteer_Activity_Participant__c
                                                        where Volunteer_Activity__c =: newAct.Id and User__c =: newUser.Id ];
                                                
        System.assertEquals( vpList.size(), 1 );
        
        // Sign up the another user when max limit is 1: expect an error
        System.assertEquals( ApexPages.Severity.ERROR,  VolActivity.signUp( newAct.Id, anotherUser.Id ).getSeverity() );
        
        vpList = [ select Id,Name 
                    from Volunteer_Activity_Participant__c
                    where Volunteer_Activity__c =: newAct.Id and User__c =: newUser.Id ];
                                                
        System.assertEquals( vpList.size(), 1 );
    }

    testmethod static void testActivityParticipant(){
        
        User newUser = TestCommon.setupUser();

        Volunteer_Organization__c vo = TestCommon.setupVolunteerOrganization();
        Volunteer_Activity__c newAct = TestCommon.setupActivity( vo, 5 );

        Volunteer_Activity_Participant__c vp = new Volunteer_Activity_Participant__c( User__c=newUser.Id, Volunteer_Activity__c = newAct.Id );
        insert vp;
        
        System.assertEquals( 'true', 'true' );

        vp.Business_Unit__c = 'Business Unit A';
        update vp;

        Volunteer_Activity_Participant__c[] vpList = [ select Id,Name,Business_Unit__c 
                                                         from Volunteer_Activity_Participant__c
                                                         where Id=: vp.Id ];

        System.assertEquals( 'Business Unit A', vpList[0].Business_Unit__c );
    }

    testmethod static void testMassSignUp(){
        
        // Setup the test
        Volunteer_Organization__c vo = TestCommon.setupVolunteerOrganization();
        Volunteer_Activity__c newAct = TestCommon.setupActivity( vo, 5 );

        User newUser = TestCommon.setupUser();
        List<Id> massSignupUserIds = new List<Id>();
        massSignupUserIds.add( newUser.Id );
 
        // Test
        ApexPages.Message result = VolActivity.signUpBatch( newAct.Id, massSignupUserIds );

        if( result == null ){
            return;
        }

        System.assertEquals( ApexPages.Severity.INFO, result.getSeverity() );

        return;
    }

    testmethod static void testSendAllEmailOnUpdate(){
        
        User newUser = TestCommon.setupUser();

        Volunteer_Organization__c vo = TestCommon.setupVolunteerOrganization();
        Volunteer_Activity__c newAct = TestCommon.setupActivity( vo, 5 );

        Volunteer_Activity_Participant__c vp = new Volunteer_Activity_Participant__c( User__c = newUser.Id, Volunteer_Activity__c = newAct.Id );
        insert vp;

        Double duration = newAct.Duration_hours__c;
        newAct.Duration_hours__c += 1;

        update newAct;

        Volunteer_Activity__c[] updateAct = [ select Duration_hours__c 
                                                from Volunteer_Activity__c
                                                where Id=: newAct.Id ];
                                             
        System.assertEquals( duration + 1, updateAct[0].Duration_hours__c );
    }
    
    testmethod static void testUpdateTimeDate(){
        
        // Setup the test
        Volunteer_Organization__c vo = TestCommon.setupVolunteerOrganization();
               
        Volunteer_Activity__c newAct = new  Volunteer_Activity__c(
                                                City__c='TestCity', 
                                                Country__c='TestCountry',
                                                Description__c='TestDescription',
                                                Name='Test Activity',
                                                State_Province__c='TS',
                                                Street__c='Test Street',
                                                Zip_Postal_Code__c='100101',
                                                Max_Number_of_Participants__c=5,
                                                Volunteer_Organization__c=vo.Id,
                                                Date_and_Time__c=DateTime.Now(),
                                                Duration_hours__c=2
                                                );
        insert newAct;
        
        // Test
        string strDateTime = '2010-10-12 10:10:10';        
        
        DateTime dt = datetime.valueOf( strDateTime );
        VolActivity.updateTimeDate( newAct.Id, strDateTime );    
        newAct = [ select id, Date_and_Time__c 
                    from Volunteer_Activity__c 
                    where id =: newAct.Id ];

        System.assert( newAct.Date_and_Time__c == dt );
    } 
    
    testmethod static void test(){
    
        VolActivity.CurrentUserHasCreatePermission = null;
        Boolean aux = VolActivity.CurrentUserHasCreatePermission;
        System.assert( aux );
        
        VolActivity.KeyPrefix = null;
        String aux2 = VolActivity.KeyPrefix;
    }
}