@isTest
public class grantApplicationFormController_Test {
    @isTest
    static void grantApplicationFormController_Test() {
        
        FIC_Survey_Application__c grant = new FIC_Survey_Application__c();
        
        ApexPages.StandardController sc_grant = new ApexPages.standardController(grant);
        grantApplicationForm_Controller ce_grant = new grantApplicationForm_Controller(sc_grant);
             
        grant.Tax_ID__c = '77-7777777';
        
        ce_grant.signin();

        grant.Tax_ID__c = '77-777777';
        
        ce_grant.signin();

        grant.Tax_ID__c = '77-777x777';
        
        ce_grant.signin();
        
        // pos
        // neg

        grant.Tax_ID__c = '11-1111111';
        grant.Non_Profit_Status__c = '501C(3)';

        ce_grant.gr13();

        grant.Tax_ID__c = '11-1111111';
        grant.Non_Profit_Status__c = 'Other';
        grant.Non_Profit_Status_Other__c = null;

        ce_grant.gr13();

        
        ce_grant.gr14();
        
        grant.First_National_Bank_Request__c = True;
        grant.First_National_Bank_Employee_on_Board__c = 'No';
        grant.Organization_Have_Relationship__c = 'No';
        
        ce_grant.gr14();
       
        
        ce_grant.gr15();
        
        // pos
        // neg
        
        ce_grant.gr16();
        ce_grant.purpose_choice='stablehousing';        
        ce_grant.gr16();
        ce_grant.purpose_choice='stronglocal';        
        ce_grant.gr16();
        ce_grant.purpose_choice='revitalize';        
        ce_grant.gr16();
        ce_grant.purpose_choice='educwrkfrce';        
        ce_grant.gr16();
        
        ce_grant.gr17();
        
        grant.G_Program_Government_Contracts_Grants__c = 0;
        grant.G_Program_Individual_Contributions_Grant__c = 0;
        grant.G_Program_Corporate_Cont_Grants_Fees__c = 0;
        grant.G_Program_Foundation_Cont_Grants_Fees__c = 0;
        grant.G_Program_Membership_dues_fees__c = 0;
        grant.G_Program_Investment_Interest_Tax_Rev__c = 0;
        grant.G_Program_Earned_Revenue__c = 0;
        grant.G_Program_United_Way__c = 0;
        grant.G_Program_Other__c = 0;
        
        grant.G_Org_Government_Contracts_Grants__c = 0;
        grant.G_Org_Individual_contributions_grants__c = 0;
        grant.G_Org_Corporate_Cont_Grants_Fees__c = 0;
        grant.G_Org_Foundation_Cont_Grants_Fees__c = 0;
        grant.G_Org_Membership_Dues_Fees__c = 0;
        grant.G_Org_Investment_Interest_Tax_Rev__c = 0;
        grant.G_Org_Earned_Revenue__c = 0;
        grant.G_Org_United_Way__c = 0;
        grant.G_Org_Other__c = 0;
        
        ce_grant.gr18();
        
        grant.G_Program_Government_Contracts_Grants__c = 0;
        grant.G_Program_Individual_Contributions_Grant__c = 0;
        grant.G_Program_Corporate_Cont_Grants_Fees__c = 20;
        grant.G_Program_Foundation_Cont_Grants_Fees__c = 30;
        grant.G_Program_Membership_dues_fees__c = 0;
        grant.G_Program_Investment_Interest_Tax_Rev__c = 0;
        grant.G_Program_Earned_Revenue__c = 20;
        grant.G_Program_United_Way__c = 30;
        grant.G_Program_Other__c = 0;
        
        grant.G_Org_Government_Contracts_Grants__c = 0;
        grant.G_Org_Individual_contributions_grants__c = 0;
        grant.G_Org_Corporate_Cont_Grants_Fees__c = 0;
        grant.G_Org_Foundation_Cont_Grants_Fees__c = 0;
        grant.G_Org_Membership_Dues_Fees__c = 80;
        grant.G_Org_Investment_Interest_Tax_Rev__c = 0;
        grant.G_Org_Earned_Revenue__c = 0;
        grant.G_Org_United_Way__c = 20;
        grant.G_Org_Other__c = 0;
        
        ce_grant.gr18();
        
        ce_grant.gr19();
        
        ce_grant.grcert();
        //
        ce_grant.gr21();
        ce_grant.thisappcontactemail = 'tusken6@cox.net';

        attachment attachment = new attachment();
      //List<Attachment> attachlist = new list<Attachment>();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
        
      //attachlist.add(attachment);
        ce_grant.attachment = attachment;
        ce_grant.attach();         
        ce_grant.delete25attachments();
        
        ce_grant.submit();
        
    } 
    @isTest
    static void grantApplicationFormController_Test2() {
        FIC_Survey_Application__c grant2 = new FIC_Survey_Application__c();
        
        ApexPages.StandardController sc_grant2 = new ApexPages.standardController(grant2);
        grantApplicationForm_Controller ce_grant2 = new grantApplicationForm_Controller(sc_grant2);
        
        ce_grant2.beginApp();
        grant2.Tax_id__c = '11-1111111';
        Insert grant2;
        ce_grant2.returnedtosignin = true;
        ce_grant2.signin();

        ce_grant2.gr13();
        
        grant2.Name_of_Organization__c = 'Taz Spinning School';
        grant2.G_Name_of_Organization_W_9__c = 'Taz Spinning School';
        grant2.Organization_Street_Address__c = '43 E Alameda Ave';
        grant2.Organization_City__c = 'Los Angeles';
        grant2.Organization_State__c = 'California';
        grant2.Organization_Zip__c = '90210';
        grant2.Non_Profit_Status__c = '501C(3)';
        grant2.Mission_Statement__c = 'LASKJET';
        grant2.Executive_Director__c = 'asletkj';
        grant2.Executive_Director_Email_Address__c = 'salkejt@asdtlkj.com';
        grant2.Executive_Director_Phone_Number__c = '4025551213';
        grant2.Grant_Contact_Name__c = 'slakejt';
        grant2.Grant_Contact_Email__c = 'aseltkj@asetlkj.com';
        grant2.Grant_Contact_Phone__c = '4025551212';
        grant2.G_Organization_Facebook__c = 'NA';
        grant2.G_Organization_Twitter_Handle__c = 'NA';
        grant2.G_Organization_Instagram_Handle__c = 'NA';
        grant2.G_Other_Social_Media_Accounts__c = 'NA';
        
        ce_grant2.gr13();
        
        grant2.Program_Event_Name__c = 'Spin Til you drop';
        grant2.Program_Event_Description__c = 'slakjt';
        grant2.Amount_Requested__c = 50000;
        grant2.G_Years_Program_Operated__c = 10;
        grant2.G_Primary_County_Served__c = 'laskdj';
        grant2.G_Secondary_County_Served__c = 'jklastlk';
        
        ce_grant2.gr15();  

        grant2.G_Stable_Housing__c = TRUE;
        
        ce_grant2.gr17();

        grant2.G_Educated_Workforce__c = TRUE;
        
        ce_grant2.gr17();

        grant2.G_Strong_Local_Economies__c = TRUE;
        
        ce_grant2.gr17();
        
        grant2.G_Funding_Primarily_Serve_Youth__c = 'Yes';
        grant2.G_Medicaid_Eligibility_for_Program__c = 'Yes';
        grant2.G_Income_Thresholds_to_be_Eligible__c = 'Yes';
        grant2.G_Geographical_Radius_of_Organization__c = 'Yes';
        grant2.G_Small_Businesses_or_Small_Farms__c = 'Yes';
        grant2.G_Low_or_Moderate_Income_Neighborhood__c = 'Yes';
        grant2.G_Track_Income_Information__c = 'Yes';
         
        ce_grant2.grcert();
    }
    @isTest
    static void grantApplicationFormController_TestSignInReturn() {
        FIC_Survey_Application__c grant3 = new FIC_Survey_Application__c();
        
        ApexPages.StandardController sc_grant3 = new ApexPages.standardController(grant3);
        grantApplicationForm_Controller ce_grant3 = new grantApplicationForm_Controller(sc_grant3);
        
        ce_grant3.beginApp();
        grant3.Tax_id__c = '11-1111111';
        Insert grant3;
        ce_grant3.GrantID = grant3.id;
        ce_grant3.returnedtosignin = true;
        ce_grant3.thisapptaxid = '22-2222222';
        ce_grant3.thisappprevioustaxid = '22-2222222';
        ce_grant3.thisappcontactemail = 'KoshiKawa@gmail.com';
        ce_grant3.thisapppreviouscontactemail = 'BeneHana@yahoo.com';
        ce_grant3.thisappmarket = 'Omaha';
        ce_grant3.thisappprevmarket = 'Omaha';
        ce_grant3.signin();
    }    
    @isTest
    static void grantApplicationFormController_TestSignIn() {
        FIC_Survey_Application__c grant4 = new FIC_Survey_Application__c();
        
        ApexPages.StandardController sc_grant4 = new ApexPages.standardController(grant4);
        grantApplicationForm_Controller ce_grant4 = new grantApplicationForm_Controller(sc_grant4);
        
        ce_grant4.beginApp();
        grant4.Tax_id__c = '11-1111111';
        Insert grant4;
        ce_grant4.GrantID = grant4.id;
        ce_grant4.returnedtosignin = false;
        ce_grant4.thisapptaxid = '22-2222222';
        ce_grant4.thisappprevioustaxid = '22-2222222';
        ce_grant4.thisappcontactemail = 'KoshiKawa@gmail.com';
        ce_grant4.thisapppreviouscontactemail = 'BeneHana@yahoo.com';
        ce_grant4.thisappmarket = 'Omaha';
        ce_grant4.thisappprevmarket = 'Omaha';
        ce_grant4.signin();
        
    }
    @isTest
    static void grantApplicationFormController_TestSaveForLater() {
        FIC_Survey_Application__c grant5 = new FIC_Survey_Application__c();
        
        ApexPages.StandardController sc_grant5 = new ApexPages.standardController(grant5);
        grantApplicationForm_Controller ce_grant5 = new grantApplicationForm_Controller(sc_grant5);
        
        ce_grant5.beginApp();
        grant5.Tax_id__c = '11-1111111';
        Insert grant5;
        PageReference myVfPage = Page.gr15;
        myVfPage.getParameters().put('id',grant5.id);
        Test.setCurrentPage(myVfPage); 
        String id = ApexPages.currentPage().getParameters().get('id');
        ce_grant5.SaveForLater();
      //ce_grant5.WhereWereWe = 'gr15';
        ce_grant5.purpose_choice = 'stablehousing';
        ce_grant5.SaveForLater();
        ce_grant5.purpose_choice = 'stronglocal';
        ce_grant5.SaveForLater();
        ce_grant5.purpose_choice = 'revitalize';
        ce_grant5.SaveForLater();
        ce_grant5.purpose_choice = 'educwrkfrce';
        ce_grant5.SaveForLater();
        
    }
    @isTest
    static void grantApplicationFormController_TestBack() {
        FIC_Survey_Application__c grant6 = new FIC_Survey_Application__c();
        
        ApexPages.StandardController sc_grant6 = new ApexPages.standardController(grant6);
        grantApplicationForm_Controller ce_grant6 = new grantApplicationForm_Controller(sc_grant6);
        
        ce_grant6.beginApp();
        grant6.Tax_id__c = '11-1111111';
        Insert grant6;
        PageReference myVfPage = Page.gr15;
        myVfPage.getParameters().put('id',grant6.id);
        Test.setCurrentPage(myVfPage); 
        String id = ApexPages.currentPage().getParameters().get('id');
        ce_grant6.Back();
        ce_grant6.purpose_choice = 'stablehousing';
        ce_grant6.Back();
        ce_grant6.purpose_choice = 'stronglocal';
        ce_grant6.Back();
        ce_grant6.purpose_choice = 'revitalize';
        ce_grant6.Back();
        ce_grant6.purpose_choice = 'educwrkfrce';
        ce_grant6.Back();
        
    }                
}