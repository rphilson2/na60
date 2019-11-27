@isTest
public class donationAndSponsorshipForm_Test {

    public static testMethod void donationAndSponsorshipFormControllerTestOmaha () {
        
        FIC_Survey_Application__c donSpon_omaha = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_omaha;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_omaha = new ApexPages.standardController(donSpon_omaha);
        donationAndSponsorshipForm_Controller ce_omaha = new donationAndSponsorshipForm_Controller(sc_omaha);
            
        ce_omaha.omaha();
        ce_omaha.donprev();
      /*ce_omaha.lincoln();
        ce_omaha.kearney();
        ce_omaha.columbus();
        ce_omaha.fremont();
        ce_omaha.northplatte();
        ce_omaha.southdakota();
        ce_omaha.kansas();
        ce_omaha.illinois();
        ce_omaha.colorado();
        ce_omaha.texas(); */
        
        System.assertNotEquals(donSpon_omaha.Market__c, 'Omaha');
        System.assertEquals(donSpon_omaha.submitted__c, False);

        donSpon_omaha.Tax_ID__c = '11-1111111';
        ce_omaha.TaxIDError = false;
        donSpon_omaha.First_National_Bank_Request__c = True;
        donSpon_omaha.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_omaha.Organization_Have_Relationship__c = 'No';
        
        ce_omaha.donSpon2();
        donSpon_omaha.First_National_Bank_Request__c = false;
        ce_omaha.donSpon2();
        donSpon_omaha.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_omaha.Provide_Name_and_Service_Description__c = null;
        ce_omaha.donSpon2();
        donSpon_omaha.Organization_Have_Relationship__c= 'Yes';
        donSpon_omaha.Please_Describe_Relationship__c = null;
        ce_omaha.donSpon2();
        donSpon_omaha.First_National_Bank_Employee_on_Board__c = 'Unknown';
        donSpon_omaha.Provide_Name_and_Service_Description__c = null;
        donSpon_omaha.Organization_Have_Relationship__c= 'Yes';
        donSpon_omaha.Please_Describe_Relationship__c = 'Test Data';
        ce_omaha.donSpon2();

        donSpon_omaha.Non_Profit_Status__c = '501C(3)';
        donSpon_omaha.Individuals_Served_Low_Income__c = 'No';
        
        ce_omaha.donSpon3();
        donSpon_omaha.Non_Profit_Status__c = 'Other';
        donSpon_omaha.Non_Profit_Status_Other__c = null;
        ce_omaha.donSpon3();
        donSpon_omaha.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_omaha.Evidence_of_Income_Status__c = null;
        ce_omaha.donSpon3();
        donSpon_omaha.Non_Profit_Status__c = '501C(6)';
        donSpon_omaha.Non_Profit_Status_Other__c = '504L(2)';
        donSpon_omaha.Individuals_Served_Low_Income__c = 'No' ;
        donSpon_omaha.Evidence_of_Income_Status__c = 'Test Data';
        ce_omaha.donSpon3();
        donSpon_omaha.Individuals_Served_Low_Income__c = 'Unknown' ;
        donSpon_omaha.Evidence_of_Income_Status__c = null;
        ce_omaha.donSpon3();
        donSpon_omaha.Individuals_Served_Low_Income__c = 'Unknown' ;
        donSpon_omaha.Evidence_of_Income_Status__c = 'Test Dat Unknown';
        ce_omaha.donSpon3();
      
        attachment attachment = new attachment();
        List<Attachment> attachlist = new list<Attachment>();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
        attachlist.add(attachment);
        ce_omaha.allFileList = attachlist;
        ce_omaha.attach(); 
        
      //attachment att = ce_omaha.myfile;
        ce_omaha.submit();
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_omaha.delete25Attachments();

        //ce_omaha.submit();
        System.assertnotEquals(donSpon_omaha.submitted__c, True);
        ce_omaha.createpdf();
        
    }
    public static testMethod void donationAndSponsorshipFormControllerTestlincoln () {
        
        FIC_Survey_Application__c donSpon_lincoln = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_lincoln;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_lincoln = new ApexPages.standardController(donSpon_lincoln);
        donationAndSponsorshipForm_Controller ce_lincoln = new donationAndSponsorshipForm_Controller(sc_lincoln);
            
        ce_lincoln.lincoln();
        
        System.assertnotEquals(donSpon_lincoln.Market__c, 'Lincoln');
        System.assertEquals(donSpon_lincoln.submitted__c, False);
        
        donSpon_lincoln.Tax_ID__c = '22-222222';
        donSpon_lincoln.First_National_Bank_Request__c = True;
        donSpon_lincoln.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_lincoln.Organization_Have_Relationship__c = 'No';
        
        ce_lincoln.donSpon2();
        donSpon_lincoln.First_National_Bank_Request__c = false;
        ce_lincoln.donSpon2();
        donSpon_lincoln.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_lincoln.Provide_Name_and_Service_Description__c = null;
        ce_lincoln.donSpon2();
        donSpon_lincoln.Organization_Have_Relationship__c= 'Yes';
        donSpon_lincoln.Please_Describe_Relationship__c = null;
        ce_lincoln.donSpon2();

        donSpon_lincoln.Non_Profit_Status__c = '501C(3)';
        donSpon_lincoln.Individuals_Served_Low_Income__c = 'No';
        
        ce_lincoln.donSpon3();
        donSpon_lincoln.Non_Profit_Status__c = 'Other';
        donSpon_lincoln.Non_Profit_Status_Other__c = null;
        ce_lincoln.donSpon3();
        donSpon_lincoln.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_lincoln.Evidence_of_Income_Status__c = null;
        ce_lincoln.donSpon3();
      
        attachment attachment = new attachment();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
      //ce_lincoln.myfile = attachment;
        //ce_lincoln.attach(); 
        
      //attachment att = ce_lincoln.myfile;
        
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_lincoln.delete25Attachments();

        ce_lincoln.submit();
        System.assertnotEquals(donSpon_lincoln.submitted__c, True);        
        ce_lincoln.createpdf();
        
    }

    public static testMethod void donationAndSponsorshipFormControllerTestkearney () {
        
        FIC_Survey_Application__c donSpon_kearney = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_kearney;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_kearney = new ApexPages.standardController(donSpon_kearney);
        donationAndSponsorshipForm_Controller ce_kearney = new donationAndSponsorshipForm_Controller(sc_kearney);
            
        ce_kearney.kearney();
        
        System.assertnotEquals(donSpon_kearney.Market__c, 'Kearney');
        System.assertEquals(donSpon_kearney.submitted__c, False);        
        
        donSpon_kearney.Tax_ID__c = '33-333x333';
        donSpon_kearney.First_National_Bank_Request__c = True;
        donSpon_kearney.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_kearney.Organization_Have_Relationship__c = 'No';
        
        ce_kearney.donSpon2();
        donSpon_kearney.First_National_Bank_Request__c = false;
        ce_kearney.donSpon2();
        donSpon_kearney.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_kearney.Provide_Name_and_Service_Description__c = null;
        ce_kearney.donSpon2();
        donSpon_kearney.Organization_Have_Relationship__c= 'Yes';
        donSpon_kearney.Please_Describe_Relationship__c = null;
        ce_kearney.donSpon2();

        donSpon_kearney.Non_Profit_Status__c = '501C(3)';
        donSpon_kearney.Individuals_Served_Low_Income__c = 'No';
        
        ce_kearney.donSpon3();
        donSpon_kearney.Non_Profit_Status__c = 'Other';
        donSpon_kearney.Non_Profit_Status_Other__c = null;
        ce_kearney.donSpon3();
        donSpon_kearney.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_kearney.Evidence_of_Income_Status__c = null;
        ce_kearney.donSpon3();
      
        attachment attachment = new attachment();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
      //ce_kearney.myfile = attachment;
        //ce_kearney.attach(); 
        
      //attachment att = ce_kearney.myfile;
        
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_kearney.delete25Attachments();

        ce_kearney.submit();
        System.assertnotEquals(donSpon_kearney.submitted__c, True);        
        ce_kearney.createpdf();
        
    }

    public static testMethod void donationAndSponsorshipFormControllerTestcolumbus () {
        
        FIC_Survey_Application__c donSpon_columbus = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_columbus;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_columbus = new ApexPages.standardController(donSpon_columbus);
        donationAndSponsorshipForm_Controller ce_columbus = new donationAndSponsorshipForm_Controller(sc_columbus);
            
        ce_columbus.columbus();
        
        System.assertnotEquals(donSpon_columbus.Market__c, 'Columbus');
        System.assertEquals(donSpon_columbus.submitted__c, False);
        
        donSpon_columbus.Tax_ID__c = '44-4444444';        
        donSpon_columbus.First_National_Bank_Request__c = True;
        donSpon_columbus.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_columbus.Organization_Have_Relationship__c = 'No';
        
        ce_columbus.donSpon2();
        donSpon_columbus.First_National_Bank_Request__c = false;
        ce_columbus.donSpon2();
        donSpon_columbus.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_columbus.Provide_Name_and_Service_Description__c = null;
        ce_columbus.donSpon2();
        donSpon_columbus.Organization_Have_Relationship__c= 'Yes';
        donSpon_columbus.Please_Describe_Relationship__c = null;
        ce_columbus.donSpon2();

        donSpon_columbus.Non_Profit_Status__c = '501C(3)';
        donSpon_columbus.Individuals_Served_Low_Income__c = 'No';
        
        ce_columbus.donSpon3();
        donSpon_columbus.Non_Profit_Status__c = 'Other';
        donSpon_columbus.Non_Profit_Status_Other__c = null;
        ce_columbus.donSpon3();
        donSpon_columbus.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_columbus.Evidence_of_Income_Status__c = null;
        ce_columbus.donSpon3();
      
        attachment attachment = new attachment();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
      //ce_columbus.myfile = attachment;
       // ce_columbus.attach(); 
        
      //attachment att = ce_columbus.myfile;
        
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_columbus.delete25Attachments();

        ce_columbus.submit();
        System.assertnotEquals(donSpon_columbus.submitted__c, True);
        
        ce_columbus.createpdf();
        
    }

    public static testMethod void donationAndSponsorshipFormControllerTestfremont () {
        
        FIC_Survey_Application__c donSpon_fremont = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_fremont;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_fremont = new ApexPages.standardController(donSpon_fremont);
        donationAndSponsorshipForm_Controller ce_fremont = new donationAndSponsorshipForm_Controller(sc_fremont);
            
        ce_fremont.fremont();
        
        System.assertnotEquals(donSpon_fremont.Market__c, 'Fremont');
        System.assertEquals(donSpon_fremont.submitted__c, False);   

        donSpon_fremont.Tax_ID__c = '55-5555555';
        donSpon_fremont.First_National_Bank_Request__c = True;
        donSpon_fremont.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_fremont.Organization_Have_Relationship__c = 'No';
        
        ce_fremont.donSpon2();
        donSpon_fremont.First_National_Bank_Request__c = false;
        ce_fremont.donSpon2();
        donSpon_fremont.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_fremont.Provide_Name_and_Service_Description__c = null;
        ce_fremont.donSpon2();
        donSpon_fremont.Organization_Have_Relationship__c= 'Yes';
        donSpon_fremont.Please_Describe_Relationship__c = null;
        ce_fremont.donSpon2();

        donSpon_fremont.Non_Profit_Status__c = '501C(3)';
        donSpon_fremont.Individuals_Served_Low_Income__c = 'No';
        
        ce_fremont.donSpon3();
        donSpon_fremont.Non_Profit_Status__c = 'Other';
        donSpon_fremont.Non_Profit_Status_Other__c = null;
        ce_fremont.donSpon3();
        donSpon_fremont.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_fremont.Evidence_of_Income_Status__c = null;
        ce_fremont.donSpon3();
      
        attachment attachment = new attachment();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
      //ce_fremont.myfile = attachment;
        //ce_fremont.attach(); 
        
      //attachment att = ce_fremont.myfile;
        
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_fremont.delete25Attachments();

        ce_fremont.submit();
        System.assertnotEquals(donSpon_fremont.submitted__c, True);
        
        ce_fremont.createpdf();
        
    }

    public static testMethod void donationAndSponsorshipFormControllerTestnorthplatte () {
        
        FIC_Survey_Application__c donSpon_northplatte = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_northpla;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_northplatte = new ApexPages.standardController(donSpon_northplatte);
        donationAndSponsorshipForm_Controller ce_northplatte = new donationAndSponsorshipForm_Controller(sc_northplatte);
            
        ce_northplatte.northplatte();
        
        System.assertnotEquals(donSpon_northplatte.Market__c, 'North Platte');
        System.assertEquals(donSpon_northplatte.submitted__c, False);
        
        donSpon_northplatte.Tax_ID__c = '66-6666666';        
        donSpon_northplatte.First_National_Bank_Request__c = True;
        donSpon_northplatte.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_northplatte.Organization_Have_Relationship__c = 'No';
        
        ce_northplatte.donSpon2();
        donSpon_northplatte.First_National_Bank_Request__c = false;
        ce_northplatte.donSpon2();
        donSpon_northplatte.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_northplatte.Provide_Name_and_Service_Description__c = null;
        ce_northplatte.donSpon2();
        donSpon_northplatte.Organization_Have_Relationship__c= 'Yes';
        donSpon_northplatte.Please_Describe_Relationship__c = null;
        ce_northplatte.donSpon2();

        donSpon_northplatte.Non_Profit_Status__c = '501C(3)';
        donSpon_northplatte.Individuals_Served_Low_Income__c = 'No';
        
        ce_northplatte.donSpon3();
        donSpon_northplatte.Non_Profit_Status__c = 'Other';
        donSpon_northplatte.Non_Profit_Status_Other__c = null;
        ce_northplatte.donSpon3();
        donSpon_northplatte.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_northplatte.Evidence_of_Income_Status__c = null;
        ce_northplatte.donSpon3();
      
        attachment attachment = new attachment();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
      //ce_northplatte.myfile = attachment;
        //ce_northplatte.attach(); 
        
      //attachment att = ce_northplatte.myfile;
        
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_northplatte.delete25Attachments();

        ce_northplatte.submit();
        System.assertnotEquals(donSpon_northplatte.submitted__c, True);
        
        ce_northplatte.createpdf();
        
    }

    public static testMethod void donationAndSponsorshipFormControllerTestsouthdakota () {
        
        FIC_Survey_Application__c donSpon_southdakota = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_southdak;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_southdakota = new ApexPages.standardController(donSpon_southdakota);
        donationAndSponsorshipForm_Controller ce_southdakota = new donationAndSponsorshipForm_Controller(sc_southdakota);
            
        ce_southdakota.southdakota();
        
        System.assertnotEquals(donSpon_southdakota.Market__c, 'South Dakota');
        System.assertEquals(donSpon_southdakota.submitted__c, False);

        donSpon_southdakota.Tax_ID__c = '77-7777777';                
        donSpon_southdakota.First_National_Bank_Request__c = True;
        donSpon_southdakota.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_southdakota.Organization_Have_Relationship__c = 'No';
        
        ce_southdakota.donSpon2();
        donSpon_southdakota.First_National_Bank_Request__c = false;
        ce_southdakota.donSpon2();
        donSpon_southdakota.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_southdakota.Provide_Name_and_Service_Description__c = null;
        ce_southdakota.donSpon2();
        donSpon_southdakota.Organization_Have_Relationship__c= 'Yes';
        donSpon_southdakota.Please_Describe_Relationship__c = null;
        ce_southdakota.donSpon2();

        donSpon_southdakota.Non_Profit_Status__c = '501C(3)';
        donSpon_southdakota.Individuals_Served_Low_Income__c = 'No';
        
        ce_southdakota.donSpon3();
        donSpon_southdakota.Non_Profit_Status__c = 'Other';
        donSpon_southdakota.Non_Profit_Status_Other__c = null;
        ce_southdakota.donSpon3();
        donSpon_southdakota.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_southdakota.Evidence_of_Income_Status__c = null;
        ce_southdakota.donSpon3();
      
        attachment attachment = new attachment();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
      //ce_southdakota.myfile = attachment;
        //ce_southdakota.attach(); 
        
      //attachment att = ce_southdakota.myfile;
        
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_southdakota.delete25Attachments();

        ce_southdakota.submit();
        System.assertnotEquals(donSpon_southdakota.submitted__c, True);
        
        ce_southdakota.createpdf();
        
    }
    public static testMethod void donationAndSponsorshipFormControllerTestkansas () {
        
        FIC_Survey_Application__c donSpon_kansas = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_kansas;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_kansas = new ApexPages.standardController(donSpon_kansas);
        donationAndSponsorshipForm_Controller ce_kansas = new donationAndSponsorshipForm_Controller(sc_kansas);
            
        ce_kansas.kansas();
        
        System.assertnotEquals(donSpon_kansas.Market__c, 'Kansas');
        System.assertEquals(donSpon_kansas.submitted__c, False);        

        donSpon_kansas.Tax_ID__c = '88-8888888';        
        donSpon_kansas.First_National_Bank_Request__c = True;
        donSpon_kansas.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_kansas.Organization_Have_Relationship__c = 'No';
        
        ce_kansas.donSpon2();
        donSpon_kansas.First_National_Bank_Request__c = false;
        ce_kansas.donSpon2();
        donSpon_kansas.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_kansas.Provide_Name_and_Service_Description__c = null;
        ce_kansas.donSpon2();
        donSpon_kansas.Organization_Have_Relationship__c= 'Yes';
        donSpon_kansas.Please_Describe_Relationship__c = null;
        ce_kansas.donSpon2();

        donSpon_kansas.Non_Profit_Status__c = '501C(3)';
        donSpon_kansas.Individuals_Served_Low_Income__c = 'No';
        
        ce_kansas.donSpon3();
        donSpon_kansas.Non_Profit_Status__c = 'Other';
        donSpon_kansas.Non_Profit_Status_Other__c = null;
        ce_kansas.donSpon3();
        donSpon_kansas.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_kansas.Evidence_of_Income_Status__c = null;
        ce_kansas.donSpon3();
      
        attachment attachment = new attachment();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
      //ce_kansas.myfile = attachment;
       // ce_kansas.attach(); 
        
      //attachment att = ce_kansas.myfile;
        
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_kansas.delete25Attachments();

        ce_kansas.submit();
        System.assertnotEquals(donSpon_kansas.submitted__c, True);        
        
        ce_kansas.createpdf();
        
    }

    public static testMethod void donationAndSponsorshipFormControllerTestillinois () {
        
        FIC_Survey_Application__c donSpon_illinois = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_illinois;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_illinois = new ApexPages.standardController(donSpon_illinois);
        donationAndSponsorshipForm_Controller ce_illinois = new donationAndSponsorshipForm_Controller(sc_illinois);
            
        ce_illinois.illinois();
        
        System.assertnotEquals(donSpon_illinois.Market__c, 'Illinois');
        System.assertEquals(donSpon_illinois.submitted__c, False);        
        
        donSpon_illinois.Tax_ID__c = '99-9999999';        
        donSpon_illinois.First_National_Bank_Request__c = True;
        donSpon_illinois.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_illinois.Organization_Have_Relationship__c = 'No';
        
        ce_illinois.donSpon2();
        donSpon_illinois.First_National_Bank_Request__c = false;
        ce_illinois.donSpon2();
        donSpon_illinois.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_illinois.Provide_Name_and_Service_Description__c = null;
        ce_illinois.donSpon2();
        donSpon_illinois.Organization_Have_Relationship__c= 'Yes';
        donSpon_illinois.Please_Describe_Relationship__c = null;
        ce_illinois.donSpon2();

        donSpon_illinois.Non_Profit_Status__c = '501C(3)';
        donSpon_illinois.Individuals_Served_Low_Income__c = 'No';
        
        ce_illinois.donSpon3();
        donSpon_illinois.Non_Profit_Status__c = 'Other';
        donSpon_illinois.Non_Profit_Status_Other__c = null;
        ce_illinois.donSpon3();
        donSpon_illinois.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_illinois.Evidence_of_Income_Status__c = null;
        ce_illinois.donSpon3();
      
        attachment attachment = new attachment();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
      //ce_illinois.myfile = attachment;
        //ce_illinois.attach(); 
        
      //attachment att = ce_illinois.myfile;
        
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_illinois.delete25Attachments();

        ce_illinois.submit();
        System.assertnotEquals(donSpon_illinois.submitted__c, True);        
        
        ce_illinois.createpdf();
        
    }

    public static testMethod void donationAndSponsorshipFormControllerTestcolorado () {
        
        FIC_Survey_Application__c donSpon_colorado = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_colorado;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_colorado = new ApexPages.standardController(donSpon_colorado);
        donationAndSponsorshipForm_Controller ce_colorado = new donationAndSponsorshipForm_Controller(sc_colorado);
            
        ce_colorado.colorado();
        
        System.assertnotEquals(donSpon_colorado.Market__c, 'Colorado');
        System.assertEquals(donSpon_colorado.submitted__c, False);                

        donSpon_colorado.Tax_ID__c = '00-0000000';
        donSpon_colorado.First_National_Bank_Request__c = True;
        donSpon_colorado.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_colorado.Organization_Have_Relationship__c = 'No';
        
        ce_colorado.donSpon2();
        donSpon_colorado.First_National_Bank_Request__c = false;
        ce_colorado.donSpon2();
        donSpon_colorado.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_colorado.Provide_Name_and_Service_Description__c = null;
        ce_colorado.donSpon2();
        donSpon_colorado.Organization_Have_Relationship__c= 'Yes';
        donSpon_colorado.Please_Describe_Relationship__c = null;
        ce_colorado.donSpon2();

        donSpon_colorado.Non_Profit_Status__c = '501C(3)';
        donSpon_colorado.Individuals_Served_Low_Income__c = 'No';
        
        ce_colorado.donSpon3();
        donSpon_colorado.Non_Profit_Status__c = 'Other';
        donSpon_colorado.Non_Profit_Status_Other__c = null;
        ce_colorado.donSpon3();
        donSpon_colorado.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_colorado.Evidence_of_Income_Status__c = null;
        ce_colorado.donSpon3();
      
        attachment attachment = new attachment();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
      //ce_colorado.myfile = attachment;
        //ce_colorado.attach(); 
        
      //attachment att = ce_colorado.myfile;
        
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_colorado.delete25Attachments();

        ce_colorado.submit();
        System.assertnotEquals(donSpon_colorado.submitted__c, True);
        
        ce_colorado.createpdf();
        
    }

    public static testMethod void donationAndSponsorshipFormControllerTesttexas () {
        
        FIC_Survey_Application__c donSpon_texas = new FIC_Survey_Application__c();
        PageReference pageRef = Page.donation_and_sponsorship_form_southwest;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here

        ApexPages.StandardController sc_texas = new ApexPages.standardController(donSpon_texas);
        donationAndSponsorshipForm_Controller ce_texas = new donationAndSponsorshipForm_Controller(sc_texas);
            
        ce_texas.texas();
        
        System.assertnotEquals(donSpon_texas.Market__c, 'Texas');
        System.assertEquals(donSpon_texas.submitted__c, False);        

        donSpon_texas.Tax_ID__c = '00-1111111'; 
        donSpon_texas.First_National_Bank_Request__c = True;
        donSpon_texas.First_National_Bank_Employee_on_Board__c = 'No';
        donSpon_texas.Organization_Have_Relationship__c = 'No';
        
        ce_texas.donSpon2();
        donSpon_texas.First_National_Bank_Request__c = false;
        ce_texas.donSpon2();
        donSpon_texas.First_National_Bank_Employee_on_Board__c= 'Yes';
        donSpon_texas.Provide_Name_and_Service_Description__c = null;
        ce_texas.donSpon2();
        donSpon_texas.Organization_Have_Relationship__c= 'Yes';
        donSpon_texas.Please_Describe_Relationship__c = null;
        ce_texas.donSpon2();

        donSpon_texas.Non_Profit_Status__c = '501C(3)';
        donSpon_texas.Individuals_Served_Low_Income__c = 'No';
        
        ce_texas.donSpon3();
        donSpon_texas.Non_Profit_Status__c = 'Other';
        donSpon_texas.Non_Profit_Status_Other__c = null;
        ce_texas.donSpon3();
        donSpon_texas.Individuals_Served_Low_Income__c = 'Yes' ;
        donSpon_texas.Evidence_of_Income_Status__c = null;
        ce_texas.donSpon3();
      
        attachment attachment = new attachment();
        attachment.Name = 'attach test attach test';
        blob bodystuff = blob.valueOf('attach test attach test');
        attachment.body = bodystuff;
      //ce_texas.myfile = attachment;
        //ce_texas.attach(); 
        
      //attachment att = ce_texas.myfile;
        
        //System.assertEquals(attachmentDelList.size(), 0);
        ce_texas.delete25Attachments();

        ce_texas.submit();
        System.assertnotEquals(donSpon_texas.submitted__c, True);        
        
        ce_texas.createpdf();
        
    }
    public static testMethod void testlaunchOmaha () {
        
        FIC_Survey_Application__c donSpon_omahalaunch = new FIC_Survey_Application__c();
        donSpon_omahalaunch.Market__c = 'Omaha';
        ApexPages.StandardController sc_omahalaunch = new ApexPages.standardController(donSpon_omahalaunch);
        donationAndSponsorshipForm_Controller ce_omahalaunch = new donationAndSponsorshipForm_Controller(sc_omahalaunch);
            
        ce_omahalaunch.launch();
    }
    public static testMethod void testlaunchNorthPlatte () {
        
        FIC_Survey_Application__c donSpon_northplattelaunch = new FIC_Survey_Application__c();
        donSpon_northplattelaunch.Market__c = 'North Platte';
        ApexPages.StandardController sc_northplattelaunch = new ApexPages.standardController(donSpon_northplattelaunch);
        donationAndSponsorshipForm_Controller ce_northplattelaunch = new donationAndSponsorshipForm_Controller(sc_northplattelaunch);
            
        ce_northplattelaunch.launch();
    }    
    public static testMethod void testlaunchTexas () {
        
        FIC_Survey_Application__c donSpon_texaslaunch = new FIC_Survey_Application__c();
        donSpon_texaslaunch.Market__c = 'Texas';
        ApexPages.StandardController sc_texaslaunch = new ApexPages.standardController(donSpon_texaslaunch);
        donationAndSponsorshipForm_Controller ce_texaslaunch = new donationAndSponsorshipForm_Controller(sc_texaslaunch);
            
        ce_texaslaunch.launch();
    }    
    public static testMethod void testlaunchSouthDak () {
        
        FIC_Survey_Application__c donSpon_southdaklaunch = new FIC_Survey_Application__c();
        donSpon_southdaklaunch.Market__c = 'South Dakota';
        ApexPages.StandardController sc_southdaklaunch = new ApexPages.standardController(donSpon_southdaklaunch);
        donationAndSponsorshipForm_Controller ce_southdaklaunch = new donationAndSponsorshipForm_Controller(sc_southdaklaunch);
            
        ce_southdaklaunch.launch();
    }    
    
}