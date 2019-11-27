// Author: Dallas Grafton
// Date Created/Modified: 01.04.2018
// Project: IMPAX
// Purpose: 
//

public without sharing class IMPAX_Controller {

    private IMPAX__c IMPAX;
  //DAG 01_08_2018 new variables to display Account name on VF pages. Story S-08906.    
    private List<IMPAX__c> IMPAXList = null;
    private List<Account> AcctInfo = null;    
    public String accountId; 
    public String account_name{get;set;}
    public integer num_of_impax_profiles{get;set;}
    public boolean new_flag{get;set;}
    public boolean IMPAX_allowed{get;set;}  //DAG_01_25_2019 New variable. 
  //DAG 01_08_2018 end.
    public IMPAX_Controller(ApexPages.StandardController sc) {
        
        IMPAX = (IMPAX__c)sc.getRecord();
        getAccountInfo();
    }    

    public pageReference insertIMPAX() {
        if (IMPAX.name == null) {
           apexPages.addMessage( new apexPages.Message(apexPages.Severity.Error, 'Error: Must have IMPAX name filled in.'));
           return null;
        } else {       
           IMPAX.Account__c = accountId;
           insert IMPAX;
           pageReference accountPage = new pageReference('/' + IMPAX.Account__c);
           accountPage.setRedirect(True);
           return accountPage;
        }               
    }

    public pageReference updateIMPAX() {
        if (IMPAX.name == null) {
           apexPages.addMessage( new apexPages.Message(apexPages.Severity.Error, 'Error: Must have IMPAX name filled in.'));
           return null;
        } else {       
           update IMPAX;         
           pageReference accountPage = new pageReference('/' + accountid);
           accountPage.setRedirect(True);
           return accountPage;
        }            
    }

    public pageReference cancelIMPAX() {
            
        pageReference accountPage = new pageReference('/' + accountid);
        accountPage.setRedirect(True);
        return accountPage;
               
    }
        
    public pagereference deleteIMPAX() {
        
        pageReference accountPage = new pageReference('/' + accountid);
        delete IMPAX;
            
        accountPage.setRedirect(True);
        return accountPage;
               
    }
    
//  public pageReference insertIMPAXpdf() {
//      
//      IMPAX.Account__c = accountId;
//      insert IMPAX;
//      
//      pageReference pdfPage = new pageReference('/apex/IMPAX_PDF?id=' + IMPAX.Id);
//      pdfPage.setRedirect(True);
//      return pdfPage;
//    
//  }
    //DAG 01_08_2018 New procedure to get Account Name to display on Visualforce input page.
    public void getAccountInfo() {
      new_flag = false;
      if (IMPAX.id == null) {
         accountId = System.currentPageReference().getParameters().get('accountid');
         if (accountid == null) {
            apexPages.addMessage( new apexPages.Message(apexPages.Severity.Error, 'Error: Account ID is not populated.  Please try again, if you still get this error, contact your Salesforce Administrator.  Thank you.'));
         } else {
            IMPAX.Account__c = accountId;
            new_flag = true;
         }
      } else {
      //DAG 01_03_2018 Account ID IS populated when the user is accessing the Input page (from the Salesforce Account page), so can get account name directly from that.
         IMPAXList = [SELECT id, name, account__c from IMPAX__c where id = :IMPAX.id];
         accountid = IMPAXList[0].account__c;
      }
      AcctInfo = [SELECT id, name, of_IMPAX_Profile_s__c from Account where id = :accountId];  //DAG_01_25_2019 Add new field of_IMPAX_Profile_s__c to this select for checking if user is trying to create more than one. 
      account_name = AcctInfo[0].name;      
    //DAG_01_25_2019 New condition.  If IMPAX Already exists for this account, can't create another one. (New rule for 2019). 
      if (AcctInfo[0].of_IMPAX_Profile_s__c > 0) {
         if (new_flag == TRUE) {
            IMPAX_allowed = FALSE;
            apexPages.addMessage( new apexPages.Message(apexPages.Severity.Error, '<p style="font-size:14px"><b><i>'+account_name + ' already has an existing IMPAX profile.  Please refer to the existing IMPAX record and make changes as needed.</i></b></p>'));
         } else {
            IMPAX_allowed = TRUE;
         }
      } else {
         IMPAX_allowed = TRUE;      
      }
    //DAG_01_25_2019 end New condition.     
    }      
}