// Author: Alexander Nourbakhsh
// Date Created/Modified: 01.31.2017
// Project: POSI Grid
// Purpose: 
//

public without sharing class POSI_Controller {

    private POSI__c POSI;
  //DAG 01_03_2018 new variables to display Account name on VF pages. Story S-08904.
    private List<POSI__c> POSIlist = null;
    private List<Account> AcctInfo = null;
    public String accountId;
    public String POSIId;
    public String POSI_AccountId;  
    public string account_name{get; set;} 
  //DAG 01_03_2018 end.
    
    public POSI_Controller(ApexPages.StandardController sc) {
        
        POSI = (POSI__c)sc.getRecord();
        accountId = System.currentPageReference().getParameters().get('accountid');
        getAccountInfo(); //DAG 01_03_2018 new procedure. 
        
    }    

    public pageReference insertPOSI() {
        POSI.Account__c = accountID;
        insert POSI;
        pageReference accountPage = new pageReference('/' + posi.Account__c);
        accountPage.setRedirect(True);
        return accountPage;
               
    }
    
    public pageReference updatePOSI() {
          
        update POSI;
            
        pageReference accountPage = new pageReference('/' + posi.Account__c);
        accountPage.setRedirect(True);
        return accountPage;
               
    }
    
    public pageReference deletePOSI() {
        
        pageReference accountPage = new pageReference('/' + POSI.Account__c);
        delete POSI;
        accountPage.setRedirect(True);
        return accountPage;
               
    }
    //DAG 2018_02_08 New method.  Story S-17210. 
    public pageReference cancelPOSI() {
        
        pageReference accountPage = new pageReference('/' + posi.Account__c);
        accountPage.setRedirect(True);
        return accountPage;
               
    }
    
    public pageReference insertPOSIpdf() {
        
        POSI.Account__c = accountId;
        insert POSI;

        pageReference pdfPage = new pageReference('/apex/POSI_PDF?id=' + POSI.Id);
        pdfPage.setRedirect(True);
        return pdfPage;
      
    }
    
    public pageReference POSIpdf() {
    
        update POSI;
        
        pageReference pdfPage = new pageReference('/apex/POSI_PDF?id=' + POSI.Id);
        pdfPage.setRedirect(True);
        return pdfPage;
      
    }
    //DAG 01_03_2018 New procedure to get Account Name to display on Visualforce input and Visualforce PDF pages.
    public void getAccountInfo() {
      //DAG 01_03_2018 AccountID is null when the user is accessing an existing POSI or accessing the PDF page from the Input page.  The POSI id, however, is populated, so we can go through that to get the account ID and then the name. 
      if (accountid == null) {
         POSIId = System.currentPageReference().getParameters().get('id');
         POSIlist = [SELECT id, Account__r.name from POSI__c where id = :POSIId];
         account_name = POSIlist[0].Account__r.name;
      } else {
      //DAG 01_03_2018 Account ID IS populated when the user is creating a new POSI (Create button on the Salesforce Account page), so can get account name directly from that. 
         AcctInfo = [SELECT id, name from Account where id = :accountId];
         account_name = AcctInfo[0].name;      
      }
      
    }
}