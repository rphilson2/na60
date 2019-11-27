/**
* Sign me up controller extension for the Volunteer Activity custom object.
*/
public with sharing class VolActivitySignMeUpControllerExt{   
	 
    Volunteer_Activity__c va;
    public String msg 	{ get; set; }
    public String vaId 	{ get; set; }
    
    /**
    * Constructor
    * @param stdController
    */
    public VolActivitySignMeUpControllerExt( ApexPages.StandardController stdController ){ 
        this.va = (Volunteer_Activity__c)stdController.getRecord();
    }
    
    /**
    * Method performs signups
    * @return PageReference
    */
    public PageReference signUp(){
        vaId = va.Id; 
        
        String uId = UserInfo.getUserId();
        
        ApexPages.Message result = VolActivity.signUp( vaId, uId );
   
        this.msg = result.getSummary();
        
        ApexPages.addMessage( result );
        
        return null;
    }
    
    /**
    * Return the URL for the Volunteerforce image logo that is stored as a Salesforce document.
    * @return String
    */
    public string getVolunteerforceImageUrl{  
        get{
            return VolActivity.getVolunteerforceImageUrl();
        }
    }    
}