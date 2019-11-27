public with sharing class naicssearchcontroller {  
   public list <NAICS__c> naics {get;set;}  
   public string searchstring {get;set;}  
   public naicssearchcontroller(ApexPages.StandardController controller) {  
   }  
   public void search(){  
     string searchquery='select id,Name,NAICS_Code__c,Description__c from NAICS__c where NAICS_Code__c like \'%'+searchstring+'%\' OR Description__c like \'%'+searchstring+'%\' Limit 80';  
     naics= Database.query(searchquery);  
   }  
   public void clear(){  
   naics.clear();  
   }  
 }