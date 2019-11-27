// Update the reporting fields on the Volunteer Activity Participant record.
// If the insert was not through "Sign Me Up".  Sign Me up already sets these fields.
trigger UpdateReportingFields on Volunteer_Activity_Participant__c ( before insert ){    
	
    // Need to set the dept, business unit, and region.
    VolActivityParticipant.updateUserReportingFields( Trigger.new );
}