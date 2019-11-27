trigger VolunteerOrganizationBeforeDelete on Volunteer_Organization__c ( before delete ){
	
	VolOrganization.deleteCheckVolunterrOrganization( Trigger.old );
}