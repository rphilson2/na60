/**
* Cancel volunteer activity controller.
*/
public with sharing class VolActivityCancelControllerExt{
	    
    Volunteer_Activity__c va;
    Integer count = 0;
    
    public String msg { get; set; }
    
    /**
    * Contructor 
    * @param stdController
    */
    public VolActivityCancelControllerExt( ApexPages.StandardController stdController ){ 
        this.va = ( Volunteer_Activity__c )stdController.getRecord();
    }
    
    /**
    * Cancels all activities
    * @return PageReference
    */
    public PageReference sendCancellationToAll(){
    	
        String vaId 				= ApexPages.currentPage().getParameters().get('id');
        ApexPages.Message result 	= VolActivity.sendCancellationToAll(vaId, false);
        
        this.msg = result.getSummary();
        
        ApexPages.addMessage( result );
        
        return null;
    }
    
    /**
    * Increments counter 
    * @return PageReference
    */        
    public PageReference incrementCounter(){
        count++;
        return null;
    }
    
    /**
    * Getter Method for count
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