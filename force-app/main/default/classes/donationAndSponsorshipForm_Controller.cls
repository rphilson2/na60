//Author: Alexander Nourbakhsh
// Date Created/Modified: 09.12.2016
// Project: First In the Community (FIC) Donation and Sponsorship Survey Forms
// Purpose: 
//

public class donationAndSponsorshipForm_Controller {
  
    private final FIC_Survey_Application__c donSpon;
    public List<SelectOption> filesCountList {get; set;}
    private Id donSponId;
    Private  integer count;
   private list<Attachment>Attachmentids;
    public boolean showFirstPage{get;set;}
    public boolean showSecPage{get;set;}
    public boolean showThirdPage{get;set;}
    public boolean AttachThisTime{get;set;}
    public List<Attachment> allFileList {get; set;}
   //private  FIC_Survey_Application__c donSpon1;
    public String FileCount {get; set;}
  //DAG 08/03/2018 New variables here to validate format of Tax ID field. (ADS0002680)
    public string TaxidPrefix {get; set;}
    public string TaxidSuffix {get; set;}
    public boolean TaxIDError {get; set;}
    public string MarketHomePage {get; set;}
    
    // Get record of Talent Referral
    public donationAndSponsorshipForm_Controller (ApexPages.StandardController stdController) {
        showFirstPage = true;
        showSecPage = false;
        showThirdPage = false; 
          FileCount = '' ;
        count=0;
       filesCountList = new List<SelectOption>() ;
        //donSpon1=new FIC_Survey_Application__c();
        Attachmentids=new list<Attachment>();
        allFileList = new List<Attachment>() ;
       // filesCountList.add(new SelectOption('--None--','0'));
        for(Integer i = 1 ; i < 11 ; i++){
            filesCountList.add(new SelectOption(''+i , ''+i)) ;
        }
        donSpon = (FIC_Survey_Application__c)stdController.getRecord();
        //donSpon1=(FIC_Survey_Application__c)stdController.getRecord();
        system.debug('donSpon'+donSpon);
        //system.debug('donSpon1'+donSpon1);

       donSponId = stdController.getRecord().Id;
        donSpon.Market__c= ApexPages.currentPage().getParameters().get('Market');
       
        // Get Donation/Sponsorship record type
        donSpon.recordTypeId = [SELECT Id
                                FROM RecordType
                                WHERE sObjectType = 'FIC_Survey_Application__c'
                                AND Name = 'Donation/Sponsorship'
                                LIMIT 1].Id;
    }
    
     public PageReference ChangeCount()
    {
        allFileList.clear() ;
        //Adding multiple attachments instance
        for(Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)
            allFileList.add(new Attachment()) ;
        return null ;
    }

    //launch pages
    public PageReference launch() {
       switch on donSpon.Market__c {
         when 'North Platte' {MarketHomePage = 'northpla';}
         when 'Texas' {MarketHomePage = 'southwest';}
         when 'South Dakota' {MarketHomePage = 'southdak';}
         when else {MarketHomePage = donSpon.Market__c;}
       }
       PageReference page = new pageReference('/survey/donation_and_sponsorship_form_' + MarketHomePage);
       page.setRedirect(true);
       return page;        
     }    

    // Omaha begin button
    public PageReference omaha() {
        
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=Omaha');
        page.setRedirect(true);
        return page;
     }
     
    // Lincoln begin button
    public PageReference lincoln() {
        
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=Lincoln');
        page.setRedirect(true);
        return page;
     }
     
    // Kearney begin button
    public PageReference kearney() {
        
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=Kearney');
        page.setRedirect(true);
        return page;
     }
     
    // Columbus begin button
    public PageReference columbus() {
        
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=Columbus');               
        page.setRedirect(true);
        return page;
     }
     
    // Fremont begin button
    public PageReference fremont() {
        
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=Fremont');       
        page.setRedirect(true);
        return page;
     }
     
    // North Platte begin button
    public PageReference northplatte() {
        
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=North Platte');       
        page.setRedirect(true);
        return page;
     }
     
     
    // South Dakota begin button
    public PageReference southdakota() {
        
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=South Dakota');       
        page.setRedirect(true);
        return page;
     }
     
    // Kansas begin button
    public PageReference kansas() {
        
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=Kansas');       
        page.setRedirect(true);
        return page;
     }
     
     
    // Illinois begin button
    public PageReference illinois() {
        
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=Illinois');       
        page.setRedirect(true);
        return page;
     }
     
    // Colorado begin button
    public PageReference colorado() {
        
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=Colorado');       
        page.setRedirect(true);
        return page;
     }
     
    // Texas begin button
    public PageReference texas() {
               
        PageReference page = new pageReference('/survey/AccountNavigatePage1?Market=Texas');       
        page.setRedirect(true);
        return page;
     }
     
    public void donSpon2() {
        
        if (donSpon.First_National_Bank_Request__c == False) {
            donSpon.First_National_Bank_Request__c.addError('Please check the box above to acknowledge you have read and understand the statement below');

        }
      //DAG 08/03/2018 New code here to validate format of Tax ID field. (ADS0002680)
        TaxIDError = false;
        TaxidPrefix = donSpon.Tax_id__c.substringbefore('-');
        TaxidSuffix = donSpon.Tax_id__c.substringafter('-');
        if (TaxidPrefix.length() == 2 && TaxidSuffix.length() == 7) {
           if (TaxidPrefix.isNumeric() && TaxidSuffix.isNumeric()) {
              //Woohoo!  We passed!!
           } else {
              TaxIDError = true;
              donSpon.Tax_ID__c.addError('Tax ID must be in format 77-7777777 and all numeric');
           }
        } else {
           TaxIDError = true;
           donSpon.Tax_ID__c.addError('Tax ID must be in format 77-7777777 and all numeric');
        }
        //DAG 08/03/2018 end
        if (donSpon.First_National_Bank_Employee_on_Board__c == 'Yes' && donSpon.Provide_Name_and_Service_Description__c == null) {        
            donSpon.Provide_Name_and_Service_Description__c.addError('You must enter a value');

        } 
        if (donSpon.Organization_Have_Relationship__c == 'Yes' && donSpon.Please_Describe_Relationship__c == null) {
            donSpon.Please_Describe_Relationship__c.addError('You must enter a value');
        }
      //DAG 08/03/2018 added condition here for if TaxIDError = false (ADS0002680)
        if ((donSpon.First_National_Bank_Request__c == True) && (TaxIDError == false) &&
            ((donSpon.First_National_Bank_Employee_on_Board__c == 'Yes' && donSpon.Provide_Name_and_Service_Description__c != null) ||
            (donSpon.First_National_Bank_Employee_on_Board__c == 'No' && donSpon.Provide_Name_and_Service_Description__c != null) ||
            (donSpon.First_National_Bank_Employee_on_Board__c == 'No' && donSpon.Provide_Name_and_Service_Description__c == null) ||
            (donSpon.First_National_Bank_Employee_on_Board__c == 'Unknown' && donSpon.Provide_Name_and_Service_Description__c != null) ||
            (donSpon.First_National_Bank_Employee_on_Board__c == 'Unknown' && donSpon.Provide_Name_and_Service_Description__c == null)) &&
            ((donSpon.Organization_Have_Relationship__c == 'Yes' && donSpon.Please_Describe_Relationship__c != null) ||
            (donSpon.Organization_Have_Relationship__c == 'No' && donSpon.Please_Describe_Relationship__c != null) ||
            (donSpon.Organization_Have_Relationship__c == 'No' && donSpon.Please_Describe_Relationship__c == null))) {
            
                showFirstPage = false;
                showSecPage = true;
                showThirdPage = false; 
           
            
        } else {
            //We can show validation message here if above condition don't meet
            
        }    

    }
     
    public void donSpon3() {
          
        if (donSpon.Non_Profit_Status__c == 'Other' && donSpon.Non_Profit_Status_Other__c == null) {
            donSpon.Non_Profit_Status_Other__c.addError('You must enter a value');
        
        }
        if (donSpon.Individuals_Served_Low_Income__c == 'Yes' && donSpon.Evidence_of_Income_Status__c == null) {
            donSpon.Evidence_of_Income_Status__c.addError('You must enter a value');      
        }
        if (((donSpon.Non_Profit_Status__c == 'Other' && donSpon.Non_Profit_Status_Other__c != null) ||
            (donSpon.Non_Profit_Status__c == '501C(3)' && donSpon.Non_Profit_Status_Other__c == null) ||
            (donSpon.Non_Profit_Status__c == '501C(3)' && donSpon.Non_Profit_Status_Other__c != null) ||
            (donSpon.Non_Profit_Status__c == '501C(6)' && donSpon.Non_Profit_Status_Other__c == null) ||
            (donSpon.Non_Profit_Status__c == '501C(6)' && donSpon.Non_Profit_Status_Other__c != null)) &&
            ((donSpon.Individuals_Served_Low_Income__c == 'Yes' && donSpon.Evidence_of_Income_Status__c != null) ||
            (donSpon.Individuals_Served_Low_Income__c == 'No' && donSpon.Evidence_of_Income_Status__c == null) ||
            (donSpon.Individuals_Served_Low_Income__c == 'No' && donSpon.Evidence_of_Income_Status__c != null) ||
            (donSpon.Individuals_Served_Low_Income__c == 'Unknown' && donSpon.Evidence_of_Income_Status__c == null) ||
            (donSpon.Individuals_Served_Low_Income__c == 'Unknown' && donSpon.Evidence_of_Income_Status__c != null))) {
                
                    showFirstPage = false;
                    showSecPage = false;
                    showThirdPage = true;
                    AttachThisTime = false;
                    
            } else {
            //We can add validation message if above condition don't meet
            //return null;
        }
        
     }
     
    public PageReference donPrev() {
        PageReference page = new pageReference('/survey/donation_and_sponsorship_form_open');
        page.setRedirect(true);
        return page;        
    }

    public void attach(){
         //donSpon1=donSpon;
           count=0;
        for(Attachment a1:allFileList)
        {
           if(a1.body!=null && a1.name!='')
            {
                 count=1;   
            }
        }
                if(donSponId==null &&count>0)
                {
                        donSpon.id=null;
                        upsert donSpon;
          
                       donSponId=donSpon.id;
                 
                   }else if(count>0 &&donSponId!=null ){
            //system.debug('donSpon'+donSpon);
              // system.debug('donSpon1'+donSpon);
              //donSpon.id=null; 
               update donSpon;
                donSponId=donSpon.id;
        }
       
        
     List<Attachment> listToInsert = new List<Attachment>() ;
        if(donSpon.id!=null)
        {
            for(Attachment a: allFileList)
        {
            if(a.name != '' && a.name != '' && a.body != null)
                listToInsert.add(new Attachment(parentId = donSpon.id, name = a.name, body = a.body)) ;
        }
            
        }
        if(listToInsert.size() > 0)
        {
            insert listToInsert;
            listToInsert.clear();
           ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO,  + 'Thank you, your files were uploaded successfully.  Please click SUBMIT REQUEST to complete your application.'));
            //Attachmentids.addAll(listToInsert);
            FileCount = '' ;
            allFileList=new list<attachment>();
        }
       
    }
     
          public void delete25Attachments() {
          
             allFileList.clear();
             //filesCountList.clear(); 
             //filesCountList.add(new SelectOption('--None--','0')) ; 
             for(Integer i = 1 ; i < 11 ; i++)
             {
              
              filesCountList.add(new SelectOption(''+i , ''+i)) ;
             }
     
         if(donSpon.id!=null){
             system.debug('donSpon.id'+donSpon.id);
             list<FIC_Survey_Application__c>accs=[Select id from FIC_Survey_Application__c where id=:donSpon.id];
             
                 if(accs.size()>0){
                     
                delete accs;
               ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, + ' file(s) deleted successfully'));
                 
                 }
              
               donSponId=null;
         }
         
         filecount='0';
           ChangeCount();        
     }    

     public PageReference submit() {
         if(donSponId==null){
             system.debug('donSponId'+donSponId);
             donSpon.id=null;
             upsert  donSpon;
             donSponId=donSpon.id;
         }
     
                
        

     PageReference page = new pageReference('/survey/donation_and_sponsorship_form_exit?id='+ donsponId);
       page.setRedirect(true);
         //DAG 05/17/2017 Lets try this on for size. 
           //return null;
        return page;
         
     }
    
     public PageReference createpdf() {
     // Redirect
        PageReference page = new pageReference('/survey/donation_and_sponsorship_form_pdf?id='+ donSponId);
        page.setRedirect(true);
        return page;
        
     }
}