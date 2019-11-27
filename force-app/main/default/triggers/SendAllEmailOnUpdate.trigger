// When a volunteer activity is updated, send an
// update e-mail message to each volunteer activity participant.
trigger SendAllEmailOnUpdate on Volunteer_Activity__c ( after update ){
                
    List<Volunteer_Activity__c> cancellations 	= new List<Volunteer_Activity__c>();
    List<Volunteer_Activity__c> updates 		= new List<Volunteer_Activity__c>();
    
    // loop thru all of the volunteer activities that are being updated, and
    // identify which are cancellations versus other types of updates
    for( Integer i = 0; i < Trigger.old.size(); i++ ){
        Volunteer_Activity__c vaOld = Trigger.old[i];
        Volunteer_Activity__c vaNew = Trigger.new[i];
                
        if( ( vaold != null) && ( vanew != null ) && ( vaold.Status__c != vanew.Status__c ) && ( vanew.Status__c == System.Label.VolActivityStatusCancelled ) ){           
            // cancellation
            cancellations.add( vaOld );
        }
        else if ((vanew.Notify_Participants__c == true) && 
                 ((vaold.Name != vanew.Name) ||
	              (vaold.Volunteer_Events__c != vanew.Volunteer_Events__c) ||
	              (vaold.Volunteer_Organization__c != vanew.Volunteer_Organization__c) ||
	              (vaold.Date_and_Time__c != vanew.Date_and_Time__c) ||
	              (vaold.Duration_hours__c != vanew.Duration_hours__c) ||
	              (vaold.Street__c != vanew.Street__c) ||
	              (vaold.City__c != vanew.City__c) ||
	              (vaold.State_Province__c != vanew.State_Province__c) ||
	              (vaold.Description__c != vanew.Description__c) ||
	              (vaold.Event_Summary__c != vanew.Event_Summary__c) ))
        {
	        // non-cancellation update
        	updates.add( vaOld );
        }
    }
    
    // Batch process the cancellations and updates.
    if( cancellations.size() > 0 ){
        // send cancellations
        VolActivity.sendCancellationToAllBatch( cancellations, true, true );
    }
    
    if( updates.size() > 0 ){         
        // send non-cancellation updates 
        VolActivity.sendUpdateBatch( updates, EmailManager.MessageType.mtUPDATE );
    }
}