@istest
public class compCodeTest {
  @istest
  static void compCodeAccount(){
    //08/08/2019 Added as part of test class fix -begin
    List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
    TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
    accountTriggerSupportSetting.Name = 'Account';
    accountTriggerSupportSetting.TriggerIsDisabled__c = true;
    triggerSupportList.add(accountTriggerSupportSetting);
    insert triggerSupportList;
    //08/08/2019-end    
    Comp_Code__c compCode1 = new Comp_Code__c(
    name = 'C');    
    insert compCode1;
    
    Comp_Code__c compCode2 = new Comp_Code__c(
    name = 'A');    
    insert compCode2;
    
    Account compAccount = new Account(
    name = 'comp', DunsNumber = '12345', Vertical__c = '1', Sub_vertical__c = '' );
    insert compAccount; 
    
    List<Account>updateCompAccounts = new List<Account>{[SELECT Id, Comp_Package_Code__c FROM Account]};
                                                                  
        for(Account acct : updateCompAccounts) {
        acct.Sub_vertical__c = 'd';
        }
		update updateCompAccounts; 
     Account updateAccounts = [SELECT Id FROM Account where Sub_vertical__c = 'd' limit 1];
     System.assert( updateAccounts.Id != null );
  	}                                                               
    
}