public with sharing class coileadcontroller {
   
   public COI__c currentRecord {get;set;}
   
   public list <Lead> coiLeadsOpen {get;set;}
   public list <Lead> coiLeadsNotOpen {get;set;}
   public list <Opportunity> coiOpportunities {get;set;}
   public list <Account> coiAccounts {get;set;}
   
   public coileadcontroller(ApexPages.StandardController controller) {
       coiLeadsOpen = [SELECT Id, Name, Company, Email, Status, Owner.Name , Referral_Type__c, Lead_Source_COI__c FROM Lead WHERE Lead_Source_COI__c = :ApexPages.currentPage().getParameters().get('id') AND Status = 'Open'];
       coiLeadsNotOpen = [SELECT Id, Name, Company, Email, Status, Owner.Name , Referral_Type__c, Lead_Source_COI__c FROM Lead WHERE Lead_Source_COI__c = :ApexPages.currentPage().getParameters().get('id') AND Status != 'Open'];
       coiOpportunities = [SELECT Id, Account.Name, Amount, Name, StageName, Owner.Name, Type, CloseDate FROM Opportunity WHERE Lead_Source_COI__c = :ApexPages.currentPage().getParameters().get('id')];
       coiAccounts = [SELECT Id, Name, Owner.Name FROM Account WHERE COI_Source_ID__c = :ApexPages.currentPage().getParameters().get('id')];
              }
}