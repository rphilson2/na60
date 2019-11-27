global class OpportunityExportNotificaPolicyCondition implements TxnSecurity.PolicyCondition {

    public boolean evaluate(TxnSecurity.Event e) {
        //get the user & profile        
        User u = [SELECT Id, Username, UserRoleId, ProfileId FROM User where Id =: e.userId];
        Profile p = [SELECT id, Name FROM Profile WHERE id =: u.ProfileId];
       
       //Test 1: return 'false' if the user profile is a SysAdmin or Integration User       
       switch on p.Name {
           when 'System Administrator' {return false; }
           when 'Custom System Admin' {return false; }
           when 'Integration User' {return false; }
           when 'Enterprise Business Intelligence' {return false; }
       }
       
       //get number of records
       Integer numberOfRecords = Integer.valueOf(e.data.get('NumberOfRecords'));
       
       //Test 2: for non-SysAdmin or IntegrationUser, evaluate the number of records
       Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue();
       if(numberOfRecords > maxExport)
       {
            return true;   
       }
       else
       {
           return false; 
       } 
   }
}