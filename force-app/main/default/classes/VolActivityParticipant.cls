/**
* Apex code for the Volunteer Activity Participant custom object.
*/
public class VolActivityParticipant{
    
    /**
    * For the set user reference id, this function sets the VAP's reporting fields
    * based on the current User record values.  These fields include:
    * 1) Department
    * 2) Region
    * 3) Business Unit
    * @param activityParticipants
    */ 
    public static void updateUserReportingFields( List<Volunteer_Activity_Participant__c> activityParticipants ){
    	      
        Map<Id, User> usersId = new Map<Id, User>();
        for( User usr : [ select Id, Business_Unit__c, Department__c, Region__c from User limit 1000 ] ){
        	usersId.put( usr.Id, usr );
        } 
        
       	for( Volunteer_Activity_Participant__c vap : activityParticipants ){
       		
       		if( usersId.get( vap.User__c ) == null ){
       			vap.addError( 'Error setting activity reporting fields.' );
	        }
	         
	        User user = usersId.get( vap.User__c );
	
	        vap.Business_Unit__c 	= user.Business_Unit__c;
	        vap.Department__c 		= user.Department__c;
	        vap.Region__c 			= user.Region__c;
	        
       	}
    }   

    /**
    * Get the volunteer activity participant record.
    * @param vaId
    * @param userId
    * @return Volunteer_Activity_Participant__c
    */ 
    public static Volunteer_Activity_Participant__c getRecordForUser( Id vaId, Id userId ){
    	
        Volunteer_Activity_Participant__c[] vaps = [ select Id,User__c,Volunteer_Activity__c 
                                                    	from Volunteer_Activity_Participant__c 
                                                    	where User__c = :userId and Volunteer_Activity__c =: vaId ];
                                    
        if( vaps.size() == 0 ){
            return null;
        }
        
        return vaps[0];             
    }
}