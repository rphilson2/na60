trigger AddOrRemoveParticipant on Volunteer_Activity_Participant__c ( after insert, after delete ){     
	
    if( Trigger.isInsert ){
        // Sends the meeting invitation if the insert was not through "Sign Me Up".  
        // Sign Me up already sends the meeting invite.
        VolActivity.sendSignupBatch( Trigger.new );
    }
    else if( Trigger.isDelete ){
        // Also sends a "user removed" e-mail message to a volunteer activity participant when they are
        // deleted from a volunteer activity.
        VolActivity.sendCancellationToUserRemovedBatch( Trigger.old );
    }   
}