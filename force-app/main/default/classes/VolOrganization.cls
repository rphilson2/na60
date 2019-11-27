/**
* Utility class for Volunteer Organizations
* @author Matias Menafra
* @createddate 24/06/2010
*/
public with sharing class VolOrganization{

	/**
	* Constructor
	*/
	public VolOrganization(){
	
	}
	
	/**
	* Bulk method which verifies deletion on Volunteer Organizations
	* @param volOrganizations
	*/
	public static void deleteCheckVolunterrOrganization( List<Volunteer_Organization__c> volOrganizations ){
	
		List<Id> organizationIds = new List<Id>();
		for( Volunteer_Organization__c org : volOrganizations ){
			organizationIds.add( org.Id );
		}
		
		List<Volunteer_Activity__c> activityList = [ select Id from Volunteer_Activity__c where Volunteer_Organization__c IN : organizationIds  ];
		
		if( activityList.size() > 0 ){
			volOrganizations.get( 0 ).addError( 'Cannot delete Organizations which have Activities associated with the Organization.' );
		}
	}
}