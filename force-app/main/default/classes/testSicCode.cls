@isTest()
public class testSicCode {
	@TestSetup
    static void setupData() {   
        //08/08/2019 Added as part of test class fix -begin
      	List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
       	accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
       //08/08/2019-end
     }
    @isTest
    public static void testSicCode(){
   
        List<Account> insertAccounts = New List<Account>();
        Account medical = new Account(name = 'Medical', DUNS_Number__c = '123a', sic = '8011');
        insertAccounts.add(medical);
        
        Account nurses  = new Account(name = 'Nurses', DUNS_Number__c = '123b', sic = '8049');
        insertAccounts.add(nurses);

        Account trade  = new Account(name = 'Trade', DUNS_Number__c = '123c', sic = '8631');
        insertAccounts.add(trade);
        
        Account education  = new Account(name = 'education', DUNS_Number__c = '123d', sic = '8621');
        insertAccounts.add(education);
        
        Account general  = new Account(name = 'general', DUNS_Number__c = '123e', sic = '6541');
        insertAccounts.add(general);
        
        Account fourYear  = new Account(name = '4year', DUNS_Number__c = '123f', sic = '8221');
        insertAccounts.add(fourYear);
        
        Account twoYear  = new Account(name = '2year', DUNS_Number__c = '123g', sic = '8222');
        insertAccounts.add(twoYear);
        
        Account miligro  = new Account(name = 'miligro', DUNS_Number__c = '123h', sic = '9711');
        insertAccounts.add(miligro);
        
        Account frat  = new Account(name = 'frat', DUNS_Number__c = '123i', sic = '8641');
        insertAccounts.add(frat);
        
        Account spec  = new Account(name = 'spec', DUNS_Number__c = '123j', sic = '6331');
        insertAccounts.add(spec);

        Account othe  = new Account(name = 'othe', DUNS_Number__c = '123k', sic = '6361');
        insertAccounts.add(othe);
   
      	Account doNothing = new Account(name = 'donothing', DUNS_Number__c = '123l',  sic = '0000');
        insertAccounts.add(doNothing); 
      
        insert insertAccounts;
        
       doNothing.sic = '0001';
        update doNothing;
        
        medical.sic = '8299';
        update medical;
        
        nurses.sic = '8631';
        update nurses;
        
        trade.sic = '8049';
        update trade;
        
        education.sic = '6541';
        update education;
        
        general.sic = '8621';
        update general;
        
        fouryear.sic = '8222';
        update fouryear;
        
        twoyear.sic = '8221';
        update twoyear;
           
        miligro.sic = '8641';
        update miligro;
        Account testmiligro = [SELECT sic FROM Account WHERE name = 'miligro'][0];
        System.assertEquals('8641', testmiligro.sic);
 

        frat.sic = '9711';
        update frat;
        Account testfrat = [SELECT sic FROM Account WHERE name = 'frat'][0];
        System.assertEquals('9711', testfrat.sic);
 

        spec.sic = '6351';
        update spec;
		Account testspec = [SELECT sic FROM Account WHERE name = 'spec'][0];
        System.assertEquals('6351', testspec.sic); 
        
        othe.sic = '6331';
        update othe;
        Account test = [SELECT sic FROM Account WHERE name = 'Othe'][0];
        System.assertEquals('6331', test.sic);

    }
    }