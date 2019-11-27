// Author: Alexander Nourbakhsh
// Date: 09.29.2016
// Project: Unfunded Trust/COI 
// Purpose: Separate COI Influence controller that includes Unfunded trusts branded from COI
// Required per Profiles seeing unique page layouts. 
//

public class coiLeadandTrust_Controller {
        
   public list<Lead> coiLeadsOpen = new List<Lead>();
   public list<Lead> coiLeadsNotOpen = new List<Lead>();
   public list<Opportunity> coiOpportunities = new List<Opportunity>();
   public list<Account> coiAccounts = new List<Account>();
   public list<Unfunded_Trust__c> coiFundTrusts = new List<Unfunded_Trust__c>();
   
   // Boolean for exception handling.
   public boolean renderPage = true;
   
   public coiLeadandTrust_Controller(ApexPages.StandardController controller) {
   
       try{
            
            // SOQL statements to build sObject lists                              
            coiLeadsOpen = [SELECT Id, Name, Company, Email, Status, Owner.Name , Referral_Type__c, Lead_Source_COI__c 
                            FROM Lead 
                            WHERE Lead_Source_COI__c = :ApexPages.currentPage().getParameters().get('id') 
                            AND Status = 'Open'
                            LIMIT 50000];
      
            coiLeadsNotOpen = [SELECT Id, Name, Company, Email, Status, Owner.Name , Referral_Type__c, Lead_Source_COI__c 
                               FROM Lead 
                               WHERE Lead_Source_COI__c = :ApexPages.currentPage().getParameters().get('id') 
                               AND Status != 'Open'
                               LIMIT 50000];
                               
            coiOpportunities = [SELECT Id, Account.Name, Amount, Name, StageName, Owner.Name, Type, CloseDate 
                                FROM Opportunity 
                                WHERE Lead_Source_COI__c = :ApexPages.currentPage().getParameters().get('id')
                                LIMIT 50000];
                                
                                
            coiFundTrusts = [SELECT Id, Name, Document_Date__c, Status__c
                             FROM Unfunded_Trust__c
                             WHERE COI__c = :ApexPages.currentPage().getParameters().get('id')
                             LIMIT 50000]; 
            
            List<String> string15Ids = New List<String>();
            
            for(Unfunded_Trust__c unfund : coiFundTrusts) {
            
                String string15Id = String.valueOf(unfund.id).substring(0, 15);               
                string15Ids.add(string15Id);       
            }                             
      
            coiAccounts = [SELECT Id, Name, Owner.Name 
                           FROM Account 
                           WHERE COI_Source_ID__c = :ApexPages.currentPage().getParameters().get('id')
                           OR Source_Unfunded_Trust_ID__c =: string15Ids
                           LIMIT 50000];
                           
       } catch (exception e) {
       
           // Set boolean variable renderPage to false to prevent page rendering
           renderPage = false;
       }  
   }
   
   public list <Lead> getCoiLeadsOpen() {
        return coiLeadsOpen;
   }
   
   public list <Lead> getCoiLeadsNotOpen() {
        return coiLeadsNotOpen;
   }
   
   public list <Opportunity> getCoiOpportunities() {
        return coiOpportunities;
   }
   
   public list <Account> getCoiAccounts() {
        return coiAccounts;
   }
   
   public list <Unfunded_Trust__c> getCoiFundTrusts() {
        return coiFundTrusts;
   }
   
   public boolean getRenderPage() {
        return renderPage;
   } 
}