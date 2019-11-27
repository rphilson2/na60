//Author: Dallas Grafton
// Date Created/Modified: 03.21.2019
// Project: First In the Community (FIC) Flood Relief request survey form
// Purpose: 
//

public class flooddonationrequest_Controller {
  
    @TestVisible private final FIC_Survey_Application__c flood;
    public List<SelectOption> filesCountList {get; set;}
    private Id floodId;
    Private  integer count;
   private list<Attachment>Attachmentids;
    public boolean showFirstPage{get;set;}
    public boolean showSecPage{get;set;}
    public boolean showThirdPage{get;set;}
    public boolean AttachThisTime{get;set;}
    public List<Attachment> allFileList {get; set;}
    public String FileCount {get; set;}
    public string TaxidPrefix {get; set;}
    public string TaxidSuffix {get; set;}
  //public boolean TaxIDError {get; set;}
    public string annual_audit {get; set;}
    public boolean annualaudit {get; set;}
    
    public flooddonationrequest_Controller (ApexPages.StandardController stdController) {
      //set for first page-- floodRelief_MainApplication
        showFirstPage = true;
        showSecPage = false;
        showThirdPage = false; 
          FileCount = '' ;
        count=0;
       filesCountList = new List<SelectOption>() ;
        Attachmentids=new list<Attachment>();
        allFileList = new List<Attachment>() ;
        for(Integer i = 1 ; i < 11 ; i++){
            filesCountList.add(new SelectOption(''+i , ''+i)) ;
        }
        flood = (FIC_Survey_Application__c)stdController.getRecord();
        system.debug('flood'+flood);

       floodId = stdController.getRecord().Id;

        flood.Market__c= ApexPages.currentPage().getParameters().get('Market');
       
        // Get Flood Relief record type
        flood.recordTypeId = [SELECT Id
                                FROM RecordType
                                WHERE sObjectType = 'FIC_Survey_Application__c'
                                AND Name = 'Flood Relief'
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

    // Main Application begin button
    public PageReference beginApplication() {
        flood.Market__c = 'Omaha';
        system.debug('Got Here beginApplication.  Market: ' + flood.market__c);
        PageReference page = new pageReference('/floodrelief/FloodRelief_MainApplication?Market='+flood.market__c);
        page.setRedirect(true);
        return page;
     }
     
    public void flood2() {
       boolean checkBoxError = false;
       boolean firstPageError = false;
       if (flood.First_National_Bank_Request__c != True) {
          checkBoxError = true;
          firstPageError = true;
       }
       boolean taxIDError = false;
       TaxidPrefix = flood.Tax_id__c.substringbefore('-');
       TaxidSuffix = flood.Tax_id__c.substringafter('-');
       if (TaxidPrefix.length() == 2 && TaxidSuffix.length() == 7) {
          if (TaxidPrefix.isNumeric() && TaxidSuffix.isNumeric()) {
             taxIDError = false;
          } else {
             taxIDError = true;
             firstPageError = true;
          }
       } else {
          TaxIDError = true;
          firstPageError = true;
       }
       boolean endDateError = false;
       if (flood.Flood_Anticipated_End_Date__c < flood.Program_Event_Date__c) {
          endDateError = true;
          firstPageError = true;
       }
       if (firstPageError == true) {
          if (checkBoxError == true) {
             flood.First_National_Bank_Request__c.addError('Please check the box above to acknowledge you have read and understand the statement below');           
          }
          if (taxIDError == true) {
             flood.Tax_ID__c.addError('Tax ID must be in format 77-7777777 and all numeric');
          }
          if (endDateError == true) {
             flood.Flood_Anticipated_End_Date__c.addError('Project Completion Date must be on or later than the Start date.');
          }


       } else {

          showFirstPage = false;
          showSecPage = true;
          showThirdPage = false; 
       }

    }
     
    public void flood3() {
        boolean secondPageError = false;
        boolean nonProfitStatusError = false;
        boolean auditError = false;
        if (flood.Non_Profit_Status__c == 'Other' && flood.Non_Profit_Status_Other__c == null) {
            nonProfitStatusError = true;
            secondPageError = true;
        }
        system.debug('Got Here flood3. NP Status: '+ flood.Non_Profit_Status__c + '  Status Other: ' + flood.Non_Profit_Status_Other__c);
        if  ((flood.Non_Profit_Status__c == 'Other' && flood.Non_Profit_Status_Other__c != null) ||
            (flood.Non_Profit_Status__c == '501C(3)' && flood.Non_Profit_Status_Other__c == null) ||
            (flood.Non_Profit_Status__c == '501C(3)' && flood.Non_Profit_Status_Other__c != null) ||
            (flood.Non_Profit_Status__c == '501C(6)' && flood.Non_Profit_Status_Other__c == null) ||
            (flood.Non_Profit_Status__c == '501C(6)' && flood.Non_Profit_Status_Other__c != null)) {
                
            nonProfitStatusError = false;

                    
        } else {
            nonProfitStatusError = true;
            secondPageError = true;

        }

        switch on annual_audit {
           when 'true' {
              flood.Annual_Independent_Audit__c = true;
           }
           when 'false' {
              flood.Annual_Independent_Audit__c = false;
           }
           when else {
              auditError = true;
              secondPageError = true;
           }
        }
        if (secondPageError == true) {
           if (nonProfitStatusError == true) {
              flood.Non_Profit_Status_Other__c.addError('You must enter a value');
           }
           if (auditError == true) {
              ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, + 'Please choose a value for annual audit'));
           }
        } else {
           showFirstPage = false;
           showSecPage = false;
           showThirdPage = true;
           AttachThisTime = false;
        }
        
    }

    public void attach(){
       //flood1=flood;

        count=0;
        for(Attachment a1:allFileList)
        {
           system.debug('Got Here Attach' + a1.Name);

           if(a1.body!=null && a1.name!='')
            {
                 count=1;   
            }
        }
        if (floodId==null &&count>0) {
           flood.id=null;
           flood.Market__c = 'Omaha';  //DAG Since we are not choosing market, set this to default Omaha since it must have a value. 
           insert flood;
           floodId=flood.id;
                 
        } else if(count>0 &&floodId!=null ) {
                   
           update flood;
           floodId=flood.id;
        }
               
        List<Attachment> listToInsert = new List<Attachment>() ;
        if(flood.id!=null)
        {
            for(Attachment a: allFileList)
        {
            if(a.name != '' && a.name != '' && a.body != null) {
                system.debug('Got Here going to add to list to insert.  Name: ' + a.Name + ' Parentid: ' + flood.id);
                listToInsert.add(new Attachment(parentId = flood.id, name = a.name, body = a.body)) ;
                system.debug('Got Here Added to list.  Name: ' + a.Name + ' Parentid: ' + flood.id + ' List Size: ' + listToInsert.size());
            }
        }
            
        }
        if(listToInsert.size() > 0)
        {
            system.debug('Got Here going insert attachments.  Size: ' + listToInsert.size());
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
        for(Integer i = 1 ; i < 11 ; i++)
        {              
           filesCountList.add(new SelectOption(''+i , ''+i)) ;
        }
        
        if (flood.id!=null) {
           system.debug('Got Here flood.id'+flood.id);
           list<FIC_Survey_Application__c>accs=[Select id from FIC_Survey_Application__c where id=:flood.id];
            
           if(accs.size()>0){                     
              delete accs;
              ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, + ' file(s) deleted successfully'));
           }
           floodId=null;
         }
         
         filecount='0';
         ChangeCount();        
     }    

     public PageReference submit() {
        //floodId == null means that the person is hitting submit and has not attached any files.
       //if(floodId==null){
             system.debug('Got Here submit application.  Annual audit = ' + annual_audit);
             flood.id=null;
             flood.Market__c = 'Omaha';  //DAG Since we are not choosing market, set this to default Omaha since it must have a value. 
             flood.submitted__c = true;
             if (floodid == null) {
                insert flood;
                floodId = flood.id;
             } else {
                flood.Id=floodId;
                update flood;
             }
       //}

         PageReference page = new pageReference('/floodrelief/Flood_Relief_form_exit?id='+ floodId);
         page.setRedirect(true);
         return page;
     }
    
     public PageReference createpdf() {
     // Redirect
        PageReference page = new pageReference('/floodrelief/Flood_Relief_form_pdf?id='+ floodId);
        page.setRedirect(true);
        return page;
        
     }
}