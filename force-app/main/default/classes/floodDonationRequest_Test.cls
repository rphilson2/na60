@isTest
public class floodDonationRequest_Test {

//------------------------ Page 1 tests (tests going from page 1 to page 2--------------------------------------
    @isTest
    public static void floodDonationRequestControllerTestPage2CheckBoxValidTaxid () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);
            
        ce_omaha.beginApplication();
        System.assertEquals(ce_omaha.showFirstPage, true);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, false); 
        System.assertEquals(floodDon_omaha.submitted__c, False);

        floodDon_omaha.Tax_ID__c = '11-1111111';
        floodDon_omaha.First_National_Bank_Request__c = True;
        ce_omaha.flood2();        
        System.assertEquals(ce_omaha.showFirstPage, false);
        System.assertEquals(ce_omaha.showSecPage, true);
        System.assertEquals(ce_omaha.showThirdPage, false); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
    }
    @isTest
    public static void floodDonationRequestControllerTestPage2DoNotCheckBox () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);

        floodDon_omaha.Tax_ID__c = '11-1111111';

        floodDon_omaha.First_National_Bank_Request__c = false;
        ce_omaha.flood2();
        System.assertEquals(ce_omaha.showFirstPage, true);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, false);
        System.assertEquals(floodDon_omaha.submitted__c, False);
    }
    @isTest
    public static void floodDonationRequestControllerTestPage2TaxIDErrorTooFewDigits () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);

        floodDon_omaha.Tax_ID__c = '11-111111';  //Invalid Tax id, not enough digits

        floodDon_omaha.First_National_Bank_Request__c = true;
        ce_omaha.flood2();
        System.assertEquals(ce_omaha.showFirstPage, true);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, false); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
    }
    @isTest
    public static void floodDonationRequestControllerTestPage2TaxIDErrorAlphaDigit () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);

        floodDon_omaha.Tax_ID__c = '11-111111A';  //Invalid Tax id, got a letter in it.

        floodDon_omaha.First_National_Bank_Request__c = true;
        ce_omaha.flood2();
        System.assertEquals(ce_omaha.showFirstPage, true);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, false); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
    }

    @isTest
    public static void floodDonationRequestControllerTestPage2EndDateAfterStartDate () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);
            
        ce_omaha.beginApplication();
        System.assertEquals(ce_omaha.showFirstPage, true);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, false); 
        System.assertEquals(floodDon_omaha.submitted__c, False);

        floodDon_omaha.Tax_ID__c = '11-1111111';
        floodDon_omaha.First_National_Bank_Request__c = True;
        floodDon_omaha.Program_Event_Date__c = system.today() + 5;
        floodDon_omaha.Flood_Anticipated_End_Date__c = system.today() + 10;        
        ce_omaha.flood2();        
        System.assertEquals(ce_omaha.showFirstPage, false);
        System.assertEquals(ce_omaha.showSecPage, true);
        System.assertEquals(ce_omaha.showThirdPage, false); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
    }

    @isTest
    public static void floodDonationRequestControllerTestPage2EndDateBeforeStartDate () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);
            
        ce_omaha.beginApplication();
        System.assertEquals(ce_omaha.showFirstPage, true);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, false); 
        System.assertEquals(floodDon_omaha.submitted__c, False);

        floodDon_omaha.Tax_ID__c = '11-1111111';
        floodDon_omaha.First_National_Bank_Request__c = True;
        floodDon_omaha.Program_Event_Date__c = system.today() + 10;
        floodDon_omaha.Flood_Anticipated_End_Date__c = system.today() + 5;        
        ce_omaha.flood2();        
        System.assertEquals(ce_omaha.showFirstPage, true);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, false); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
    }

//------------------------ Page 2 tests (tests going from page 2 to page 3--------------------------------------
    
    @isTest
    public static void floodDonationRequestControllerTestPage3NPStatus501C3 () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);

        floodDon_omaha.Non_Profit_Status__c = '501C(3)';
        ce_omaha.annual_audit = 'false';
        
        ce_omaha.flood3();

        System.assertEquals(ce_omaha.showFirstPage, false);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, true); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
    }

    @isTest
    public static void floodDonationRequestControllerTestPage3NPStatusOtherBlank () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);

        floodDon_omaha.Tax_ID__c = '11-1111111';
        floodDon_omaha.First_National_Bank_Request__c = True;
        ce_omaha.flood2();        
        
        floodDon_omaha.Non_Profit_Status__c = 'Other';
        floodDon_omaha.Non_Profit_Status_Other__c = null;
        ce_omaha.flood3();

        System.assertEquals(ce_omaha.showFirstPage, false);
        System.assertEquals(ce_omaha.showSecPage, true);
        System.assertEquals(ce_omaha.showThirdPage, false); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
    }

    @isTest
    public static void floodDonationRequestControllerTestPage3NPStatusOtherWithValue () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);

        floodDon_omaha.Tax_ID__c = '11-1111111';
        floodDon_omaha.First_National_Bank_Request__c = True;
        ce_omaha.flood2();        
            
        floodDon_omaha.Non_Profit_Status__c = 'Other';
        floodDon_omaha.Non_Profit_Status_Other__c = '501L(4)';
        ce_omaha.annual_audit = 'true';
        ce_omaha.flood3();

        System.assertEquals(ce_omaha.showFirstPage, false);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, true); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
    }

    @isTest
    public static void floodDonationRequestControllerTestPage3AnnualAuditTrue () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);

        floodDon_omaha.Tax_ID__c = '11-1111111';
        floodDon_omaha.First_National_Bank_Request__c = True;
        ce_omaha.flood2();        
            
        floodDon_omaha.Non_Profit_Status__c = 'Other';
        floodDon_omaha.Non_Profit_Status_Other__c = '501L(4)';
        ce_omaha.annual_audit = 'true';
        
        ce_omaha.flood3();

        System.assertEquals(ce_omaha.showFirstPage, false);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, true); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
        system.assertequals(ce_omaha.flood.Annual_Independent_Audit__c, true);
        
    }

    @isTest
    public static void floodDonationRequestControllerTestPage3AnnualAuditFalse () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);

        floodDon_omaha.Tax_ID__c = '11-1111111';
        floodDon_omaha.First_National_Bank_Request__c = True;
        ce_omaha.flood2();        
            
        floodDon_omaha.Non_Profit_Status__c = 'Other';
        floodDon_omaha.Non_Profit_Status_Other__c = '501L(4)';
        ce_omaha.annual_audit = 'true';
        ce_omaha.flood3();        

        System.assertEquals(ce_omaha.showFirstPage, false);
        System.assertEquals(ce_omaha.showSecPage, false);
        System.assertEquals(ce_omaha.showThirdPage, true); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
        system.assertequals(ce_omaha.flood.Annual_Independent_Audit__c, true);
        
    }

    @isTest
    public static void floodDonationRequestControllerTestPage3AnnualAuditNull () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);

        floodDon_omaha.Tax_ID__c = '11-1111111';
        floodDon_omaha.First_National_Bank_Request__c = True;
        ce_omaha.flood2();        
            
        floodDon_omaha.Non_Profit_Status__c = 'Other';
        floodDon_omaha.Non_Profit_Status_Other__c = '501L(4)';
        
        ce_omaha.flood3();

        System.assertEquals(ce_omaha.showFirstPage, false);
        System.assertEquals(ce_omaha.showSecPage, true);
        System.assertEquals(ce_omaha.showThirdPage, false); 
        System.assertEquals(floodDon_omaha.submitted__c, False);
        system.assertequals(ce_omaha.flood.Annual_Independent_Audit__c, false);
        
    }

//------------------------ Page 3 tests (tests going from page 3 to Submit--------------------------------------

    @isTest
    public static void floodDonationRequestControllerTestSubmit () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);
          
    }

//------------------------ Page 3 test attachments--------------------------------------
    
    @isTest
    public static void floodDonationRequestControllerTestAttachSubmit () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);
          
        attachment attachment = new attachment();
        List<Attachment> attachlist = new list<Attachment>();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
        attachlist.add(attachment);
        ce_omaha.allFileList = attachlist;
        ce_omaha.attach(); 
        attachment attachment2 = new attachment();
        List<Attachment> attachlist2 = new list<Attachment>();
        attachment2.Name = 'attach test2 attach test2';
        blob bodystuff2 = blob.valueOf('attach test2 attach test2');
        attachment2.body = bodystuff2;
        attachlist2.add(attachment2);
        ce_omaha.allFileList = attachlist2;
        ce_omaha.attach(); 
        ce_omaha.annual_audit = 'false';
        ce_omaha.submit();
        system.assertequals(ce_omaha.flood.Annual_Independent_Audit__c, false);
    }    
    @isTest    
    public static void floodDonationRequestControllerTestDeleteAttachSubmitPDF () {
        
        FIC_Survey_Application__c floodDon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.Flood_Relief_form_intro;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(floodDon_omaha);
        floodDonationRequest_Controller ce_omaha = new floodDonationRequest_Controller(sc_omaha);
          
        attachment attachment = new attachment();
        List<Attachment> attachlist = new list<Attachment>();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
        attachlist.add(attachment);
        ce_omaha.allFileList = attachlist;
        ce_omaha.attach(); 
        attachment attachment2 = new attachment();
        List<Attachment> attachlist2 = new list<Attachment>();
        attachment2.Name = 'attach test2 attach test2';
        blob bodystuff2 = blob.valueOf('attach test2 attach test2');
        attachment2.body = bodystuff2;
        attachlist2.add(attachment2);
        ce_omaha.allFileList = attachlist2;
        ce_omaha.attach();         
        ce_omaha.delete25Attachments();
        ce_omaha.submit();

        system.assertequals(ce_omaha.flood.submitted__c, true);

        ce_omaha.createpdf();
        
    }
    
}