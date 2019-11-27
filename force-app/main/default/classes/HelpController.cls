/**
* Controller for use in redirecting the help Links
* @author Matias Menafra
* @createddate 22/06/2010
*/
public with sharing class HelpController{
	
	private Pagereference page;
	
	/**
	* Constructor
	*/
	public HelpController(){

	}
	
	/**
	* Redirects to organization contact help page
	* @return Pagereference
	*/
	public Pagereference helpOrganizationContact(){
		this.page = new Pagereference('http://www.salesforce.com/docs/en/volunteerforce/index_CSH.htm#volunteerforce_orgcontacts.htm');
		return this.page;
	}
	
	/**
	* Redirects to organization help page
	* @return Pagereference
	*/
	public Pagereference helpOrganization(){
		this.page = new Pagereference('http://www.salesforce.com/docs/en/volunteerforce/index_CSH.htm#volunteerforce_organizations.htm');
		return this.page;
	}
	
	/**
	* Redirects to Activity help page
	* @return Pagereference
	*/
	public Pagereference helpActivity(){
		this.page = new Pagereference('http://www.salesforce.com/docs/en/volunteerforce/index_CSH.htm#volunteerforce_activities.htm');
		return this.page;
	}
	
	/**
	* Redirects to the Participant help page
	* @return Pagereference
	*/
	public Pagereference helpParticipant(){
		this.page = new Pagereference('http://www.salesforce.com/docs/en/volunteerforce/index_CSH.htm#volunteerforce_participants.htm');
		return this.page;
	}
	
	public static testmethod void testRedirects(){
		
		HelpController controller 	= new HelpController();
		Pagereference page;
		
		page = controller.helpActivity();
		System.assert( page != null );
		
		page = controller.helpOrganization();
		System.assert( page != null );
		
		page = controller.helpOrganizationContact();
		System.assert( page != null );
		
		page = controller.helpParticipant();
		System.assert( page != null );
	}
}