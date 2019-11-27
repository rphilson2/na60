/**
* This class is the controller behind the Activity Quick Create wizard.
*/
public with sharing class VolActivityQuickCreateController{
	
    // These three class variables maintain the state of the wizard.
    // When users enter data into the wizard, their input is stored
    // in these variables.
    String npoStatus = 'Active';
	
	/**
    * Constructor
    */ 
    public VolActivityQuickCreateController(){
        this.activityType = 'e';
    }

	/**
    * Getter setter method for orgId
    * @return 
    */ 
    public String orgId{ 
        get; 
        set{
            this.orgId = value;
        }
    }
    
    /**
    * Getter setter method for npo
    * @return Volunteer_Organization__c
    */ 
    public Volunteer_Organization__c npo{
        get{
            if( this.npo == null ){
                this.npo = new Volunteer_Organization__c();
            } 
            
            return this.npo;
        }
        set;
    }
    
    /**
    * Getter setter method for oc
    * @return Organization_Contact__c
    */ 
    public Organization_Contact__c oc{
        get{
            if( this.oc == null ){
                this.oc = new Organization_Contact__c();
            }
            
            return this.oc;
        }
        set;
    }
    
    /**
    * getter setter method for va
    * @return Volunteer_Activity__c
    */ 
    public Volunteer_Activity__c va{
        get{
            if( this.va == null ){
                this.va = new Volunteer_Activity__c();
            }
            
            return this.va;
        }
        set;
    }
    
    /**
    * Getter Setter for activityType
    * @return String
    */ 
    public String activityType{
        get;
        set;
    }
    
    /**
    * Generate the list of activity types used within the wizard.
    * @return options
    */ 
    public List<SelectOption> getActivityTypes(){
    	
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add( new SelectOption( 'e', System.Label.VolActivityWizardActivityTypeVolEvent ) ); 
        options.add( new SelectOption( 'o', System.Label.VolActivityWizardActivityTypeOngoingOpp ) ); 
        options.add( new SelectOption( 'n', System.Label.VolActivityWizardActivityTypeOngoingOppNoLoc ) ); 
        
        return options; 
    }

    /**
    * Dynamically generate the categories from the Feature_Category__c object.
    * @return optionList
    */ 
    public List<SelectOption> getOrgIds(){
    	
        List<SelectOption> optionList = new List<SelectOption>();
        
        // Add a null option to force the user to make a selection.
        optionList.add( new SelectOption( '', '- New -' ) );
        
        for (Volunteer_Organization__c fc : [ select id, name from Volunteer_Organization__c order by Name limit 1000  ] ){
            optionList.add( new SelectOption( fc.id, fc.name ) );
        }
        
        return optionList;
    }
    
    /**
    * Method for refreshing org fields
    * @return PageReference
    */ 
    public PageReference refreshOrgFields(){
    	
        if( orgId == null ){
            this.npo = new Volunteer_Organization__c();
        } 
        else{
            this.npo = [ select id, name, Parent_Organization__c, Organization_Cause__c, Website__c, Phone__c, 
                                Fax__c, Description__c, Street__c, City__c, State_Province__c, Zip_Postal_Code__c, Country__c 
                        	from Volunteer_Organization__c 
                        	where Id =: orgId ] ;
        }
        
        // returning null indicates the same page should be returned
        return null;
    }
    
    /**
    * Navigation
    * @return PageReference
    */ 
    public PageReference step1(){
        return Page.VolActivityQuickCreate_npo;
    }
    
    /**
    * Navigation
    * @return PageReference
    */ 
    public PageReference step2(){
        return Page.VolActivityQuickCreate_contact;
    }
    
    /**
    * Navigation
    * @return PageReference
    */ 
    public PageReference step3(){
        return Page.VolActivityQuickCreate_activity;
    }
    
    /**
    * Navigation
    * @return PageReference
    */ 
    public PageReference step4(){
    	
        this.va.IsOpportunity__c =! activityType.equals( 'e' );

        return Page.VolActivityQuickCreate_activitydetail;
    }
  
    /**
    * Cancel the volunteer activity creation and send the user to the volunteer activity list page.
    * @return activityPage
    */ 
    public PageReference cancel(){
        PageReference activityPage = new PageReference( '/' + VolActivity.KeyPrefix + '/o' );
        activityPage.setRedirect( true );
        
        return activityPage;
    }
    
    /**
    * This method performs the final save for all three objects, and
    * then navigates the user to the detail page for the new activity.
    * @return PageReference
    */ 
    public PageReference save(){     
        // transaction control.
        Savepoint sp = Database.setSavePoint();
        
        // Keeping copies of the variables because rollback destroys them.
        Volunteer_Organization__c backup_npo 	= ( this.npo != null ) ? this.npo.clone( true, true ) : null;
        Organization_Contact__c backup_contact 	= ( this.oc != null ) ? this.oc.clone( true, true ) : null;
        Volunteer_Activity__c backup_activity 	= ( this.va != null ) ? this.va.clone( true, true ) : null;
        
        try{
            // Create the organization
            this.npo.Status__c = 'Active';
            upsert this.npo;
            
            // Create the contact
            this.oc.Primary_Contact__c = true;
            
            this.oc.Volunteer_Organization__c = this.npo.id;
            
            insert this.oc;
            
            // Create the activity
            this.va.Primary_Contact__c = this.oc.id;
            
            this.va.Volunteer_Organization__c = this.npo.id;
            
            insert this.va;
        } 
        catch( Exception ex ){
            ApexPages.addMessages( ex );
            Database.rollback( sp );
            this.npo 	= backup_npo;
            this.oc 	= backup_contact;
            this.va 	= backup_activity;
            
            return null;
        }
        
        // Send the user to the view page for the new activity.
        ApexPages.StandardController controller = new ApexPages.StandardController( this.va );
        
        return controller.view();        
    }

    /**
    * Should we redirect to the no permission page.
    * @return PageReference
    */ 
    public PageReference displayNoPermPage(){
    	   
        if( VolActivity.CurrentUserHasCreatePermission ){
            return null;
        }

        return Page.VolActivityQuickCreateSecurity_noperm;
    }   
}