@isTest(seeAllData=true)
public class GrantReportTemplateCtrl_Test {

    public static testMethod void GrantReportTemplateCtrlTestNoUpload () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Strong Local Economies';
        CMGTest.Small_Businesses_Assisted_AI__c='5';
        CMGTest.New_Businesses_Served_AI__c='5';
        CMGTest.Workshops_Training_Events_Provided_AI__c='5';
        CMGTest.Indiv_Coaching_Sessions_w_Small_Bus_AI__c='5';
        CMGTest.Jobs_Created_Full_Time_AI__c='5';
        CMGTest.Jobs_Created_Part_Time_AI__c='5';
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTest.Market__c = 'South Dakota';       
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;        
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.twolofc1='Yes';
        ce_No_Upload.thisid=CMGTest.id;
        ce_No_Upload.nextpage();
        ce_No_Upload.Savecommunityinvestment();
        ce_No_Upload.createpdf();
        
    }

    public static testMethod void GrantReportTemplateCtrlTestOneUpload () {
        Community_Giving__c CMGTestOne=new Community_Giving__c();
        CMGTestOne.purpose__c = 'Stable Housing';
        CMGTestOne.Housing_Units_Created_Built_AI__c='5';
        CMGTestOne.Individuals_Rec_Homeownership_Educ_AI__c='5';
        CMGTestOne.Housing_Units_Rehabilitated_Renovated_AI__c='5';
        CMGTestOne.Homeownership_Educ_Sessions_AI__c='5';
        CMGTestOne.Housing_Units_Financed_AI__c='5';        
        CMGTestOne.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTestOne.Market__c = 'South Dakota';               
        Insert CMGTestOne;    
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);
        pageRef.getparameters().put('id', CMGTestOne.id);
        Community_giving__c One_Upload = CMGTestOne;        
        ApexPages.StandardController sc_One_Upload = new ApexPages.standardController(One_Upload);
        GrantReportTemplateCtrl ce_One_Upload = new GrantReportTemplateCtrl(sc_One_Upload);
        ce_One_Upload.nextpage();
        attachment UploadOneAttach = new attachment();
        UploadOneAttach.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach OneUpload attach test');
        UploadOneAttach.body = bodystuff;
        
        ce_One_Upload.Upload();
      //system.assertequals(ce_One_Upload.Attached, true);
        ce_One_Upload.Savecommunityinvestment();
        
    }

    public static testMethod void GrantReportTemplateCtrlTestTwoUpload () {
        Community_Giving__c CMGTestTwo=new Community_Giving__c();
        CMGTestTwo.purpose__c = 'Educated Workforce';
        CMGTestTwo.Individuals_Served_in_Prop_Program_AI__c='5';
        CMGTestTwo.Adults_Provided_Education_AI__c='5';
        CMGTestTwo.Youth_Provided_Work_Career_Educ_AI__c='5';
        CMGTestTwo.Adults_Provided_Vocational_Training_AI__c='5';
        CMGTestTwo.Youth_Provided_Voc_Train_Work_Dev_AI__c='5';        
        CMGTestTwo.Awarded_date__c = Date.newInstance(2017, 12, 9);        
        CMGTestTwo.Market__c = 'South Dakota';               
        Insert CMGTestTwo;    
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);
        pageRef.getparameters().put('id', CMGTestTwo.id);
        Community_giving__c Two_Upload = CMGTestTwo;
        ApexPages.StandardController sc_Two_Upload = new ApexPages.standardController(Two_Upload);
        GrantReportTemplateCtrl ce_Two_Upload = new GrantReportTemplateCtrl(sc_Two_Upload);
        ce_Two_Upload.nextpage();

        attachment UploadTwoAttach1 = new attachment();
        UploadTwoAttach1.Name = 'attach test attach test';
        blob bodystuff21 = blob.valueOf('attach OneUpload attach test');
        UploadTwoAttach1.body = bodystuff21;

        ce_Two_Upload.Upload();

        attachment UploadTwoAttach2 = new attachment();
        UploadTwoAttach2.Name = 'attach test22 attach test';
        blob bodystuff22 = blob.valueOf('attach OneUpload attach test');
        UploadTwoAttach2.body = bodystuff21;
       
        ce_Two_Upload.Upload1();
        ce_Two_Upload.Savecommunityinvestment();
        
    }
    public static testMethod void TestStabilization_AllNumeric () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Stable housing';
        CMGTest.Housing_Units_Created_Built_AI__c='5';
        CMGTest.Individuals_Rec_Homeownership_Educ_AI__c='5';
        CMGTest.Housing_Units_Rehabilitated_Renovated_AI__c='5';
        CMGTest.Homeownership_Educ_Sessions_AI__c='5';
        CMGTest.Housing_Units_Financed_AI__c='5'; 
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTest.Market__c = 'South Dakota';    
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();
        ce_No_Upload.Savecommunityinvestment();
        system.assertEquals(ce_No_Upload.IsInputError, false);
    }            

    public static testMethod void TestStabilization_NonNumeric1() {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Stable housing';
        CMGTest.Housing_Units_Created_Built_AI__c='3f';
        CMGTest.Individuals_Rec_Homeownership_Educ_AI__c='5';
        CMGTest.Housing_Units_Rehabilitated_Renovated_AI__c='5';
        CMGTest.Homeownership_Educ_Sessions_AI__c='5';
        CMGTest.Housing_Units_Financed_AI__c='5';        
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);                       
        CMGTest.Market__c = 'South Dakota';               
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        system.assertEquals(ce_No_Upload.Stabilization, true);
        system.assertEquals(ce_No_Upload.EducatedWorkforce, false);
        system.assertEquals(ce_No_Upload.StrongLocal, false);
        ce_No_Upload.nextpage();        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestStabilization_NonNumeric2() {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Stable housing';
        CMGTest.Housing_Units_Created_Built_AI__c='9';
        CMGTest.Individuals_Rec_Homeownership_Educ_AI__c='3f';
        CMGTest.Housing_Units_Rehabilitated_Renovated_AI__c='5';
        CMGTest.Homeownership_Educ_Sessions_AI__c='5';
        CMGTest.Housing_Units_Financed_AI__c='5';        
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);   
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);             
        CMGTest.Market__c = 'South Dakota';               
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestStabilization_NonNumeric3() {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Stable housing';
        CMGTest.Housing_Units_Created_Built_AI__c='9';
        CMGTest.Individuals_Rec_Homeownership_Educ_AI__c='4';
        CMGTest.Housing_Units_Rehabilitated_Renovated_AI__c='9x';
        CMGTest.Homeownership_Educ_Sessions_AI__c='5';
        CMGTest.Housing_Units_Financed_AI__c='5';        
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';                                                                       
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestStabilization_NonNumeric4() {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Stable housing';
        CMGTest.Housing_Units_Created_Built_AI__c='9';
        CMGTest.Individuals_Rec_Homeownership_Educ_AI__c='4';
        CMGTest.Housing_Units_Rehabilitated_Renovated_AI__c='682';
        CMGTest.Homeownership_Educ_Sessions_AI__c='2yr';
        CMGTest.Housing_Units_Financed_AI__c='5';
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';               
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestStabilization_NonNumeric5() {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Stable housing';
        CMGTest.Housing_Units_Created_Built_AI__c='9';
        CMGTest.Individuals_Rec_Homeownership_Educ_AI__c='4';
        CMGTest.Housing_Units_Rehabilitated_Renovated_AI__c='682';
        CMGTest.Homeownership_Educ_Sessions_AI__c='57';
        CMGTest.Housing_Units_Financed_AI__c='xy8r';
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';               
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
        
    }

    public static testMethod void TestEducWrkfrce_AllNumeric () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Educated Workforce';
        CMGTest.Individuals_Served_in_Prop_Program_AI__c='5';
        CMGTest.Adults_Provided_Education_AI__c='5';
        CMGTest.Youth_Provided_Work_Career_Educ_AI__c='5';
        CMGTest.Adults_Provided_Vocational_Training_AI__c='5';
        CMGTest.Youth_Provided_Voc_Train_Work_Dev_AI__c='5';
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);  
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';                                    
        Insert CMGTest;    
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, false);        
        ce_No_Upload.Savecommunityinvestment();
    }        

    public static testMethod void TestEducWrkfrce_NonNumeric1 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Educated Workforce';
        CMGTest.Individuals_Served_in_Prop_Program_AI__c='3f';
        CMGTest.Adults_Provided_Education_AI__c='5';
        CMGTest.Youth_Provided_Work_Career_Educ_AI__c='5';
        CMGTest.Adults_Provided_Vocational_Training_AI__c='5';
        CMGTest.Youth_Provided_Voc_Train_Work_Dev_AI__c='5';
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);  
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';                                    
        Insert CMGTest;    
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestEducWrkfrce_NonNumeric2 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Educated Workforce';
        CMGTest.Individuals_Served_in_Prop_Program_AI__c='5';
        CMGTest.Adults_Provided_Education_AI__c='3f';
        CMGTest.Youth_Provided_Work_Career_Educ_AI__c='5';
        CMGTest.Adults_Provided_Vocational_Training_AI__c='5';
        CMGTest.Youth_Provided_Voc_Train_Work_Dev_AI__c='5';
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';                                      
        Insert CMGTest;    
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestEducWrkfrce_NonNumeric3 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Educated Workforce';
        CMGTest.Individuals_Served_in_Prop_Program_AI__c='5';
        CMGTest.Adults_Provided_Education_AI__c='5';
        CMGTest.Youth_Provided_Work_Career_Educ_AI__c='3f';
        CMGTest.Adults_Provided_Vocational_Training_AI__c='5';
        CMGTest.Youth_Provided_Voc_Train_Work_Dev_AI__c='5';
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9); 
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';                                     
        Insert CMGTest;    
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestEducWrkfrce_NonNumeric4 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Educated Workforce';
        CMGTest.Individuals_Served_in_Prop_Program_AI__c='5';
        CMGTest.Adults_Provided_Education_AI__c='5';
        CMGTest.Youth_Provided_Work_Career_Educ_AI__c='5';
        CMGTest.Adults_Provided_Vocational_Training_AI__c='3f';
        CMGTest.Youth_Provided_Voc_Train_Work_Dev_AI__c='5';
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';                                    
        Insert CMGTest;    
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestEducWrkfrce_NonNumeric5 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Educated Workforce';
        CMGTest.Individuals_Served_in_Prop_Program_AI__c='5';
        CMGTest.Adults_Provided_Education_AI__c='5';
        CMGTest.Youth_Provided_Work_Career_Educ_AI__c='5';
        CMGTest.Adults_Provided_Vocational_Training_AI__c='5';
        CMGTest.Youth_Provided_Voc_Train_Work_Dev_AI__c='0gh';
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);  
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';                                    
        Insert CMGTest;    
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestStrongLocal_AllNumeric () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Strong Local Economies';
        CMGTest.Small_Businesses_Assisted_AI__c='5';
        CMGTest.New_Businesses_Served_AI__c='5';
        CMGTest.Workshops_Training_Events_Provided_AI__c='5';
        CMGTest.Indiv_Coaching_Sessions_w_Small_Bus_AI__c='5';
        CMGTest.Jobs_Created_Full_Time_AI__c='5';
        CMGTest.Jobs_Created_Part_Time_AI__c='5'; 
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);           
        CMGTest.Market__c = 'South Dakota';                                          
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;        
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, false);        
        ce_No_Upload.Savecommunityinvestment();
    }
    
    public static testMethod void TestStrongLocal_NonNumeric1 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Strong Local Economies';
        CMGTest.Small_Businesses_Assisted_AI__c='3f';
        CMGTest.New_Businesses_Served_AI__c='5';
        CMGTest.Workshops_Training_Events_Provided_AI__c='5';
        CMGTest.Indiv_Coaching_Sessions_w_Small_Bus_AI__c='5';
        CMGTest.Jobs_Created_Full_Time_AI__c='5';
        CMGTest.Jobs_Created_Part_Time_AI__c='5';  
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9); 
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';                                           
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;        
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }
        
    public static testMethod void TestStrongLocal_NonNumeric2 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Strong Local Economies';
        CMGTest.Small_Businesses_Assisted_AI__c='5';
        CMGTest.New_Businesses_Served_AI__c='3f';
        CMGTest.Workshops_Training_Events_Provided_AI__c='5';
        CMGTest.Indiv_Coaching_Sessions_w_Small_Bus_AI__c='5';
        CMGTest.Jobs_Created_Full_Time_AI__c='5';
        CMGTest.Jobs_Created_Part_Time_AI__c='5';  
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9); 
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);           
        CMGTest.Market__c = 'South Dakota';                                        
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;        
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestStrongLocal_NonNumeric3 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Strong Local Economies';
        CMGTest.Small_Businesses_Assisted_AI__c='5';
        CMGTest.New_Businesses_Served_AI__c='5';
        CMGTest.Workshops_Training_Events_Provided_AI__c='3f';
        CMGTest.Indiv_Coaching_Sessions_w_Small_Bus_AI__c='5';
        CMGTest.Jobs_Created_Full_Time_AI__c='5';
        CMGTest.Jobs_Created_Part_Time_AI__c='5'; 
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9); 
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);         
        CMGTest.Market__c = 'South Dakota';                                           
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;        
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestStrongLocal_NonNumeric4 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Strong Local Economies';
        CMGTest.Small_Businesses_Assisted_AI__c='5';
        CMGTest.New_Businesses_Served_AI__c='5';
        CMGTest.Workshops_Training_Events_Provided_AI__c='5';
        CMGTest.Indiv_Coaching_Sessions_w_Small_Bus_AI__c='3f';
        CMGTest.Jobs_Created_Full_Time_AI__c='5';
        CMGTest.Jobs_Created_Part_Time_AI__c='5'; 
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9); 
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);        
        CMGTest.Market__c = 'South Dakota';                                            
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;        
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestStrongLocal_NonNumeric5 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Strong Local Economies';
        CMGTest.Small_Businesses_Assisted_AI__c='5';
        CMGTest.New_Businesses_Served_AI__c='5';
        CMGTest.Workshops_Training_Events_Provided_AI__c='5';
        CMGTest.Indiv_Coaching_Sessions_w_Small_Bus_AI__c='5';
        CMGTest.Jobs_Created_Full_Time_AI__c='4z';
        CMGTest.Jobs_Created_Part_Time_AI__c='5';
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);          
        CMGTest.Market__c = 'South Dakota';                                          
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;        
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

    public static testMethod void TestStrongLocal_NonNumeric6 () {
        Community_Giving__c CMGTest=new Community_Giving__c();
        CMGTest.purpose__c = 'Strong Local Economies';
        CMGTest.Small_Businesses_Assisted_AI__c='5';
        CMGTest.New_Businesses_Served_AI__c='5';
        CMGTest.Workshops_Training_Events_Provided_AI__c='5';
        CMGTest.Indiv_Coaching_Sessions_w_Small_Bus_AI__c='5';
        CMGTest.Jobs_Created_Full_Time_AI__c='5';
        CMGTest.Jobs_Created_Part_Time_AI__c='3f'; 
        CMGTest.Awarded_date__c = Date.newInstance(2017, 12, 9);
        CMGTest.Full_Name_And_Date__c = 'Yosemite Sam';
        CMGTest.Signed_Date__c = Date.newInstance(2017, 12, 18);         
        CMGTest.Market__c = 'South Dakota';                                            
        Insert CMGTest;
        PageReference pageRef = Page.GrantSurveyResponseForm;
        test.setCurrentPage(pageRef);        
        pageRef.getparameters().put('id', CMGTest.id);
        Community_giving__c No_Upload = CMGTest;        
        ApexPages.StandardController sc_No_Upload = new ApexPages.standardController(No_Upload);
        GrantReportTemplateCtrl ce_No_Upload = new GrantReportTemplateCtrl(sc_No_Upload);
        ce_No_Upload.nextpage();        
        system.assertEquals(ce_No_Upload.IsInputError, true);        
        ce_No_Upload.Savecommunityinvestment();
    }

}