trigger leadTrigger on Lead (before insert) {
   if(trigger.isBefore) {
       if(trigger.isInsert) {
           //Determine if the new leads are from ResourceOne
           Boolean isResourceOneLead = ResourceOneUtilities.isResourceOneRecord(trigger.new);
           
           if (isResourceOneLead) { //Process ResourceOne Leads...
               //a. create a custom Map containing User.Email and User.Id
               UserEmailAndIdMap emailIdMap = new UserEmailAndIdMap();
               
               //b. loop thru all the new Leads; assign the ownerId
               for(Lead l : trigger.new) {
                   l.ownerId = emailIdMap.getUserIdUsingEmailAddress(l.ResourceOneOwnerEmail__c);
               }
           } 
           //else... no special processing for non-ResourceOne Leads
       }
   }
}