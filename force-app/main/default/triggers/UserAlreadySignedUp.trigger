// Check to see if each new volunteer activity participant is already signed up.  If so, report an error.
// If no duration value has been specified, this trigger also sets the participant's default duration hours value.
trigger UserAlreadySignedUp on Volunteer_Activity_Participant__c ( before insert ){
    
    for( Volunteer_Activity_Participant__c vap : Trigger.new ){
        if( Trigger.isInsert ){
            // Validate this user signup request.
            ApexPages.Message result = VolActivity.validateUserSignupRequest( vap.Volunteer_Activity__c, vap.User__c, true, true );
            
            if( result.getSeverity() == ApexPages.Severity.ERROR ){
                vap.addError( result.getSummary() );    
                continue;
            }  

            // Populate the volunteer activity participant's duration hours value.
            Volunteer_Activity__c[] vas = [ select Id, City__c, Country__c, Date_and_Time__c, Duration_hours__c, 
                                                    Description__c, LastModifiedDate, CreatedDate, OwnerId,
                                                    Name, State_Province__c, Street__c, Zip_Postal_Code__c, 
                                                    Max_Number_of_Participants__c,Total_Number_of_Participants__c,
                                                    Volunteer_Organization__c, Event_Summary__c 
                                           from Volunteer_Activity__c 
                                           where Id =: vap.Volunteer_Activity__c ];
            
            if( vas.size() > 0 ){
                Volunteer_Activity__c volAct = vas[0];
             
                if( ( vap.Duration_hours__c == null) || (vap.Duration_hours__c == 0 ) ){
                    // set the default duration hours value
                    vap.Duration_hours__c  = volAct.Duration_hours__c;
                }
            }
        }
    }
}