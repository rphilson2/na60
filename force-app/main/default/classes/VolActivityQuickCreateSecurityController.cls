/** This controller is used with the Activity Quick Create wizard.
* This controller is used for the security authorization error screen that is displayed
* when an end-user does not have authorization to create new volunteer activity custom objects.
*/
public class VolActivityQuickCreateSecurityController{
	
	/**
	* Redirect to the volunteer activity list page.
	* @return activityPage
	*/
    public PageReference next(){
    	  
        PageReference activityPage = new PageReference( '/' + VolActivity.KeyPrefix + '/o' );
        activityPage.setRedirect( true );
        
        return activityPage;
    }   
}