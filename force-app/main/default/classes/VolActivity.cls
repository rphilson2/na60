// Apex code for the Volunteer Activity custom object.
public class VolActivity{
    // Get the volunteer activity record.
    public static Volunteer_Activity__c getRecord( Id vaId ){
    	
        Volunteer_Activity__c[] vas = [ select Id,Status__c, City__c, Country__c, Date_and_Time__c, Duration_hours__c, Description__c,
		                                    LastModifiedDate, CreatedDate, OwnerId, IsOpportunity__c,
		                                    Name, State_Province__c, Street__c, Zip_Postal_Code__c, Max_Number_of_Participants__c, 
		                                    Total_Number_of_Participants__c, Volunteer_Organization__c, Event_Summary__c 
	                                   from Volunteer_Activity__c 
	                                   where Id =: vaId ];
                                    
        if( vas.size() == 0 ){
            return null;
        }

        return vas[0];             
    }
    
    // Returns true if the volunteer activity has already completed.
    static Boolean IsCompleted( Volunteer_Activity__c va ){
        Boolean isCompleted = false;
         
        if( va.Date_and_Time__c != null ){
            datetime dtEndDate = va.Date_and_Time__c;
                
            if( va.Duration_Hours__c != null ){
                Decimal minutes = va.Duration_hours__c * 60;
                dtEndDate 		= dtEndDate.addMinutes( minutes.round().intValue() );
            }            
               
           isCompleted = dtEndDate < DateTime.Now();    
        }
            
        return isCompleted;
    }
    
    // Check to see if we can signup the user.
    public static ApexPages.Message validateUserSignupRequest( Id vaId, Id userId, boolean validateUser, boolean validateActivity ){

        try{
            if( validateUser && ( vaId != null ) && ( userId != null ) ){
                // Check to see if the user is already signed up for this activity, and if so, stop processing.
                if( VolActivityParticipant.getRecordForUser( vaId, userId ) != null){     
                    User[] users = [ select Id, Business_Unit__c, Department__c, Region__c, Name, FirstName, LastName, EmailEncodingKey, Email 
                                    	from User where Id =: userId ];
                                                                
                    string msg = System.Label.SignupUserAlreadySignedUp + users[0].Name;
                    
                    return new ApexPages.Message( ApexPages.Severity.ERROR, msg) ;
                }
            }
 
            if( validateActivity && ( vaId != null ) ){
                // Check to see if a user can signup for this activity.
                Volunteer_Activity__c va = VolActivity.getRecord( vaId );
                
                if( va == null ){                                        
                    string msg = System.Label.SignupFailedVolActivityNotFound + vaId + '';
                                        
                    return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
                }
                                
                // Is the activity cancelled?
                if( va.Status__c == System.Label.VolActivityStatusCancelled ){                    
                    string msg = System.Label.SignupFailedCancelled;                    
                    
                    return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
                }
    
                if( ( va.Total_Number_of_Participants__c != null ) && ( va.Max_Number_of_Participants__c != null ) && ( va.Total_Number_of_Participants__c >= va.Max_Number_of_Participants__c ) ){                    
                    string msg = System.Label.SignupFailedMaxLimitReached + va.Max_Number_of_Participants__c;
                    
                    return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
                }
            }
        }
        catch( Exception ex ){            
            string msg = System.Label.SignupFailedInternalError + ex.getMessage();
            return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
        }
 
        return new ApexPages.Message(ApexPages.Severity.INFO,System.Label.SignupValidationSuccessful);
    }
 
    // Signup a batch of Salesforce users for a Volunteer Activity.
    public static ApexPages.Message signUpBatch( Id vaId, Id[] userIds ){
        String errMsg = null;

        try{ 
            // Validate this user signup request.
            ApexPages.Message result = validateUserSignupRequest( vaId, null, false, true );
            
            if( result.getSeverity() == ApexPages.Severity.ERROR ){
               // user signup validation failed
               return result;
            }  
            
            Volunteer_Activity__c va = VolActivity.getRecord( vaId );
                  
            Double noOfParticipants = va.Total_Number_of_Participants__c;
            Double maxParticipants 	= va.Max_Number_of_Participants__c;
          
            // Create a new ActivityParticipant record with a reference to the current User, to the specified Volunteer Activity
            User[] users = [ select Id, Business_Unit__c, Department__c, Region__c, Name, FirstName, 
                                    LastName, EmailEncodingKey, Email 
                            	from User where Id IN : userIds ]; 
       
            if( users.size() == 0 ){                
                string msg = System.Label.SignupMassFailedNoUsersFounds;
                return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
            }
            
            List<Volunteer_Activity_Participant__c> vapList = new List<Volunteer_Activity_Participant__c>();
  
            for( User user : users ){
                // Check to see if the user is already signed up for this activity, and if so, stop processing.
                result = validateUserSignupRequest( vaId, user.Id, true, false );
                
                if( result.getSeverity() == ApexPages.Severity.ERROR ){
                   // user signup validation failed
                   return result;
                }  

                Volunteer_Activity_Participant__c vap = new Volunteer_Activity_Participant__c(
                                            Volunteer_Activity__c = vaId,
                                            User__c = user.Id,
                                            Duration_hours__c = va.Duration_hours__c );

                if( ( noOfParticipants != null && maxParticipants != null ) && ( noOfParticipants >= maxParticipants ) ){                    
                    string msg = System.Label.SignupMassFailedMaxLimitReached;
                    return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
                } 
 
                // add the user to the volunteer activity
                vapList.add( vap );
                noOfParticipants += 1; 
            }
              
            // Create the new Volunteer Activity Participant records.      
            if( vapList.size() > 0 ){
                insert vapList;
            }
        } 
        catch( Exception ex ){            
            string msg = System.Label.SignupFailedInternalError + ex.getMessage();
            return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
        }
      
        return new ApexPages.Message( ApexPages.Severity.INFO, System.Label.SignupSuccessful );
    }
    
    // Signup a Salesforce user for a Volunteer Activity.
    public static ApexPages.Message signUp( Id vaId, Id userId ){
        ApexPages.Message result = signUpBatch(vaId, new Id [] { userId });
    
        return result;
    }
      
    // Sends a "signed up" e-mail message to the volunteer participant. 
    // This includes an iCalendar meeting request that is included as an attachment.
    // The signups must all be for the same Volunteer Activity.
    public static boolean sendSignupBatch( Volunteer_Activity_Participant__c [] vaps ){
        boolean result = true;
                
        // valid input parameters
        if( ( vaps == null ) || ( vaps.size() == 0 ) || ( vaps[0] == null ) ){
            return false;
        }
        
        // Get the volunteer organization information we need to send the e-mail message.
        Volunteer_Activity__c va = VolActivity.getRecord( vaps[0].Volunteer_Activity__c );
        
        if( va == null ){
        	string msg = System.Label.SignupFailedVolActivityNotFound + vaps[0].Volunteer_Activity__c + '';
        	
            return false;
        }
        
        // Signup messages are not sent if the activity has already completed.
        if( IsCompleted( va ) ){
        	return false;
        }
 
        Volunteer_Organization__c[] vos = [ select Id, Name from Volunteer_Organization__c where Id =: va.Volunteer_Organization__c ];
         
        if( vos.size() == 0 ){
            return false;
        }
      
        Volunteer_Organization__c vo = vos[0];
                          
        // Get the volunteer activity owner's user record.
        User[] owners = [ select Id, Business_Unit__c, Department__c, Region__c, Name, FirstName, LastName, EmailEncodingKey, Email 
                         	from User where Id =: va.OwnerId ]; 
                             
        User owner = owners[0];
                                              
        InternetAddress viaOrganizer = EmailManager.buildAddressFromUser( owner );  
        
        // Create the recipients list
        List<InternetAddress> recipients = new List<InternetAddress>();
        
        for( Volunteer_Activity_Participant__c vap : vaps ){	        
	        try{	                	    	
	            User[] users = [ select Id, Business_Unit__c, Department__c, Region__c, Name, FirstName, LastName, EmailEncodingKey, Email 
	                            	from User where Id =: vap.User__c ]; 
	       
	            if( users.size() == 0 ){
	            	string msg 	= System.Label.SignupFailedUserNotFound + vap.User__c + '';
	                result 		= false;
	                
                    continue;
	            }
	             	                                                 	                      	                     
	            // Send the user a sign-up e-mail message. 
	            recipients.add( EmailManager.buildAddressFromUser( users[0] ) );
	        }
	        catch( Exception ex ){
	        	string msg = System.Label.SignupFailedInternalError + ex.getMessage();
	        }
        }

        if( recipients.size() > 0 ){
            result = EmailManager.sendMessageToParticipantsBatch(
		                            vo, 
		                            va, 
		                            viaOrganizer, 
		                            recipients, 
		                            EmailManager.MessageType.mtSIGNUP);        	
        }
        
        return result;
    }
   
    // Sends a "signed up" e-mail message to the volunteer participant. 
    // This includes an iCalendar meeting request that is included as an attachment.
    public static boolean sendSignup( Id vaId, Id userId ){
        boolean result = true;
        
        try{
            Volunteer_Activity_Participant__c vap = VolActivityParticipant.getRecordForUser( vaId, userId );
            
            if( vap == null ){
                return false;
            }
            
            result = sendSignupBatch( new Volunteer_Activity_Participant__c [] { vap } );
 
        }
        catch( Exception ex ){
        	string msg 	= System.Label.SignupFailedInternalError + ex.getMessage();
            result 		= false;
        }
        
        return result;
    }
     
    // Send volunteer activity update or reminder e-mail messages to 
    // all of the participants for a specific volunteer activity.
    // This method supports batch processing.
    public static ApexPages.Message sendUpdateBatch( Volunteer_Activity__c [] updates, EmailManager.MessageType mt ){
    	
            	
        // Input parameter validation
        if( ( updates == null ) || ( updates.size() == 0 ) ){
        	
            string msg = System.Label.InvalidParameter;
            
            return new ApexPages.Message( ApexPages.Severity.ERROR, msg );    	
        }
        
        ApexPages.Message result = null;
        
        for( Volunteer_Activity__c va : updates ){
	        try{
	            // Check to see if the Event is cancelled.
	            if( va.Status__c == System.Label.VolActivityStatusCancelled ){                
	                string msg = ( mt == EmailManager.MessageType.mtUPDATE ) ? 
	                           System.Label.UpdateFailedEventCancelled :
	                           System.Label.ReminderFailedEventCancelled;
	                
	                result = new ApexPages.Message( ApexPages.Severity.ERROR, msg );   
	                continue;
	            }
	            
	            // Check to see if this activity has already completed.  If so, don't send an update.
	            if( VolActivity.IsCompleted( va ) ){
	            	                
	                string msg = ( mt == EmailManager.MessageType.mtUPDATE ) ? 
	                              System.Label.UpdateFailedEventCompleted :
	                              System.Label.ReminderFailedEventCompleted;
	                
	                result = new ApexPages.Message( ApexPages.Severity.ERROR, msg );
	                continue;
	            }
	        
	            // Get the volunteer organization information we need to send the e-mail message.
	            Volunteer_Organization__c[] vos = [ select Id, Name 
	                                               		from Volunteer_Organization__c 
	                                               		where Id =: va.Volunteer_Organization__c ];
	             
	            if( vos.size() == 0 ){
	            	               
	                string msg = ( ( mt == EmailManager.MessageType.mtUPDATE ) ? 
	                               System.Label.UpdateFailedOrganizationNotFound :
	                               System.Label.ReminderFailedOrganizationNotFound )
	                              + va.Volunteer_Organization__c + '';
	                
	                
	                result = new ApexPages.Message( ApexPages.Severity.ERROR, msg );
	                continue;
	            }
	       
	            Volunteer_Organization__c vo = vos[0];
	            
	            // Get all participants to send update email.
	            Volunteer_Activity_Participant__c[] vaps = [ select Id, User__c 
	                                                        		from Volunteer_Activity_Participant__c 
	                                                        		where Volunteer_Activity__c =: va.Id ];
	            
	            List<String> userIds = new List<String>();
	            // If there are no participants, do nothing.
	            if( vaps.size() == 0 ){
	            	                
	                string msg = ( mt == EmailManager.MessageType.mtUPDATE ) ? 
	                              System.Label.UpdateSuccessfulNoParticipants : 
	                              System.Label.ReminderSuccessfulNoParticipants;
	                              
	                return result = new ApexPages.Message( ApexPages.Severity.ERROR, msg );
	            }
	
	            for( Volunteer_Activity_Participant__c vap: vaps ){
	                userIds.add( vap.User__c );   
	            }
	
	            User[] owners = [ select Id, Business_Unit__c, Department__c, Region__c, Name, FirstName, LastName, EmailEncodingKey, Email 
	                             	from User where Id =: va.OwnerId ];
	                             
	            User owner;
	            
	            if( owners.size() > 0 ){
	                 owner = owners[0];             
	            }
	            
	            InternetAddress viaOrganizer = EmailManager.buildAddressFromUser( owner );
	            
	            User[] users = [ select Id, Business_Unit__c, Department__c, Region__c, Name, FirstName, LastName, EmailEncodingKey, Email
	                            	from User where Id in: userIds ]; 
	                     
	            List<InternetAddress> recipients = new List<InternetAddress>(); 
	            
	            for( User participant : users ){
	                recipients.add( EmailManager.buildAddressFromUser( participant ) );
	            }
	
	            // Send the users an update message.
	            EmailManager.sendMessageToParticipantsBatch(
	                            vo, 
	                            va, 
	                            viaOrganizer, 
	                            recipients, 
	                            mt);
	                            
	        }
	        catch( Exception ex ){
	        	
	            string msg = ( ( mt == EmailManager.MessageType.mtUPDATE ) ? 
	                           System.Label.UpdateFailedInternalError :
	                           System.Label.ReminderFailedInternalError )
	                          + ex.getMessage();
	            
	            result = new ApexPages.Message( ApexPages.Severity.ERROR, msg );
	        }
        }
 
        if( result != null ){
        	return result;
        }

        return new ApexPages.Message( ApexPages.Severity.INFO, 
                                ( mt == EmailManager.MessageType.mtUPDATE ) ? 
                                 System.Label.UpdateSuccessfulAllParticipants :
                                 System.Label.ReminderSuccessfulAllParticipants ); 
    }
    
    // Send an event update to all signed up participants for the event.
    public static ApexPages.Message sendUpdate( Id vaId, EmailManager.MessageType mt ){
        ApexPages.Message result = null;
        
        try{        
	        Volunteer_Activity__c va = VolActivity.getRecord( vaId );
	        
	        if( va == null ){                
	            string msg = System.Label.RequestFailedVolActivityNotFound + vaId + '';             
	            return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
	        }
	                    
	        result = sendUpdateBatch( new Volunteer_Activity__c [] { va }, mt );
        }
        catch( Exception ex ){
            string msg = ((mt == EmailManager.MessageType.mtUPDATE) ? 
                           System.Label.UpdateFailedInternalError : 
                           System.Label.ReminderFailedInternalError)
                          + ex.getMessage();
            
            result = new ApexPages.Message( ApexPages.Severity.ERROR, msg );
        }
        
        return result;            
    }
    
    // Cancels a volunteer activity and sends a plain text email to all of the activity's participants.
    // The email message includes all the relevant information about the activity: name, date/time, description, account, location, etc.
    // It does not send a cancellation e-mail message if the volunteer activity already completed: start datetime + duration.
    public static ApexPages.Message sendCancellationToAll( String vaId, Boolean ignoreCancelledCheck ){
        
        Volunteer_Activity__c va = VolActivity.getRecord( vaId );
        ApexPages.Message result = sendCancellationToAllBatch( new Volunteer_Activity__c[] { va }, false, ignoreCancelledCheck );          
           
        return result;
    }

    // Send volunteer activity cancellation notice to all of the participants for a specific volunteer activity.
    // This method supports batch processing.
    // PARAMETERS:
    //  vas - array of volunteer activities that will be cancelled
    //  readonly - is the vas array readonly
    //  ignoreCancelledCheck - if true, do not check to see if the event is already cancelled
    public static ApexPages.Message sendCancellationToAllBatch( Volunteer_Activity__c [] vas, Boolean readonly, Boolean ignoreCancelledCheck ){
                        
        // validate input parameters
        if( vas == null ){                
            string msg = System.Label.InvalidParameter;
            return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
        }
                   
        ApexPages.Message result = null;
        
        // create two lists for the records that we will batch update
        List<Volunteer_Activity__c> vaBatch = new List<Volunteer_Activity__c>();
        
        List<Volunteer_Activity_Participant__c> vapBatch = new List<Volunteer_Activity_Participant__c>();
                    
        for( Volunteer_Activity__c va : vas ){
            // Nesting this try-catch so that we catch the exceptions 
            // at the volunteer activity level.
	        try{
	        	if( va == null ){
		            string msg 	= System.Label.InvalidParameter;
		            result 		= new ApexPages.Message( ApexPages.Severity.ERROR, msg );
		            
		            continue;
	        	}
	        	
	            // Check to see if the activity was already cancelled.
	            if( !ignoreCancelledCheck && ( va.Status__c == System.Label.VolActivityStatusCancelled ) ){                
	                string msg 	= System.Label.CancellationVolActivityAlreadyCancelled;
	                result 		= new ApexPages.Message( ApexPages.Severity.ERROR, msg );
	                
	                continue;
	            }
	
	            // A cancellation message will only be sent if the volunteer activity is either
	            // 1) not started
	            // 2) is actively in-progress
	            if( VolActivity.IsCompleted( va ) ){
	                continue;
	            }
                
                // Get the volunteer organization information we need to send the e-mail message.
                Volunteer_Organization__c[] vos = [ select Id, Name from Volunteer_Organization__c where Id =: va.Volunteer_Organization__c ];
                 
                if( vos.size() == 0 ){                    
                    string msg 	= System.Label.CancellationFailedVolOrganizationNotFound + va.Volunteer_Organization__c + '';
                    result 		= new ApexPages.Message( ApexPages.Severity.ERROR, msg );
                    
                    va.addError( msg );
                    
                    continue;
                }
              
                Volunteer_Organization__c vo = vos[0];
                
                // Get all volunteer activity participants for this volunteer 
                // activity so that we can send them a cancellation e-mail message.
                Volunteer_Activity_Participant__c[] vaps = [ select Id, User__c, Duration_hours__c 
                                                            		from Volunteer_Activity_Participant__c 
                                                            		where Volunteer_Activity__c =: va.Id];
                
                List<String> userIds = new List<String>();
                
                // If there are no participants, just set the status to 'Cancelled' and return to caller.
                if( vaps.size() == 0 ){
                    if( !readonly && ( va.Status__c != System.Label.VolActivityStatusCancelled ) ){
                        va.Status__c = System.Label.VolActivityStatusCancelled;   
	                    vaBatch.add( va ); 
                    }
                    
                    continue;                    
                }
                
                // When an activity is cancelled, set all volunteer activity participants duration field to 0.
                for( Volunteer_Activity_Participant__c vap : vaps ){
                    userIds.add( vap.User__c );
                    vap.Duration_hours__c = 0;
                    vapBatch.add( vap );
                }
	
                // Send all volunteer activity participants a cancellation e-mail message.
                User[] owners = [ select Id, Business_Unit__c, Department__c, Region__c, Name, FirstName, LastName, EmailEncodingKey, Email 
                                 	from User where Id =: va.OwnerId ];
                                       
                User owner;
                
                if( owners.size() > 0 ){
                    owner = owners[0];             
                }
                
                InternetAddress viaOrganizer = EmailManager.buildAddressFromUser( owner );
                
                User[] users = [ select Id, Business_Unit__c, Department__c, Region__c, Name, FirstName, LastName, EmailEncodingKey, Email 
                                	from User where Id IN : userIds ]; 
                         
                List<InternetAddress> recipients = new List<InternetAddress>(); 
                
                for( User participant : users ){
                    recipients.add( EmailManager.buildAddressFromUser( participant ) );
                }

	            if( !readonly && ( va.Status__c != System.Label.VolActivityStatusCancelled ) ){
                    // This "update" will cause a cancellation message to be sent when
                    // the batch update is applied and the SendAllEmailOnUpdate fires.
                    va.Status__c = System.Label.VolActivityStatusCancelled;            
                    vaBatch.add( va );
	            }
	            else{
	            	// send the cancellation message
                    EmailManager.sendMessageToParticipantsBatch(
                                    vo, 
                                    va, 
                                    viaOrganizer, 
                                    recipients, 
                                    EmailManager.MessageType.mtCANCELLATION);	            	
	            }
	        }
	        catch( Exception ex ){            
	            string msg 	= System.Label.CancellationFailedInternalError + ex.getMessage();
	            result 		= new ApexPages.Message( ApexPages.Severity.ERROR, msg );
	            
	            va.addError( msg );
	        }
	    } 
       
        try{
            update vaBatch;
        }
        catch( DmlException ex ){                            
            string msg 	= System.Label.CancellationStatusUpdateFailure;
            result 		= new ApexPages.Message( ApexPages.Severity.ERROR, msg );
        }

        try{
            update vapBatch;
        }
        catch( DmlException ex ){                                    
            string msg 	= System.Label.CancellationFailedParticipantsCouldNotUpdateDuration;
            result 		= new ApexPages.Message( ApexPages.Severity.ERROR, msg );
        }
        
        if ( result == null ){
        	// If no errors, report success.
            return new ApexPages.Message( ApexPages.Severity.INFO, System.Label.CancellationSuccessful );
        }
        
        return result;
    }

    // Send volunteer activity cancellation notice to each specified volunteer activity participant.
    //
    // For this method, it is assumed that the user was removed from the volunteer activity, and 
    // the user will be sent a removal message.
    //
    // PARAMETERS:
    //
    //  vaps - volunteer participants to send the message to.  
    //         All elements in the list need to be for the same volunteer activity record.
    //
    // This method supports batch processing.
    public static Boolean sendCancellationToUserRemovedBatch( Volunteer_Activity_Participant__c [] vaps ){
 
        // valid input parameters
        if( ( vaps == null ) || ( vaps.size() == 0 ) || ( vaps[0] == null ) ){
        	string msg = System.Label.InvalidParameter;
        	return false;
        }
        
        // Get the volunteer activity and organization information we need to send the e-mail messages.
        Volunteer_Activity__c va = VolActivity.getRecord( vaps[0].Volunteer_Activity__c );
        
        if( va == null ){
            string msg = System.Label.CancellationFailedVolActivityNotFound + vaps[0].Volunteer_Activity__c + '';
            return false;
        }

        Volunteer_Organization__c[] vos = [ select Id, Name from Volunteer_Organization__c where Id =: va.Volunteer_Organization__c ];
         
        if( vos.size() == 0 ){
            string msg = System.Label.CancellationFailedVolOrganizationNotFound + va.Volunteer_Organization__c + '';
            return false;
        }
   
        Volunteer_Organization__c vo = vos[0];
        User[] owners = [ select Id, Business_Unit__c, Department__c, Region__c, Name, FirstName, LastName, EmailEncodingKey, Email 
                         	from User where Id =: va.OwnerId ];
                               
        User owner;
        
        if( owners.size() > 0 ){
             owner = owners[0];             
        }
        
        // Create a recipient list
        List<InternetAddress> recipients = new List<InternetAddress>();
                     
        for( Volunteer_Activity_Participant__c vap : vaps ){	        
	        try{
                Id userId = vap.User__c;
	            
	            User[] users = [ select Id, Business_Unit__c, Department__c, Region__c, Name, FirstName, LastName, EmailEncodingKey, Email 
	                            	from User where Id =: userId ]; 

                if( users.size() == 1 ){
                    recipients.add( EmailManager.buildAddressFromUser( users[0] ) );     
                }
	        }
	        catch( Exception ex ){
	        	string msg = System.Label.CancellationFailedInternalError + ex.getMessage();
	        	
	        }
        }
        
        // Send the cancellation messages
        Boolean result = EmailManager.sendMessageToParticipantsBatch(
				                       vo, 
				                       va, 
				                       EmailManager.buildAddressFromUser(owner), 
				                       recipients, 
				                       EmailManager.MessageType.mtREMOVE_USER);
 
        return result; 
    }
                
    // Send volunteer activity cancellation notice to a specific volunteer activity participant.
    //
    // For this method, it is assumed that the user was removed from the volunteer activity, and 
    // the user will be sent a removal message.
    public static Boolean sendCancellationToUserRemoved( Id vaId, Id userId ){
        // valid input parameters
        if( ( vaId == null ) || ( userId == null ) ){
        	return false;
        }

        Boolean result = false;

        try{
	        Volunteer_Activity_Participant__c[] vaps = [ select Id, Name, User__c,Volunteer_Activity__c
	                                                    	from Volunteer_Activity_Participant__c 
	                                                    	where Volunteer_Activity__c =: vaId and User__c =: userId ];
	                                                                                      
	        result = sendCancellationToUserRemovedBatch( vaps );
        }
        catch( Exception ex ){
        	string msg 	= System.Label.CancellationFailedInternalError + ex.getMessage();
        	result 		= false;
        }

        return result;
    }

    // updateTimeDate - called by UpdateTimeDate.page
    public static ApexPages.Message updateTimeDate( Id vaId, String datestr ){
        try{
            Volunteer_Activity__c[] vas = [ select Id, Date_and_Time__c, Duration_hours__c, Status__c 
                                           		from Volunteer_Activity__c where Id =: vaId ];
                                                    
            // Check to see if the activity was already cancelled
            if( vas.size() == 0 ){                
                string msg = System.Label.UpdateFailedVolActivityNotFound + vaId + '';
                
                return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
            }
                               
            Volunteer_Activity__c va = vas[0];
            
            if( va.Status__c == System.Label.VolActivityStatusCancelled ){                
                string msg = System.Label.UpdateFailedEventCancelled;
                
                return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
            }
                                    
            va.Date_and_Time__c = datetime.valueOf( datestr );
            
            update va;
            
        } 
        catch( Exception ex ){            
            string msg = System.Label.UpdateFailedInternalError + ex.getMessage();
            
            return new ApexPages.Message( ApexPages.Severity.ERROR, msg );
        }
    
        return new ApexPages.Message( ApexPages.Severity.INFO, System.Label.UpdateSuccessfulDateAndTime );
    }

    // Used for mass sign up
    public static Set<String> getSignedUpUsers( Id vaId, List<User> userIds ){
        Volunteer_Activity_Participant__c[] vaps = [ select Id,User__c 
                                                    	from Volunteer_Activity_Participant__c 
                                                    	where User__c IN : userIds and Volunteer_Activity__c =: vaId ];
        
        Set<String> signedUpUsers = new Set<String>();
        
        for( Volunteer_Activity_Participant__c vap : vaps ){
            signedUpUsers.add( vap.User__c );
        }
        
        return signedUpUsers;
    }
     
    // Check to see if the current Salesforce user has create privilege
    // for the volunteer activity object. 
    public static Boolean CurrentUserHasCreatePermission{     
        get{
            if( CurrentUserHasCreatePermission == null ){
                VolActivity.loadMetadata();
            }
            
            return CurrentUserHasCreatePermission;
        } 
        set;
    }
    
    // Custom object id prefix for the Volunteer Activity custom object.
    public static string KeyPrefix{
        get{
            if( KeyPrefix == null ){
                VolActivity.loadMetadata();
            }
            
            return KeyPrefix;
        } 
        set;
    }
 
    // Get needed meta data information for the volunteer activity custom object.
    private static void loadMetadata(){
    	
        Schema.DescribeSObjectResult vaResult = null;
        Schema.DescribeSObjectResult voResult = null;
        
        VolActivity.CurrentUserHasCreatePermission = false;
       
        try{
            // To determine if a user has access to an object, do a global describe, and that will return the 
            // objects that the class has access to in a map.  Look for the activities class there. if it isn't, 
            // then the user doesn't have access to it.  Make sure that the class (the controller) is "with share" implicitly.
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe(); 
            
            Schema.SObjectType sobjectType = schemaMap.get('Volunteer_Activity__c');
            
            if( sobjectType == null ){
                return;
            }
                
            vaResult 				= sobjectType.getDescribe();
            VolActivity.KeyPrefix 	= vaResult.keyPrefix;
                
            if( !vaResult.createable ){
                return;
            }
            
            // Check the volunteer organization.
            sobjectType = schemaMap.get('Volunteer_Organization__c');
            
            if( sobjectType == null ){
                return;
            }
            
            voResult = sobjectType.getDescribe();            
            
            if( !voResult.createable ){
                return;
            }
        }
        catch( Exception ex ){
            return;
        }
        
        VolActivity.CurrentUserHasCreatePermission = true;
    } 
    
    // Return the URL for the Volunteerforce image logo that is stored as a Salesforce document.
    public static string getVolunteerforceImageUrl(){

        Document doc = [ select d.Id from Document d where d.Name = 'Volunteerforce logo'  limit 1 ];

        string imageid = doc.id; 
                                  
        return '/servlet/servlet.FileDownload?file=' + imageid.substring( 0, 15 );
    }     
}