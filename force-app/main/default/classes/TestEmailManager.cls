@isTest
private class TestEmailManager{

    public testmethod static void testSendMessage(){
        
        User user = TestCommon.setupUser();
        
        string address          = 'One Landmark';
        string address2         = 'One Landmark2';
        string personal         = 'Volunteerforce';
        
        Volunteer_Activity__c va        = new Volunteer_Activity__c();
        Volunteer_Organization__c vo    = new Volunteer_Organization__c();
        
        List<InternetAddress> recipients = new List<InternetAddress>();
        
        InternetAddress organizer   = new InternetAddress( address, user.Id );
        InternetAddress viaFrom     = new InternetAddress( address2, user.Id );
        InternetAddress recipient   = new InternetAddress( personal, user.Id );
        
        recipients.add( viaFrom );
        recipients.add( recipient );
        
        Boolean result = EmailManager.sendMessageToParticipantsBatch( vo, va, organizer, recipients, EmailManager.MessageType.mtREMINDER );
        System.assert( !result );
    }
    
    public testmethod static void testSendMassMail(){
        
        User user = TestCommon.setupUser();
        
        string address          = 'One Landmark';
        string address2         = 'One Landmark2';
        string personal         = 'Volunteerforce';
        
        Volunteer_Activity__c va = TestCommon.setupActivity( TestCommon.setupVolunteerOrganization(), 2 );
        
        List<Id> recipients         = new List<Id>();
        InternetAddress organizer   = new InternetAddress( address, user.Id );
        InternetAddress viaFrom     = new InternetAddress( address2, user.Id );
        InternetAddress recipient   = new InternetAddress( personal, user.Id );
        
        recipients.add( user.id );
        recipients.add( user.id );
        recipients.add( user.id );
        
        EmailTemplate[] ets = [ Select Id, IsActive, Name, OwnerId, Subject
                                    from EmailTemplate 
                                    where Name = 'Participant event removed participant' and IsActive = true ];
                                    

    }
}