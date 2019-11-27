/**
* This class contains the common e-mail methods used by Volunteerforce.
*/
public class EmailManager{
	
    public enum MessageType {mtSIGNUP, mtUPDATE, mtREMINDER, mtCANCELLATION, mtREMOVE_USER}

    /**
    * Build the ical meeting request string.
    */
    private static string buildMeetingRequest( Volunteer_Activity__c va, InternetAddress viaOrganizer, InternetAddress viaFrom, InternetAddress viaRecipient,
                    string subject, string body, boolean cancellation ){
                    	
        // Volunteer Activities that are opportunities may not have a datetime value.
        if( va.IsOpportunity__c  && ( va.Date_and_Time__c == null ) ){
            // this is not an error: just return null
            return null;
        }

        string DATETIME_FMT = 'yyyyMMdd\'T\'HHmmss\'Z\'';
        string CRLF 		= '\r\n';

        if( ( viaOrganizer == null ) || ( va == null ) || ( viaFrom == null ) || ( viaRecipient == null ) || ( subject == null ) ){
            return '';
        }
        
        if( viaOrganizer.Address == null ){
            viaOrganizer = viaFrom;
        }
        else if( viaOrganizer.Address.length() == 0 ){
            viaOrganizer = viaFrom;
        }

        string result = 'BEGIN:VCALENDAR' + CRLF;

        result += (cancellation ? 'METHOD:CANCEL' : 'METHOD:REQUEST') + CRLF;

        result += 'PRODID:salesforce.com Volunteerforce' + CRLF;
        result += 'VERSION:2.0' + CRLF;

        result += 'BEGIN:VEVENT' + CRLF;

        string dtstamp = datetime.now().format( DATETIME_FMT );
        result += 'DTSTAMP:' + dtstamp + CRLF;

        if( va.Date_and_Time__c == null ){
            string errmsg = 'ERROR: NULL Volunteer Activity Date_and_Time__c value found.';
            throw new VolException( errmsg );
        }

        string dtstart = va.Date_and_Time__c.formatGmt( DATETIME_FMT );
        result += 'DTSTART:' + dtstart + CRLF;

        result += 'SUMMARY:' + subject + CRLF;
        result += 'UID:' + va.Id + '@salesforce.com' + CRLF;

        if( cancellation ){
            result += 'ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;' + CRLF;
        }else{
            result += 'ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;' + CRLF;
        }
        
        string name = viaRecipient.Personal;
        
        if( ( name == null ) || ( name.length() == 0 ) ){
            name = viaRecipient.Address;
        }
        
        result += ' CN=\"' + name + '\":MAILTO:' + viaRecipient.Address + CRLF;

        name = viaOrganizer.Personal;
        
        if( ( name == null ) || ( name.length() == 0 ) ){
            name = viaOrganizer.Address;
        }
        
        result += 'ORGANIZER;CN=\"' + name + '\":MAILTO:' + viaOrganizer.Address + CRLF;

        if( ( va.Street__c != null ) || ( va.City__c != null ) ){
            result += 'LOCATION:';
            result += buildLocationString( va, true );
            result += CRLF;
        }

        if( body != null ){
        	
            body = body.replace('\n\n', '\n');
            body = body.replace('\n', '\\n');
            result += 'DESCRIPTION:' + body + CRLF;
        }

        datetime dtEndDate = va.Date_and_Time__c;
        
        if( va.Duration_Hours__c != null ){
            Decimal minutes = va.Duration_hours__c * 60;
            dtEndDate 		= dtEndDate.addMinutes( minutes.round().intValue() );
        }
        
        string dtend = dtEndDate.formatGmt( DATETIME_FMT );
        
        result += 'DTEND:' + dtend + CRLF;

        // Remove this once the Date_And_Time__c issue is resolved.
        
        result += 'DTEND:' + dtstamp + CRLF;

        result += 'SEQUENCE:0' + CRLF;
        result += 'PRIORITY:5' + CRLF;
        result += 'CLASS:' + CRLF;

        string created = va.CreatedDate.format(DATETIME_FMT);
        result += 'CREATED:' + created + CRLF;

        string lastmodified = va.LastModifiedDate.format(DATETIME_FMT);
        result += 'LAST-MODIFIED:' + lastmodified + CRLF;

        if( cancellation ){
            result += 'STATUS:CANCELLED' + CRLF;
        }
        else{
            result += 'STATUS:CONFIRMED' + CRLF;
        }

        result += 'TRANSP:OPAQUE' + CRLF;
        result += 'END:VEVENT' + CRLF;
        result += 'END:VCALENDAR' + CRLF;

        return result;
    }

    /**
    * Called by the reminder, update, and cancellation methods. Sends the e-mail messages as a batch call.
    * @param vo
    * @param va
    * @param organizer
    * param recipients
    * @param mt 
    * @return retVal
    */
    public static boolean sendMessageToParticipantsBatch( Volunteer_Organization__c vo, Volunteer_Activity__c va, InternetAddress organizer, List<InternetAddress> recipients, MessageType mt ){

        Boolean retVal = false;
        
        if( ( vo == null ) || ( va == null ) || ( organizer == null ) || ( mt == null ) || ( recipients  == null ) ){
            return false;
        }

        string[] subject = new String[1];
        subject[0] 	= '';
        
        string[] body = new String[1];
        body[0] 	= '';
        
        Id emailTemplateId = EmailManager.getSalesforceTemplateNameForMessageType( mt );
        
        if( ( mt == MessageType.mtCANCELLATION ) || ( mt == MessageType.mtREMOVE_USER ) || ( mt == MessageType.mtSIGNUP ) ){        	
            if( !getMessageText( vo, va, null, mt, subject, body ) ){
                return false;
            }
                        
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            
            for( InternetAddress recipient : recipients ){
            	
            	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                string ical = buildMeetingRequest(
                                va, 
                                organizer, 
                                organizer, 
                                recipient, 
                                subject[0], 
                                body[0], 
                                (mt == MessageType.mtCANCELLATION) || (mt == MessageType.mtREMOVE_USER));
                
	            if( ical != null ){
	            	
	                Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[1];
	                Messaging.EmailFileAttachment fileAttachment 	= new Messaging.EmailFileAttachment();
	                Blob blobIcal = Blob.valueOf( ical );
	                EncodingUtil.base64Encode( blobIcal );
	                fileAttachment.setBody( blobIcal );
	                fileAttachment.setFileName( 'vf_meeting.ics' );
	                fileAttachments[0] = fileAttachment;
	                mail.setFileAttachments( fileAttachments );
	            }               
                
                mail.setTargetObjectId( recipient.UserId );
            
                messages.add( mail );
            }
            
            // ongoing volunteer activities may not have a valid date time value, but we still want
            // to send them an e-mail message, but it will not have a meeting request.
            retVal = sendEmailBatch( messages, va.Id, emailTemplateId );    
            
        }
        else if( ( mt == MessageType.mtREMINDER ) || ( mt == MessageType.mtUPDATE ) ){
            if( !getMessageText( vo, va, null, mt, subject, body ) ){
                return false;
            }
            
            List<Id> idsToSend = new List<Id>();
            
            for( InternetAddress recipient : recipients ){
                idsToSend.add( recipient.UserId );
            }
            
            retVal = sendMassEmail( idsToSend, va.Id, emailTemplateId );
        }
        
        return retVal;
    }

    /**
    * Send the same e-mail message to 1 or more users.
    * @param recipients
    * @param vaId
    * @param templateId
    * @return Boolean
    */
    public static boolean sendMassEmail( List<Id> recipients, Id vaId, Id templateId ){

        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
            mail.setTemplateId( templateId ); 
            mail.setWhatId( vaId );
            mail.setSaveAsActivity( false );
            mail.setUseSignature( true );
            mail.setSenderDisplayName( System.Label.EmailSenderDisplayName );
            mail.setSaveAsActivity( false );
            
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            
            for( Id recipient:recipients ){
                mail.setTargetObjectId( recipient );
                messages.add( mail );
            }
            
            Messaging.sendEmail( messages );
        }
        catch( Exception ex ){
            return false;
        }

        return true;
    }
    
    /**
    * Send a batch of e-mail messages. Each message can be unique and to its own unique set of recipients.
    * @param message
    * @param whatId
    * @param templateId
    * @return Boolean
    */
    public static boolean sendEmailBatch( List<Messaging.SingleEmailMessage> messages, Id whatId, Id templateId ){
        try{
        	// assumes that the following properties are already set for each message
        	// 1) setTargetObjectId
        	// 2) setFileAttachments
        	for( Messaging.SingleEmailMessage mail : messages ){
	            mail.setTemplateId( templateId );
	            mail.setWhatId( whatId );                                    
	            mail.setSaveAsActivity( false );
	            mail.setUseSignature( true );
	            mail.setSenderDisplayName( System.Label.EmailSenderDisplayName );
        	}

            Messaging.sendEmail( messages );
        }
        catch( Exception ex ){
            return false;
        }

        return true;
    }
    
    /**
    * Get the e-mail message body based on its message type.
    * @param vo
    * @param va
    * @param user
    * @param mt
    * @param subject
    * @param body
    * @return Boolean           
    */
    private static boolean getMessageText( Volunteer_Organization__c vo, Volunteer_Activity__c va, User user, EmailManager.MessageType mt, string[] subject, string[] body ){
        
        if( mt == EmailManager.MessageType.mtSIGNUP ){
            subject[0] 	= 'Volunteer Activity: ' + va.Name;
            body[0] 	= 'You have just signed up for the following volunteer activity:\n\n';
            body[0] 	+= buildMeetingInfo(vo, va, user);
        }
        else if( mt == EmailManager.MessageType.mtCANCELLATION ){
            subject[0] 	= 'Volunteer Activity: "' + va.Name + '" Cancelled';
            body[0] 	= 'The volunteer activity "' + va.Name + '" you signed up for, has been cancelled.\n\n';
        }
        else if( mt == EmailManager.MessageType.mtREMINDER ){
            subject[0] 	= 'Volunteer Activity Reminder: ' + va.Name;
            body[0] 	= 'This email is a reminder for the volunteer activity:' + va.Name + ' you signed up for.\n\n';
        }
        else if( mt == EmailManager.MessageType.mtUPDATE ){
            subject[0] 	= 'Volunteer Activity Update: ' + va.Name;
            body[0] 	= 'This email is a update for the volunteer activity:' + va.Name + ' you signed up for.\n\n';
        }
        else if( mt == EmailManager.MessageType.mtREMOVE_USER ){
            subject[0] 	= 'Volunteer Activity: ' + va.Name + ' :Update';
            body[0] 	= 'The Organizer of the volunteer activity:' + va.Name + ' you signed up for, has removed you from the Event. Please contact the Organizer if you have any questions.\n\n';
        }
		
        return true;
    }

    /**
    * Generate the e-mail message's meeting information text.
    * @param vo
    * @param va
    * @param user
    * @return result
    */
    private static string buildMeetingInfo( Volunteer_Organization__c vo, Volunteer_Activity__c va, User user ){
        
        // This is just a subset of the information we want to include here.
        string result 	= 'Activity: ' + va.Name + '\n';
        result 			+= 'Organization: ' + vo.Name + '\n';

        if( va.Duration_hours__c != null ){
            result += 'Duration: ' + va.Duration_hours__c + ' hours\n';
        }

        if( va.Description__c != null ){
            result += '\nDescription: ' + va.Description__c + '\n';
        }

        if( va.Event_Summary__c != null ){
            result += '\nEvent Summary: ' + va.Event_Summary__c + '\n';
        }

        if( ( va.Street__c != null ) || ( va.City__c != null ) ){
            result += '\nLocation: \n';
            result += buildLocationString(va, false);
            result += '\n\n\n';
        }

        return result;
    }

    /**
    * Build the volunteer activity location string for the e-mail message.
    * @param va
    * @param forICAL
    * @return result
    */
    private static string buildLocationString( Volunteer_Activity__c va, boolean forICAL ){
    	
        string result = '';

        if( va.Street__c != null ){
            result += va.Street__c;

            if ( va.City__c != null ){
                result = result + ( foriCAL ? ',' : '\n' );
            }
        }

        if( va.City__c != null ){
            result += va.City__c;

            if( va.State_Province__c != null ){
                result += ',' + va.State_Province__c;

                if( va.Zip_Postal_Code__c != null ){
                    result += ' ' + va.Zip_Postal_Code__c;
                }
            }
        }

        return result;
    }

    /**
    * Build an InternetAddress object from the user object.
    * @param user
    * @return result
    */
    public static InternetAddress buildAddressFromUser( User user ){
        
        InternetAddress result = null;

        if( ( user.Email != null ) && ( user.Email.length() > 0 ) ){
        	
            string personal = null;

            if( ( user.FirstName != null ) && ( user.FirstName.length() > 0 ) && ( user.LastName != null ) && ( user.LastName.length() > 0 ) ){
                personal = user.FirstName + ' ' + user.LastName;
            }
            else if( ( user.FirstName != null ) && ( user.FirstName.length() > 0 ) ){
                personal = user.FirstName;
            }
            else if( ( user.LastName != null ) && ( user.LastName.length() > 0 ) ){
                personal = user.LastName;
            }

            string charset = null;
            if( ( user.EmailEncodingKey != null ) && ( user.EmailEncodingKey.length() > 0 ) ){
                charset = user.EmailEncodingKey;
            }

            try{
                if( personal != null ){
                    if( charset != null ){
                        result = new InternetAddress( user.Email, personal, charset, user.Id );
                    }
                    else{
                        result = new InternetAddress( user.Email, personal, user.Id );
                    }
                }
            }
            catch( Exception ex ){
                result = null;
            }

            if( result == null ){
                try{
                    result = new InternetAddress( user.Email, user.Id );
                }
                catch( Exception ex ){
                    result = null;
                }
            }
        }

        return result;
    }

    /**
    * Get the Salesforce.com e-mail template name for the message type.
    * @param mt
    * @return Id
    */
    private static Id getSalesforceTemplateNameForMessageType( MessageType mt ){
        
        string templateName = null;

        if( mt == MessageType.mtSIGNUP ){
            templateName = 'Participant event signup';
        }
        else if( mt == MessageType.mtCANCELLATION ){
            templateName = 'Participant event cancellation';
        }
        else if( mt == MessageType.mtREMOVE_USER ){
            templateName = 'Participant event removed participant';
        }
        else if( mt == MessageType.mtUPDATE ){
            templateName = 'Participant event update';
        }
        else if( mt == MessageType.mtREMINDER ){
            templateName = 'Participant event reminder';
        }
        else{
            return null;
        }

        // Check to see if the user is already signed up for this activity, and if so, stop processing.
        EmailTemplate[] ets = [ Select Id, IsActive, Name, OwnerId, Subject
                               		from EmailTemplate 
                               		where Name =: templateName and IsActive = true ];

        if ( ets.size() == 0 ){
            return null;
        }

        if ( ets.size() > 1 ){
            return null;
        }

        return ets[0].Id;
    }
}