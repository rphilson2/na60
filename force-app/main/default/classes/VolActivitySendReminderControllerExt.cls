/**
* Controller extension for the Volunteer Activity custom object.
* Send a Volunteer Activity reminder e-mail message to a volunteer activity participant.
*/
public with sharing class VolActivitySendReminderControllerExt{
	
    public Volunteer_Activity__c va;
    public String msg { get; set; }
    public Integer count = 0;
    
    /**
    * Constructor
    * @param stdController
    */
    public VolActivitySendReminderControllerExt( ApexPages.StandardController stdController ){
    	 
        this.va = (Volunteer_Activity__c)stdController.getRecord();
    }
   
    /**
    * Send a reminder e-mail message to all volunteer activity participants.
    * @return PageReference
    */
    public PageReference sendReminder(){
    	
        String vaId 				= ApexPages.currentPage().getParameters().get( 'id' );
        ApexPages.Message result 	= VolActivity.sendUpdate( vaId, EmailManager.MessageType.mtREMINDER );
        this.msg 					= result.getSummary();
        
        ApexPages.addMessage( result );
        
        return null;
    }
    
    /**
    * Method to increment Counter
    * @return PageReference
    */
    public PageReference incrementCounter(){
        count++;
        return null;
    }
    
    /**
    * getter method for count attribute
    * @return count
    */
    public Integer getCount(){
        return count;
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