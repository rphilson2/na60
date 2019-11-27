// Author: Alexander Nourbakhsh
// Date: 07.22.2016
// Project: Unfunded Trust
// Purpose: To allow a series of Visualforce pages access to records that have been "branded"
// as having come from the source Unfunded Trust sObject record. 
//

public class unfundedTrustController {
      
   // sObject list for each page   
   public list<Opportunity> unFundedOpportunities = new List<Opportunity>();
   public list<Account> unFundedAccounts = new List<Account>();
   
   // Boolean for exception handling.
   public boolean renderPage = true;
   
   public unfundedTrustController(ApexPages.StandardController controller) {
   
       try{
            // SOQL statements to build sObject lists                      
            unFundedOpportunities = [SELECT Id, Account.Name, Amount, Name, StageName, Owner.Name, Type, CloseDate, accountId 
                                     FROM Opportunity 
                                     WHERE account.Source_Unfunded_Trust_ID__c = :ApexPages.currentPage().getParameters().get('id')
                                     LIMIT 50000];
                                     
            unFundedAccounts = [SELECT Id, Name, Owner.Name 
                                FROM Account 
                                WHERE Source_Unfunded_Trust_ID__c = :ApexPages.currentPage().getParameters().get('id')
                                LIMIT 50000];         
      
       } catch (exception e) {
           // Set boolean variable renderPage to false to prevent page rendering
           renderPage = false;
       }  
   }
   
   public list <Opportunity> getOpportunities() {
        return unFundedOpportunities;
   }
   
   public list <Account> getAccounts() {
        return unFundedAccounts;
   }
   
   public boolean getRenderPage() {
        return renderPage;
   } 
}