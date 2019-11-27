// Author: Alexander Nourbakhsh
// Date Created/Modified: 01.09.2017
// Project: FIC Grant Application
// Purpose: 
//

public class grantApplicationForm_Controller {
    
  //Transient attachment
    public transient Attachment transientAttachment;
    private final FIC_Survey_Application__c grant;
    public static boolean amIhere = false;
    @TestVisible private Id grantId;
    private list<FIC_Survey_Application__c> checkid = null;
    public string PageInProgress {get; set;}
    public date twomonthsago = null;
    public date thisdate = date.today();
    public string purpose_choice{get;set;}
  //Went all the way back to first page indicator.
    public boolean returnedtosignin {get; set;}
  //Variables for Saving and coming back later, and also for advancing forward after coming back to the first page.
    public string page_left_off {get; set;}
    public integer page_num_left_off {get; set;}
    public string thisapporgname {get; set;}
    public string thisapptaxid {get; set;}
    public string thisappprevioustaxid {get; set;}
    public string thisappcontactemail {get; set;}
    public string thisapppreviouscontactemail {get; set;}
    public string thisappmarket {get; set;}
    public string thisappprevmarket {get; set;}

  //DAG 08/03/2018 New variables here to validate format of Tax ID field. (ADS0002680)
    public string TaxidPrefix {get; set;}
    public string TaxidSuffix {get; set;}
    // Override sc save
    private ApexPages.StandardController sc;
    public static Map<string, integer> WhatPageNum = new Map<string, integer> {
    'grsignin' => 1,
    'gr12' => 2,
    'gr13' => 3,
    'gr14' => 4,
    'gr15' => 5,
    'gr16' => 6,
    'gr17' => 7,
    'gr18' => 8,
    'gr19' => 9,
    'grcert' => 10,
    'gr21' => 11
    };

    public static Map<integer, string> WhatPage = new Map<integer, string> {
     1 => 'grsignin',
     2 => 'gr12',
     3 => 'gr13',
     4 => 'gr14',
     5 => 'gr15',
     6 => 'gr16',
     7 => 'gr17',
     8 => 'gr18',
     9 => 'gr19',
     10 => 'grcert',
     11 => 'gr21'
    };

    // Attachment 
    public Attachment attachment {
        get {
            if (transientAttachment == null) 
                transientAttachment = new Attachment();
            return transientAttachment;
        }

        set;
    }

    public grantApplicationForm_Controller (ApexPages.StandardController stdController) {
    
        grant = (FIC_Survey_Application__c)stdController.getRecord();
        grantId = stdController.getRecord().Id;
        
        grant.recordTypeId = [SELECT Id
                              FROM RecordType
                              WHERE sObjectType = 'FIC_Survey_Application__c'
                              AND Name = 'Grant'
                              LIMIT 1].Id;
        
        this.sc = sc;
        if (grantId != null) {
           FIC_Survey_Application__c Currentappdata = [SELECT id, Name_of_Organization__c, Returned_to_Signin__c, tax_id__c, tax_id_previous__c, page_left_off_at__c, Market__c, Market_Previous__c, Grant_Contact_Email__c,
           Grant_Contact_Email_Previous__c, G_Stable_Housing__c, G_Strong_Local_Economies__c, G_Neighborhood_Revitalization__c, G_Educated_Workforce__c from FIC_Survey_Application__c where id = :grant.id];

           returnedtosignin = Currentappdata.returned_to_signin__c;
           page_num_left_off = WhatPageNum.get(Currentappdata.page_left_off_at__c);
           thisapporgname = Currentappdata.Name_of_Organization__c;
           thisapptaxid = Currentappdata.tax_id__c;
           thisappmarket = Currentappdata.Market__c;
           thisappprevmarket = Currentappdata.Market_Previous__c;
           thisappprevioustaxid = Currentappdata.tax_id_previous__c;
           thisappcontactemail = Currentappdata.Grant_Contact_Email__c;
           thisapppreviouscontactemail = Currentappdata.Grant_Contact_Email_Previous__c;
                      
           if (Currentappdata.G_Stable_Housing__c == true) {
              purpose_choice = 'stablehousing';
           } else {
              if (Currentappdata.G_Strong_Local_Economies__c == true) {
                 purpose_choice = 'stronglocal';
              } else {
                 if (Currentappdata.G_Neighborhood_Revitalization__c == true) {
                    purpose_choice = 'revitalize';
                 } else {
                    if (Currentappdata.G_Educated_Workforce__c == true) {
                       purpose_choice = 'educwrkfrce';
                    }
                 }
              }
           }
        }
    }
     
    // Grant begin button
    public PageReference beginApp() {
       PageReference page = new pageReference('/CRAGrant/grsignin');
       page.setRedirect(true);
       return page;
    }       

    public PageReference back() {
      //Get Current page and parse out to get just the page name... that is all we will need. 
        string PageFrom = ApexPages.currentPage().getUrl();
        PageFrom = PageFrom.split('apex/')[1];
        string WhereAreWe = PageFrom.substringbefore('?');
        integer WhatNumber = WhatPageNum.get(WhereAreWe);
        WhatNumber -=1;
        string WhereWeGoing = WhatPage.get(WhatNumber);
      //set returned to signin = true when the user is going back to the first page. 
        if (WhereWeGoing == 'grsignin') {
           system.debug('returning to sign in.  Tax id: ' + thisapptaxid + ' GrantID: ' + grantID);        
           grant.tax_id_previous__c = thisapptaxid;           
           grant.returned_to_signin__c = true;
        }
        if (WhereAreWe == 'gr15') {
           if (purpose_choice=='stablehousing') {
              Grant.G_Stable_Housing__c = true;
              Grant.G_Strong_Local_Economies__c = false;
              Grant.G_Neighborhood_Revitalization__c = false;
              Grant.G_Educated_Workforce__c = false;
           }
           if (purpose_choice=='stronglocal') {
              Grant.G_Stable_Housing__c = false;
              Grant.G_Strong_Local_Economies__c = true;
              Grant.G_Neighborhood_Revitalization__c = false;
              Grant.G_Educated_Workforce__c = false;
           }
           if (purpose_choice=='revitalize') {
              Grant.G_Stable_Housing__c = false;
              Grant.G_Strong_Local_Economies__c = false;
              Grant.G_Neighborhood_Revitalization__c = true;
              Grant.G_Educated_Workforce__c = false;
           }
           if (purpose_choice=='educwrkfrce') {
              Grant.G_Stable_Housing__c = false;
              Grant.G_Strong_Local_Economies__c = false;
              Grant.G_Neighborhood_Revitalization__c = false;
              Grant.G_Educated_Workforce__c = true;
           }
        }        
        update grant;        
        PageReference page = new pageReference('/CRAGrant/' + WhereWeGoing + '?id='+ grantId);
        page.setRedirect(true);
        return page;
    
    }       
    
    public PageReference signin() {
        
        // Insert FIC_Survey_Application__c record
      //insert grant;
               
      //grantId = grant.Id;
      //DAG 2018-10-17 New code here.  The field with Tax ID on it is now right after the start page.  This is because we are adding the ability to save and come back later.  This code will validate that the organization's 
      //               Tax ID has been entered and is a valid format.  Then it will go through the steps to see if the applicant is new or returning.
        twomonthsago = date.today().adddays(-60);
        TaxidPrefix = grant.Tax_id__c.substringbefore('-');
        TaxidSuffix = grant.Tax_id__c.substringafter('-');
        //Check that the Tax ID has been entered and is in valid format. 
        if (TaxidPrefix.length() == 2 && TaxidSuffix.length() == 7) {
           if (TaxidPrefix.isNumeric() && TaxidSuffix.isNumeric()) {
              checkid = [SELECT id, returned_to_signin__c, Market__c, page_left_off_at__c, tax_id__c, tax_id_previous__c, Grant_Contact_Email__c, G_Grant_Submission__c 
              from FIC_Survey_Application__c where recordtype.name = 'Grant' and tax_id__c = :grant.Tax_id__c and Market__c = :grant.Market__c and createddate > :twomonthsago];
              system.debug('before condition returned to sign in? = ' + returnedtosignin);
              //This is a new tax id that is not already in our system.    
              if (checkid.size() == 0) {
               //Applicant used the Back button to get back to the first page, and might have changed their Org's tax ID.  In this case, they changed to a tax ID that is not out there already.  So, great, just change the tax id.  
                 if (returnedtosignin == true) {
                    update grant;
                 // Redirect to first page                 
                    PageReference page = new pageReference('/CRAGrant/gr12?id='+ grantId);
                    page.setRedirect(true);
                    return page;
                 } else {                
               // Applicant is new for this round, so insert new FIC_Survey_Application__c record
                    grant.tax_id_previous__c = grant.tax_id__c;
                    grant.Market_Previous__c = grant.Market__c;
                    grant.Grant_Contact_Email_Previous__c = grant.Grant_Contact_Email__c;
                    insert grant;
                    grantId = grant.Id;
               // Redirect to first page
                    PageReference page = new pageReference('/CRAGrant/gr12?id='+ grantId);
                    page.setRedirect(true);
                    return page;
                 }
              } else {
                  system.debug('returned to sign in? = ' + returnedtosignin);
                  if (returnedtosignin == true) {
                  //Applicant used the back button to get here, but did not change Tax ID or market from when they signed in. Just send them to the first page.  Update grant in case they changed the Contact e-mail.
                     system.debug('returned to sign in = true.  Tax id: ' + grant.tax_id__c + ' Tax ID Previous: ' + thisappprevioustaxid + ' GrantID: ' + GrantID);
                     if (grant.tax_id__c == thisappprevioustaxid && grant.Market__c == thisappprevmarket) {
                        update grant;
                        PageReference page = new pageReference('/CRAGrant/gr12?id='+ grantId);
                        page.setRedirect(true);
                        return page;
                     } else {   
                   //Applicant used the back button to get here, and changed their tax id to one that's already in progress or has been submitted for this round.  Give them an error.
                        if (checkid[0].G_Grant_Submission__c == true) {
                            grant.Tax_ID__c.addError('An application has already been submitted for this round with this tax id and market.  If you feel this is in error, please email communitydevelopment@fnni.com');
                        } else {
                            grant.Tax_ID__c.addError('An application is already in progress for this round with this tax id and market.  To access this other application, please close out of this application and log into the Grant application again using the other information.  If you feel this is in error, please email communitydevelopment@fnni.com');
                        }
                     }
                  } else {                  
                  //Applicant already applied for this round, so send them to the already submitted page. 
                     if (checkid[0].G_Grant_Submission__c == true) {
                        PageReference page = new pageReference('/CRAGrant/gralreadysubmitted?id='+ checkid[0].id);
                        page.setRedirect(true);
                        return page;
                    //Applicant is returning and has a partially finished application.  They hit the Save and finish later button when they left.
                     } else {
                        if (checkid[0].Grant_Contact_Email__c == grant.Grant_Contact_Email__c) {
                           if (checkid[0].page_left_off_at__c <> null) {
                           //Set the signature date to today's date so that when the user submits, that date will be the submit date and not the created date. 
                              checkid[0].G_Electronic_Signature_Date__c = Date.today();
                              update checkid[0];
                              PageReference page = new pageReference('/CRAGrant/'+checkid[0].page_left_off_at__c +'?id='+ checkid[0].id);
                              page.setRedirect(true);
                              return page;
                        //Applicant is returning and has a partially finished application, but we don't have a page left off at... send them to the first page. 
                           } else {
                              if (checkid[0].page_left_off_at__c == null) {
                                 PageReference page = new pageReference('/CRAGrant/gr12?id='+ checkid[0].id);
                                 page.setRedirect(true);
                                 return page;
                              }
                           }
                        } else {
                          //Person trying to access an existing unfinished application.  They need to have ALL fields correct:  Tax ID, Market, and Grant Contact Email.
                            grant.Tax_ID__c.addError('An application is already in progress for this round with this tax id and market.  If this is your application, please verify all fields and try logging in again.  If you need further assistance, please email communitydevelopment@fnni.com');
                        }
                     } 
                  }   
              }
           } else {
           //Applicant did not enter tax id or entered in wrong format. 
              grant.Tax_ID__c.addError('Tax ID must be filled in, in format 77-7777777, and all numeric');
           }
        } else {
           grant.Tax_ID__c.addError('Tax ID must be filled in, in format 77-7777777, and all numeric');
        }
        return null;
      
     // Redirect
     // PageReference page = new pageReference('/CRAGrant/gr12?id='+ grantId);
     // page.setRedirect(true);
     // return page;
     }

    //DAG 2018-10-17 New procedure to save and come back later.  Saves the application where it is. 
    public PageReference saveforlater() {
      //Get Current page and parse out to get just the page name... that is all we will need. 
        PageInProgress = ApexPages.currentPage().getUrl();
        PageInProgress = PageInProgress.split('apex/')[1];
        string WhereWereWe = PageInProgress.substringbefore('?');
      //If user is on the Radio button page (gr15), need to set the table values.
        if (WhereWereWe == 'gr15') {
           if (purpose_choice=='stablehousing') {
              Grant.G_Stable_Housing__c = true;
              Grant.G_Strong_Local_Economies__c = false;
              Grant.G_Neighborhood_Revitalization__c = false;
              Grant.G_Educated_Workforce__c = false;
           }
           if (purpose_choice=='stronglocal') {
              Grant.G_Stable_Housing__c = false;
              Grant.G_Strong_Local_Economies__c = true;
              Grant.G_Neighborhood_Revitalization__c = false;
              Grant.G_Educated_Workforce__c = false;
           }
           if (purpose_choice=='revitalize') {
              Grant.G_Stable_Housing__c = false;
              Grant.G_Strong_Local_Economies__c = false;
              Grant.G_Neighborhood_Revitalization__c = true;
              Grant.G_Educated_Workforce__c = false;
           }
           if (purpose_choice=='educwrkfrce') {
              Grant.G_Stable_Housing__c = false;
              Grant.G_Strong_Local_Economies__c = false;
              Grant.G_Neighborhood_Revitalization__c = false;
              Grant.G_Educated_Workforce__c = true;
           }
        }        
      //Set returned to signin = false so the applicant can get back in again  :)        
        grant.returned_to_signin__c = false;
        update grant;
      //Throw the user to a friendly page letting them know their partially filled application has been saved. 
        PageReference page = new pageReference('/CRAGrant/grsaved?id='+ grantId);
        page.setRedirect(true);
        return page;
        
    }
    public PageReference gr13() {
      //DAG 2018-10-17 Moved all Required = "true" validations from the Visualforce pages to here.  This is so Save for Later can save without validating. 
      //               Check each field here for a null value and set ErrorFlag = true if one or more fields is null.  ErrorFlag is then checked below, and errors will show up on the page
      //               like they always did.
        Boolean ErrorFlag = false;
        if (grant.Name_of_Organization__c == null) {
           grant.Name_of_Organization__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.G_Name_of_Organization_W_9__c == null) {
           grant.G_Name_of_Organization_W_9__c.addError('You must enter a value');
           ErrorFlag = true; 
        }
        if (grant.Organization_Street_Address__c == null) {
           grant.Organization_Street_Address__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Organization_City__c == null) {
           grant.Organization_City__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Organization_State__c == null) {
           grant.Organization_State__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Organization_Zip__c == null) {
           grant.Organization_Zip__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Non_Profit_Status__c == null) {
           grant.Non_Profit_Status__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Mission_Statement__c == null) {
           grant.Mission_Statement__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Executive_Director__c == null) {
           grant.Executive_Director__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Executive_Director_Email_Address__c == null) {
           grant.Executive_Director_Email_Address__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Executive_Director_Phone_Number__c == null) {
           grant.Executive_Director_Phone_Number__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Grant_Contact_Name__c == null) {
           grant.Grant_Contact_Name__c.addError('You must enter a value');
           ErrorFlag = true;
        }
      //if (grant.Grant_Contact_Email__c == null) {
      //   grant.Grant_Contact_Email__c.addError('You must enter a value');
      //   ErrorFlag = true;
      //}
        if (grant.Grant_Contact_Phone__c == null) {
           grant.Grant_Contact_Phone__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.G_Organization_Facebook__c == null) {
           grant.G_Organization_Facebook__c.addError('You must enter a value or NA');
           ErrorFlag = true;
        }
        if (grant.G_Organization_Twitter_Handle__c == null) {
           grant.G_Organization_Twitter_Handle__c.addError('You must enter a value or NA');
           ErrorFlag = true;
        }
        if (grant.G_Organization_Instagram_Handle__c == null) {
           grant.G_Organization_Instagram_Handle__c.addError('You must enter a value or NA');
           ErrorFlag = true;
        }
        if (grant.G_Other_Social_Media_Accounts__c == null) {
           grant.G_Other_Social_Media_Accounts__c.addError('You must enter a value or NA');
           ErrorFlag = true;
        }
        //DAG 2018-10-17 Add this error below on the Non-Profit Status field.  This will replace the code below that checks for success.  Commenting that code out below. 
        if (grant.Non_Profit_Status__c == 'Other' && grant.Non_Profit_Status_Other__c == null) {
           grant.Non_Profit_Status_Other__c.addError('You must enter a value if Non-Profit Status is Other');
           ErrorFlag = true;
        }
      //        
      //if ((grant.Non_Profit_Status__c == 'Other' && grant.Non_Profit_Status_Other__c != null) ||
      //   (grant.Non_Profit_Status__c == '501C(3)' && grant.Non_Profit_Status_Other__c == null) ||
      //   (grant.Non_Profit_Status__c == '501C(3)' && grant.Non_Profit_Status_Other__c != null) ||
      //   (grant.Non_Profit_Status__c == '501C(6)' && grant.Non_Profit_Status_Other__c == null) ||
      //   (grant.Non_Profit_Status__c == '501C(6)' && grant.Non_Profit_Status_Other__c != null)) {
      if (ErrorFlag == false) {
         grant.Page_Left_off_at__c = 'gr13';
         update grant;
         PageReference page = new pageReference('/CRAGrant/gr13?id='+ grantId);
         page.setRedirect(true);
         return page;
      } else {
         return null;
      }
      //} else {
      //   return null;
      //}
    }

    //DAG 2018-10-17 Moved all Required = "true" validations from the Visualforce pages to here.  This is so Save for Later can save without validating. 
    //               Check each field here for a null value and set ErrorFlag = true if one or more fields is null.  ErrorFlag is then checked below, and errors will show up on the page
    //               like they always did.     
    public PageReference gr14() {
        Boolean ErrorFlag = false;
        if (grant.First_National_Bank_Employee_on_Board__c == null) {
           grant.First_National_Bank_Employee_on_Board__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Organization_Have_Relationship__c == null) {
           grant.Organization_Have_Relationship__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        
        if (grant.First_National_Bank_Employee_on_Board__c == 'Yes' && grant.Provide_Name_and_Service_Description__c == null) {        
            grant.Provide_Name_and_Service_Description__c.addError('You must enter a value');

        } 
        if (grant.Organization_Have_Relationship__c == 'Yes' && grant.Please_Describe_Relationship__c == null) {
            grant.Please_Describe_Relationship__c.addError('You must enter a value');

        } 
        if (((grant.First_National_Bank_Employee_on_Board__c == 'Yes' && grant.Provide_Name_and_Service_Description__c != null) ||
            (grant.First_National_Bank_Employee_on_Board__c == 'No' && grant.Provide_Name_and_Service_Description__c != null) ||
            (grant.First_National_Bank_Employee_on_Board__c == 'No' && grant.Provide_Name_and_Service_Description__c == null) ||
            (grant.First_National_Bank_Employee_on_Board__c == 'Unknown' && grant.Provide_Name_and_Service_Description__c != null) ||
            (grant.First_National_Bank_Employee_on_Board__c == 'Unknown' && grant.Provide_Name_and_Service_Description__c == null)) &&
            ((grant.Organization_Have_Relationship__c == 'Yes' && grant.Please_Describe_Relationship__c != null) ||
            (grant.Organization_Have_Relationship__c == 'No' && grant.Please_Describe_Relationship__c != null) ||
            (grant.Organization_Have_Relationship__c == 'No' && grant.Please_Describe_Relationship__c == null))) {

            if (ErrorFlag == false) { 
               grant.Page_Left_off_at__c = 'gr14';
               update grant;
                    
               PageReference page = new pageReference('/CRAGrant/gr14?id='+ grantId);
               page.setRedirect(true);
               return page;
            } else {
               return null;
            }
        } else {

            return null;
        }    
        
     }
     
    //DAG 2018-10-17 Moved all Required = "true" validations from the Visualforce pages to here.  This is so Save for Later can save without validating. 
    //               Check each field here for a null value and set ErrorFlag = true if one or more fields is null.  ErrorFlag is then checked below, and errors will show up on the page
    //               like they always did.     
         
     public PageReference gr15() {
        Boolean ErrorFlag = false;
        if (grant.Program_Event_Name__c == null) {
           grant.Program_Event_Name__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Program_Event_Description__c == null) {
           grant.Program_Event_Description__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.Amount_Requested__c == null) {
           grant.Amount_Requested__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.G_Years_Program_Operated__c == null) {
           grant.G_Years_Program_Operated__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.G_Primary_County_Served__c == null) {
           grant.G_Primary_County_Served__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        if (grant.G_Secondary_County_Served__c == null) {
           grant.G_Secondary_County_Served__c.addError('You must enter a value');
           ErrorFlag = true;
        }
        system.debug('gr15 procedure.  Error Flag = ' + ErrorFlag);       

        if (ErrorFlag == false) {
           grant.Page_Left_off_at__c = 'gr15';
           update grant;
                  
           PageReference page = new pageReference('/CRAGrant/gr15?id='+ grantId);
           page.setRedirect(true);
           return page;
        } else {
           return null;
        }
            
     }
        public PageReference gr16() {
          //DAG 2017-12-15 Changed this from checkboxes to Radio buttons.   
          //boolean falseFlag = false;
          //falseFlag = (grant.G_Stable_Housing__c 
          //    || grant.G_Strong_Local_Economies__c
          //    || grant.G_Neighborhood_Revitalization__c
          //    || grant.G_Educated_Workforce__c);
            
          //If (falseFlag == false) {
          //    apexPages.addMessage( new apexPages.Message(apexPages.Severity.Info, 'Error: Please select at least one option to continue.'));
                
          //}
            
          //If (falseFlag) {
            if (purpose_choice==null) {
               apexPages.addMessage( new apexPages.Message(apexPages.Severity.Error, 'Please select one of the options to continue.'));
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.Error, 'Error: Please select one of the options to continue.');
               return null;
            } else {
                if (purpose_choice=='stablehousing') {
                    Grant.G_Stable_Housing__c = true;
                    Grant.G_Strong_Local_Economies__c = false;
                    Grant.G_Neighborhood_Revitalization__c = false;
                    Grant.G_Educated_Workforce__c = false;
                }
                if (purpose_choice=='stronglocal') {
                    Grant.G_Stable_Housing__c = false;
                    Grant.G_Strong_Local_Economies__c = true;
                    Grant.G_Neighborhood_Revitalization__c = false;
                    Grant.G_Educated_Workforce__c = false;
                }
                if (purpose_choice=='revitalize') {
                    Grant.G_Stable_Housing__c = false;
                    Grant.G_Strong_Local_Economies__c = false;
                    Grant.G_Neighborhood_Revitalization__c = true;
                    Grant.G_Educated_Workforce__c = false;
                }
                if (purpose_choice=='educwrkfrce') {
                    Grant.G_Stable_Housing__c = false;
                    Grant.G_Strong_Local_Economies__c = false;
                    Grant.G_Neighborhood_Revitalization__c = false;
                    Grant.G_Educated_Workforce__c = true;
                }
                grant.Page_Left_off_at__c = 'gr16';
                update grant;
                
                PageReference page = new pageReference('/CRAGrant/gr16?id='+ grantId);
                page.setRedirect(true);
                return page;
            }              
     }

    //DAG 2018-10-17 Moved all Required = "true" validations from the Visualforce pages to here.  This is so Save for Later can save without validating. 
    //               Check each field here for a null value and set ErrorFlag = true if one or more fields is null.  ErrorFlag is then checked below, and errors will show up on the page
    //               like they always did. In this case, make sure we only check the fields on the panels that are visible on the page. 
     
        public PageReference gr17() {
            Boolean ErrorFlag = false;
            if (grant.G_Community_Need__c == null) {
               grant.G_Community_Need__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Program_Implementation_History__c == null) {
               grant.G_Program_Implementation_History__c.addError('You must enter a value');
               ErrorFlag = true;
            }

            if (grant.G_Stable_Housing__c == TRUE || grant.G_Neighborhood_Revitalization__c == TRUE) {
               if (grant.G_Program_Housing_Units_Created__c == null) {
                  grant.G_Program_Housing_Units_Created__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Housing_Units_Created__c == null) {
                  grant.G_Org_Housing_Units_Created__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Housing_Units_Rehab_Renov__c == null) {
                  grant.G_Program_Housing_Units_Rehab_Renov__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Housing_Units_Rehab_Renov__c == null) {
                  grant.G_Org_Housing_Units_Rehab_Renov__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Homeownership_Education_Ses__c == null) {
                  grant.G_Program_Homeownership_Education_Ses__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Homeownership_Education_Sessions__c == null) {
                  grant.G_Org_Homeownership_Education_Sessions__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Housing_Units_Financed__c == null) {
                  grant.G_Program_Housing_Units_Financed__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Housing_Units_Financed__c == null) {
                  grant.G_Org_Housing_Units_Financed__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Ind_Rec_Homeownership_Educ__c == null) {
                  grant.G_Program_Ind_Rec_Homeownership_Educ__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
               if (grant.G_Org_Ind_Rec_Homeownership_Educ__c == null) {
                  grant.G_Org_Ind_Rec_Homeownership_Educ__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
            }
            if (grant.G_Educated_Workforce__c == TRUE) {
               if (grant.G_Program_Individuals_Served__c == null) {
                  grant.G_Program_Individuals_Served__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Individuals_Served__c == null) {
                  grant.G_Org_Individuals_Served__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Adults_Provided_Education__c == null) {
                  grant.G_Program_Adults_Provided_Education__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Adults_Provided_Education__c == null) {
                  grant.G_Org_Adults_Provided_Education__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Adults_Provided_Vocational__c == null) {
                  grant.G_Program_Adults_Provided_Vocational__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Adults_Provided_Vocational__c == null) {
                  grant.G_Org_Adults_Provided_Vocational__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Youth_Provided_Workforce_Caree__c == null) {
                  grant.G_Program_Youth_Provided_Workforce_Caree__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Youth_Provided_Workforce_Career__c == null) {
                  grant.G_Org_Youth_Provided_Workforce_Career__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Youth_Provided_Vocational__c == null) {
                  grant.G_Program_Youth_Provided_Vocational__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Youth_Provided_Vocational__c == null) {
                  grant.G_Org_Youth_Provided_Vocational__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
            }   
            if (grant.G_Strong_Local_Economies__c == TRUE) {
               if (grant.G_Program_Small_Businesses_Assisted__c == null) {
                  grant.G_Program_Small_Businesses_Assisted__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Small_Businesses_Assisted__c == null) {
                  grant.G_Org_Small_Businesses_Assisted__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_New_Businesses_Served__c == null) {
                  grant.G_Program_New_Businesses_Served__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_New_Businesses_Served__c == null) {
                  grant.G_Org_New_Businesses_Served__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Workshops_and_Training_events__c == null) {
                  grant.G_Program_Workshops_and_Training_events__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Workshops_and_Training_Events__c == null) {
                  grant.G_Org_Workshops_and_Training_Events__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Individual_Coaching_Sessions__c == null) {
                  grant.G_Program_Individual_Coaching_Sessions__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Individual_Coaching_Sessions__c == null) {
                  grant.G_Org_Individual_Coaching_Sessions__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Jobs_Created_Full_Time__c == null) {
                  grant.G_Program_Jobs_Created_Full_Time__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Jobs_Created_Full_Time__c == null) {
                  grant.G_Org_Jobs_Created_Full_Time__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Jobs_Created_Part_Time__c == null) {
                  grant.G_Program_Jobs_Created_Part_Time__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.Org_Jobs_Created_Part_Time__c == null) {
                  grant.Org_Jobs_Created_Part_Time__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Program_Jobs_Retained__c == null) {
                  grant.G_Program_Jobs_Retained__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
               if (grant.G_Org_Jobs_Retained__c == null) {
                  grant.G_Org_Jobs_Retained__c.addError('You must enter a value');
                  ErrorFlag = true;
               } 
            
            }            
            if (grant.G_Describe_Grant_Funding_Use__c == null) {
               grant.G_Describe_Grant_Funding_Use__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Strategy_Address_Community_Need__c == null) {
               grant.G_Strategy_Address_Community_Need__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Plans_to_Sustain_This_Program__c == null) {
               grant.G_Plans_to_Sustain_This_Program__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Measure_Long_Term_Imp_Out__c == null) {
               grant.G_Measure_Long_Term_Imp_Out__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Collab_Enhance_Your_Program__c == null) {
               grant.G_Collab_Enhance_Your_Program__c.addError('You must enter a value');
               ErrorFlag = true;
            }            
            if (grant.G_Evidence_Based_Practices_Utilized__c == null) {
               grant.G_Evidence_Based_Practices_Utilized__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Vol_Opportunities_for_Bank_Employees__c == null) {
               grant.G_Vol_Opportunities_for_Bank_Employees__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (ErrorFlag == false) {
               grant.Page_Left_off_at__c = 'gr17';
               update grant;
                    
               PageReference page = new pageReference('/CRAGrant/gr17?id='+ grantId);
               page.setRedirect(true);
               return page;
               
            } else {
               return null;
            }
                
     }
     
            public PageReference gr18() {
               Boolean ErrorFlag = false;
               double program_col = grant.G_Program_Government_Contracts_Grants__c +
                                                                 grant.G_Program_Individual_Contributions_Grant__c +
                                                 grant.G_Program_Corporate_Cont_Grants_Fees__c +
                                                 grant.G_Program_Foundation_Cont_Grants_Fees__c +
                                                 grant.G_Program_Membership_dues_fees__c +
                                                 grant.G_Program_Investment_Interest_Tax_Rev__c +
                                                 grant.G_Program_Earned_Revenue__c +
                                                 grant.G_Program_United_Way__c +
                                                 grant.G_Program_Other__c;
            
               double org_col = grant.G_Org_Government_Contracts_Grants__c + 
                                         grant.G_Org_Individual_contributions_grants__c +
                             grant.G_Org_Corporate_Cont_Grants_Fees__c +
                             grant.G_Org_Foundation_Cont_Grants_Fees__c +
                                 grant.G_Org_Membership_Dues_Fees__c +
                                         grant.G_Org_Investment_Interest_Tax_Rev__c +
                                         grant.G_Org_Earned_Revenue__c +
                                         grant.G_Org_United_Way__c +
                                         grant.G_Org_Other__c;
            
             //If(program_col != 100 || org_col != 100) {
                //myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The "Program" column and the "Organization" column must each have a combined total value of 100%.');
                //apexpages.addmessage(new apexPages.Message(apexPages.Severity.ERROR, 'The "Program" column and the "Organization" column must each have a combined total value of 100%.'));
             //}
               if (grant.Specific_Funding_Sources__c == null) {
                  grant.Specific_Funding_Sources__c.addError('You must enter a value');
                  ErrorFlag = true;
               }            
            
               If(program_col == 100 && org_col == 100) {
               } else {
                 apexpages.addmessage(new apexPages.Message(apexPages.Severity.ERROR, 'The "Program" column and the "Organization" column must each have a combined total value of 100%.'));
                 ErrorFlag = true;   
               }
               
               if (ErrorFlag == false) {
                  grant.Page_Left_off_at__c = 'gr18';
                  update grant;
                  
                  PageReference page = new pageReference('/CRAGrant/gr18?id='+ grantId);
                  page.setRedirect(true);
                  return page;
                  
               } else {
                  return null;
               }
     }
    //DAG 2018-10-17 Moved all Required = "true" validations from the Visualforce pages to here.  This is so Save for Later can save without validating. 
    //               Check each field here for a null value and set ErrorFlag = true if one or more fields is null.  ErrorFlag is then checked below, and errors will show up on the page
    //               like they always did. 
     
         public PageReference gr19() {
            Boolean ErrorFlag = false;
            if (grant.G_Beneficiaries_Low_or_Moderate_Income__c == null) {
               grant.G_Beneficiaries_Low_or_Moderate_Income__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Box_A__c == null) {
               grant.G_Box_A__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Box_B__c == null) {
               grant.G_Box_B__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Box_C__c == null) {
               grant.G_Box_C__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Funding_Primarily_Serve_Youth__c == null) {
               grant.G_Funding_Primarily_Serve_Youth__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Medicaid_Eligibility_for_Program__c == null) {
               grant.G_Medicaid_Eligibility_for_Program__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Income_Thresholds_to_be_Eligible__c == null) {
               grant.G_Income_Thresholds_to_be_Eligible__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Geographical_Radius_of_Organization__c == null) {
               grant.G_Geographical_Radius_of_Organization__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Small_Businesses_or_Small_Farms__c == null) {
               grant.G_Small_Businesses_or_Small_Farms__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Low_or_Moderate_Income_Neighborhood__c == null) {
               grant.G_Low_or_Moderate_Income_Neighborhood__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Track_Income_Information__c == null) {
               grant.G_Track_Income_Information__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (ErrorFlag == false) {
               grant.Page_Left_off_at__c = 'gr19';
               update grant;
                    
               PageReference page = new pageReference('/CRAGrant/gr19?id='+ grantId);
               page.setRedirect(true);
               return page;
            } else {
               return null;
            }
            
     }

    //DAG 2018-10-17 Moved all Required = "true" validations from the Visualforce pages to here.  This is so Save for Later can save without validating. 
    //               Check each field here for a null value and set ErrorFlag = true if one or more fields is null.  ErrorFlag is then checked below, and errors will show up on the page
    //               like they always did. In this case, make sure we only check the fields on the panels that are visible on the page.      
        public PageReference grcert() {

            Boolean ErrorFlag = false;
            if (grant.G_Funding_Primarily_Serve_Youth__c == 'Yes') {
               if (grant.G_Eligible_for_Free_and_Reduced_Lunch__c == null) {
                  grant.G_Eligible_for_Free_and_Reduced_Lunch__c.addError('You must enter a value');
                  ErrorFlag = true;
                  system.debug('got here grcert ErrorFlag = true. Field: G_Eligible_for_Free_and_Reduced_Lunch__c');
               }
               if (grant.G_Schools_Free_and_Reduced_Lunch__c == null) {
                  grant.G_Schools_Free_and_Reduced_Lunch__c.addError('You must enter a value');
                  ErrorFlag = true;
                  system.debug('got here grcert ErrorFlag = true. Field: G_Schools_Free_and_Reduced_Lunch__c');
               }
            }
            if (grant.G_Medicaid_Eligibility_for_Program__c == 'Yes') {
               if (grant.G_Eligible_for_Medicaid__c == null) {
                  grant.G_Eligible_for_Medicaid__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
            }
            if (grant.G_Income_Thresholds_to_be_Eligible__c == 'Yes') {
               
               if (grant.G_Provide_Income_Thresholds_and_Relate__c == null) {
                  grant.G_Provide_Income_Thresholds_and_Relate__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
            }
            if (grant.G_Geographical_Radius_of_Organization__c == 'Yes') {
               if (grant.G_Address_of_Services_or_Activities__c == null) {
                  grant.G_Address_of_Services_or_Activities__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
               if (grant.G_Family_Income_of_the_areas_where_servi__c == null) {
                  grant.G_Family_Income_of_the_areas_where_servi__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
            }
            if (grant.G_Small_Businesses_or_Small_Farms__c == 'Yes') {
               if (grant.G_Annual_revenues_under_one_million__c == null) {
                  grant.G_Annual_revenues_under_one_million__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
               if (grant.G_Demographic_information_on_the_bus__c == null) {
                  grant.G_Demographic_information_on_the_bus__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
               if (grant.G_Average_wage_of_jobs_created__c == null) {
                  grant.G_Average_wage_of_jobs_created__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
               if (grant.G_Average_wage_relate_Median_Family_Inc__c == null) {
                  grant.G_Average_wage_relate_Median_Family_Inc__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
            }
            if (grant.G_Low_or_Moderate_Income_Neighborhood__c == 'Yes') {
               if (grant.G_Address_of_the_project_center__c == null) {
                  grant.G_Address_of_the_project_center__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
            }
            if (grant.G_Track_Income_Information__c == 'Yes') {
               if (grant.G_Program_ben_incomes_at_or_below__c == null) {
                  grant.G_Program_ben_incomes_at_or_below__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
               if (grant.Q_Collect_and_Verify_Beneficiary_Income__c == null) {
                  grant.Q_Collect_and_Verify_Beneficiary_Income__c.addError('You must enter a value');
                  ErrorFlag = true;
               }
            }
          //system.debug('grcert ErrorFlag = ' + ErrorFlag);

            if (ErrorFlag == false) {
               grant.Page_Left_off_at__c = 'grcert';
               grant.G_Electronic_Signature_Date__c = Date.today();                   
               update grant;
               
               PageReference page = new pageReference('/CRAGrant/grcert?id='+ grantId);
               page.setRedirect(true);
               return page;
            } else {
               return null;
            }
            
     }
    //DAG 2018-10-17 Moved all Required = "true" validations from the Visualforce pages to here.  This is so Save for Later can save without validating. 
    //               Check each field here for a null value and set ErrorFlag = true if one or more fields is null.  ErrorFlag is then checked below, and errors will show up on the page
    //               like they always did.
     
        public PageReference gr21() {
            Boolean ErrorFlag = false;
            if (grant.G_Electronic_Signature_Full_Name__c == null) {
               grant.G_Electronic_Signature_Full_Name__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (grant.G_Electronic_Signature_Date__c == null) {
               grant.G_Electronic_Signature_Date__c.addError('You must enter a value');
               ErrorFlag = true;
            }
            if (ErrorFlag == false) {
               grant.Page_Left_off_at__c = 'gr21';
               update grant;
                    
               PageReference page = new pageReference('/CRAGrant/gr21?id='+ grantId);
               page.setRedirect(true);
               return page;
            } else {
               return null;
            }
            
     }
     
     Public List<selectOption> getgrantPurpose(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('stablehousing', 'Stable Housing / Neighborhood Revitalization: Increase access to safe, affordable, and quality housing or stimulate revitalization in blighted, underserved, and distressed communities.'));
        options.add(new SelectOption('stronglocal', 'Strong Local Economies: Grow local economies through small business development and job creation.'));
      //options.add(new SelectOption('revitalize', 'Neighborhood Revitalization and Stabilization: Stimulate revitalization in blighted, underserved, and distressed communities.'));
        options.add(new SelectOption('educwrkfrce', 'Educated Workforce: Strengthen individual core competencies that will drive economic self-sufficiency.'));
        return options;
     }
     
     public PageReference attach() {
         
        //Insert attachment if not null (body used as indicator)
        if (attachment.Body != null) {
        attachment.parentId = grant.Id;
        insert attachment;
        
        update grant;
        PageReference page = new pageReference('/CRAGrant/gr21?id='+ grantId);
        page.setRedirect(true);
        return page;
            
        } else {
        
        return null;
        
        }
     }
     
     public PageReference delete25Attachments() {
         
        //List of attachments to be deleted
        List<Attachment> attachments = [SELECT Id, ParentId
                                        FROM Attachment
                                        WHERE ParentId =: grant.Id
                                        LIMIT 25];
        
        //Only delete if list size greater than 0
        if (attachments.size() > 0) {
        delete attachments;
        
        update grant;
        PageReference page = new pageReference('/CRAGrant/gr21?id='+ grantId);
        page.setRedirect(true);
        return page;
            
        } else {
        
        return null;
        
        }
     }
    
     public PageReference submit() {

       grant.G_Grant_Submission__c = True;
       update grant; 
       list<string>toaddresses=new list<string>();
       if(grant.id!=Null){     
          toaddresses.add(thisappcontactemail);     
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       // New code here to attempt to attach PDF to email reply. 
          PageReference pdf = new pageReference('/CRAGrant/Grant_PDF?id='+grant.id);
          string pdfheader = ApexPages.currentPage().getHeaders().get('Host');
          string pdfurl=pdf.geturl();
          string pdfpagename='https://'+ pdfheader + pdfurl;
       // Set rest of email attributes  
          mail.setToAddresses(toAddresses);
       // system.debug('Grant Contact Email = '+thisappcontactemail);
       // mail.setReplyTo('Squiggy446@gmail.com');
          mail.setUseSignature(false);
          mail.setSaveAsActivity(false);
          mail.setSenderDisplayName('First in the Community');
          mail.setsubject('Grant Application Confirmation');
          string replymonth = null;
          if (thisdate.month() < 6) {
             replymonth = 'June';
          } else {
             replymonth = 'November';
          }
          mail.setHtmlBody('<p style="font-family:Arial"><i>Thank you for submitting an application for a Community Development Grant from First National Bank of Omaha (which also operates as First National Bank, First National Bank North Platte and FNBO). Your application will be processed and you will receive decision notification for Round 1 grants by June 1, and Round 2 by November 1.  If you have questions, please contact communitydevelopment@fnni.com.<br/><br/></i>Click the link below to access a PDF of your application.<br/><a href="'+pdfpagename+'">'+thisapporgname+'</a></p>');          
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
       }
       PageReference page = new pageReference('/CRAGrant/gr25?id='+ grantId);
       page.setRedirect(true);
       return page;
         
     }
     
     public PageReference createpdf() {
     // Redirect
        PageReference page = new pageReference('/CRAGrant/Grant_PDF?id='+ grantId);
        page.setRedirect(true);
        return page;
        
     }     
}