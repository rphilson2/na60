// Notify each participant that the volunteer activity has been cancelled.
trigger SendAllEmailOnDelete on Volunteer_Activity__c ( before delete ){	
	
    VolActivity.sendCancellationToAllBatch( Trigger.old, true, false );
}