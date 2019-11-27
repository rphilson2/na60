/**
* This controller is used to mass signup users for a specific Volunteer Activity.
*/
public with sharing class VolActivityMassSignUpControllerExt{
	
    private Volunteer_Activity__c va;
    public String name 	{ get; set; }
    public String id 	{ get; set; }
    public Integer noOfParticipants { get; set; }
    public Integer noOfMaxParticipants { get; set; }
    public Integer size { get; set; }
    public Integer noOfRecordsToBeDisplayed { get; set; }
    public static Integer maxRecordsPerPage = 25;
    public Integer index { get; set; }
    
    public String fname { get; set; }
    public String lname { get; set; }
    public String dept 	{ get; set; }
   	
   	/**
   	* constructor
   	* @param stdController
   	*/
    public VolActivityMassSignUpControllerExt( ApexPages.StandardController stdController ){ 
    	
        this.va = (Volunteer_Activity__c) stdController.getRecord();
		init();        
    }   
    
    /** 
    * Count Query Method
    * @return Integer
    */
    private Integer countQuery(){
    	
        if( fname != null && fname != '' && lname != null && lname != '' && dept != null && dept != '' ){
            return [ select count() from User 
                    	where isActive = true and FirstName like : fname+'%' and LastName like : lname+'%' and Department like : dept+'%' ];
        
        } 
        else if( fname != null && fname != '' && lname != null && lname != '' ){
            return [ select count() from User where isActive = true and FirstName like : fname+'%' and LastName like : lname+'%' ];
                    
        } 
        else if( fname != null && fname != '' && dept != null && dept != '' ){          
            return [ select count() from User where isActive = true and FirstName like : fname+'%' and Department like : dept+'%' ];
        } 
        else if( lname != null && lname != '' && dept != null && dept != '' ){
            return [ select count() from User where isActive = true and LastName like : lname+'%' and Department like : dept+'%' ];
        } 
        else if( fname != null && fname != '' ){
            return [ select count() from User where isActive = true and FirstName like : fname+'%' ];
        } 
        else if( lname != null && lname != '' ){
            return [ select count() from User where isActive = true and LastName like : lname+'%' ];
        } 
        else if( dept != null && dept != '' ){
            return [ select count() from User where isActive = true and Department like : dept+'%' ];
        } 
        else {
            return [ select count() from User where isActive = true ];
        }
    }
    
    /**
    * Results Query
    * @param limitRows
    * @param next
    * @return retUserList
    */
    private List<User> resultsQuery( Integer limitRows, Integer next ){
    	
        String query = ' select Id,name,City,FirstName,LastName,Department '+
                                     ' from User '+
                                     ' where isActive=true ';
                                     
        String orderQuery = ' order by name '+ 
        					' limit ' + limitRows ;                             
        
        Integer rowCount = 0;
        List<User> retUserList = new List<User>();
                
        if( fname != null && fname != '' && lname != null && lname != '' && dept != null && dept != '' ){
            for( List<User> users : [ select Id,name,City,FirstName,LastName,Department 
                                     	from User 
                                     	where isActive=true and FirstName like : fname+'%' and LastName like : lname+'%' and Department like : dept+'%' 
                                     	order by name 
                                     	limit : limitRows ] ){
                for( User usr : users ){
                    if( rowCount >= next ){
                        retUserList.add( usr );
                    }
                    rowCount++;
                }
            }
        }else if( fname != null && fname != '' && lname != null && lname != '' ){
        	
            for( List<User> users : [ select Id,name,City,FirstName,LastName,Department 
                                     	from User 
                                     	where isActive=true and FirstName like : fname+'%' and LastName like : lname+'%' 
                                     	order by name 
                                     	limit : limitRows ] ) 
            {
                for( User usr : users ){
                    if( rowCount >= next ){
                        retUserList.add( usr );
                    }
                    rowCount++;
                }
            }
        } 
        else if( fname != null && fname != '' && dept != null && dept != '' ){
        	
            for( List<User> users : [ select Id,name,City,FirstName,LastName,Department 
                                     	from User 
                                     	where isActive=true and FirstName like : fname+'%' and Department like : dept+'%' 
                                     	order by name 
                                     	limit : limitRows ] ){
                for( User usr : users ){
                    if( rowCount >= next ){
                        retUserList.add( usr );
                    }
                    rowCount++;
                }
            }
        } 
        else if( lname != null && lname != '' && dept != null && dept != '' ){
            for( List<User> users : [ select Id,name,City,FirstName,LastName,Department 
                                     	from User 
                                     	where isActive=true and LastName like : lname+'%' and Department like : dept+'%' 
                                     	order by name 
                                     	limit : limitRows ] ){
                for( User usr : users ){
                    if( rowCount >= next ){
                        retUserList.add( usr );
                    }
                    rowCount++;
                }
            }
        } 
        else if( fname != null && fname != '' ){
            for( List<User> users : [ select Id,name,City,FirstName,LastName,Department 
                                     	from User 
                                     	where isActive=true and FirstName like : fname+'%' 
                                     	order by name 
                                     	limit : limitRows ] ){
                for ( User usr : users ){
                    if ( rowCount >= next ){
                        retUserList.add( usr );
                    }
                    rowCount++;
                }
            }
        } 
        else if( lname != null && lname != '' ){
            for( List<User> users : [ select Id,name,City,FirstName,LastName,Department 
                                     	from User 
                                    	where isActive=true and LastName like : lname+'%' 
                                     	order by name 
                                     	limit : limitRows ] ){
                for( User usr : users ){
                    if( rowCount >= next ){
                        retUserList.add( usr );
                    }
                    rowCount++;
                }
            }
        } 
        else if( dept != null && dept != '' ){
            for( List<User> users : [ select Id,name,City,FirstName,LastName,Department 
                                     	from User 
                                     	where isActive=true and Department like : dept+'%' 
                                     	order by name 
                                     	limit : limitRows ] ){
                for( User usr : users ){
                    if( rowCount >= next ){
                        retUserList.add( usr );
                    }
                    rowCount++;
                }
            }
        } 
        else{
            for( List<User> users : [ select Id,name,City,FirstName,LastName,Department 
                                     	from User 
                                     	where isActive=true 
                                     	order by name limit : limitRows ] ){
                for( User usr : users ){
                    if( rowCount >= next ){
                        retUserList.add( usr );
                    }
                    rowCount++;
                }
            }
        }
        
        return retUserList;
    }
    
    /**
    * getter method for count
    * @return 
    */ 
    public Integer getCount(){
        return countQuery();
    }
    
    /**
    * gets the users list
    * @param id
    * @param nect
    * @return List<User>
    */     
    public List<User> getUserList( String id, Integer next ){    
        Integer rowCount 	= 0;       
        Integer totRows 	= next + maxRecordsPerPage;
        
        return resultsQuery( totRows, next );
    }
    
    /**
    * Mass Sign up method
    * @return pageRef
    */    
    public PageReference massSignUp(){
    	
        String vaId = va.Id;
        ApexPages.Message res;
            
        if( selUsers.size() > 0 ){
            res = VolActivity.signUpBatch( vaId, selUsers );            
            id 	= vaId;
            
            Double totalParticipants 	= va.Total_Number_of_Participants__c;
            noOfParticipants 			= totalParticipants.intValue();            
        } 
        else{
            res = new ApexPages.Message( ApexPages.Severity.ERROR, System.Label.SignupMassSelectAtLeastOneUser );
        }
        
        if( res != null ){
            ApexPages.addMessage( res );
            return null;       
        }
                
        PageReference pageRef = Page.VolActivityMassSignUpPage;
        pageRef.getParameters().put( 'id', vaId );        
        pageRef.setredirect( true );
        
        return pageRef;
    }

    String[] selUsers = new String[]{};
    
    /**
    * Retrieves all items
    * @param 
    * @return 
    */ 
    public List<SelectOption> getItems(){      

        List<SelectOption> options = new List<SelectOption>();
        if( index == null ){
            index = 0;
        }
        List<User> allUsers 		= getUserList( va.Id, index );
        Set<String> signedUpUsers 	= VolActivity.getSignedUpUsers( va.Id, allUsers );
        Integer lssize 				= allUsers.size();  
        
        if( size > index+maxRecordsPerPage ){
            noOfRecordsToBeDisplayed = index+maxRecordsPerPage;
        }else{
            noOfRecordsToBeDisplayed = lssize;
        }
        Integer lSize = ( noOfRecordsToBeDisplayed < lssize?noOfRecordsToBeDisplayed:lssize );
        
        for( Integer i = 0; i < lSize; i++ ){
            User u 				= allUsers[i];   
            Boolean signedUp 	= false;
            if( signedUpUsers.contains( u.Id ) ){
            	signedUp = true;
            }
            String displayValue = u.Name;
            if( u.City != null ){
                displayValue += ' | ' + u.City;
            }
            if( signedUp ){
                options.add( new SelectOption( u.Id, displayValue, true ) );
            }else{
                options.add( new SelectOption( u.Id, displayValue ) );
            }
        }
        
        return options;
    }
    
    /**
    * Returns selected Users
    * @param 
    * @return 
    */ 
    public String[] getSelUsers(){
        return selUsers;
    }
	
	/**
    * Setter for selected users
    * @param 
    * @return 
    */ 
    public void setSelUsers( String[] selUsers ){
        this.selUsers = selUsers;
    }
    
    /**
    * Init Method
    * @param 
    * @return 
    */ 
    public void init(){

        id 		= va.Id;
        name 	= va.Name;        
        
        Double totalParticipants = va.Total_Number_of_Participants__c;
        if( totalParticipants != null ){
            noOfParticipants = totalParticipants.intValue();
        } 
        Double maxParticipants = va.Max_Number_of_Participants__c;
        if( maxParticipants != null ){
            noOfMaxParticipants = maxParticipants.intValue();
        } 
        size 	= getCount();
        index 	= 0;
    }
    
    /**
    * Search attribute setter
    * @param 
    * @return 
    */ 
    public void search(){
        size 	= getCount();
        index 	= 0;
    }
    
    /**
    * changes to next page
    * @param 
    * @return 
    */ 
    public void nextPage(){
    	
        if( index == null ) index = 0;
        index = ( index + maxRecordsPerPage );
        if( index > size ){
            index = size;
        }
    }
    
    /**
    * changes to previous page
    * @param 
    * @return 
    */ 
    public void prevPage(){
    	
        index = ( index - maxRecordsPerPage );
        if( index < 0 ){
            index = 0;
        }
    }
    
    /**
    * Method that determines to render next link
    * @param 
    * @return 
    */  
    public Boolean getRenderNext(){
    	
        if( index == null ){
            index = 0;
        }
        if( index + maxRecordsPerPage >= size ){
            return false;
        }
        return true;
    } 
    
    /**
    * Method that determines to render previous link
    * @param 
    * @return 
    */ 
    public Boolean getRenderPrev(){
    	        
        if( index > 0 ){
            return true;
        }
        return false;
    }
    
    /**
    * Method gets Max number of Participants
    * @param 
    * @return 
    */ 
    public Boolean getRenderMaxParticipants(){
    	
        if( noOfMaxParticipants != null && noOfMaxParticipants > 0 ){
            return true;
        }
        return false;
    } 
}