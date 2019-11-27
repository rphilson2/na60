public  class AtoDecisionTemplateCtrl {
    
    //public Id ficID {get;set;}
    public Community_Giving__c comObj {get;set;}
    //public Community_Giving__c ficObj;
    public Boolean blockBool {get;set;}
    
    private Contact conObjMarket {get; set;}
 
    public String templateDeveName  {get;set;}
    public String fromAddress  {get;set;}
    public String toAddress  {get;set;}
    public string Emailsubject {get;set;}
    public String emailBody  {get;set;}
   // Public id Communityinvestmentid;
    public list<selectoption>countlist{set;get;}
    Public  list<Attachment>attach{set;get;}
    public list<string>Attnames{set;get;}
    public list<id>attachesid{set;get;}
    public string filecount{set;get;}
   // private list<attachment> myattach;
 // public  list<Messaging.Emailfileattachment>Attaches;
    public AtoDecisionTemplateCtrl(ApexPages.StandardController std) {
        comObj = (Community_Giving__c)std.getRecord();
//Communityinvestmentid=apexpages.currentpage().getparameters().get('id');
        conObjMarket = new Contact();
        blockBool = False;
        countlist=new list<selectoption>();
         attach=new list<attachment>();
        Attnames=new list<string>();
        attachesid=new list<id>();
        //Attaches=new list<Messaging.Emailfileattachment>();
        //myattach=new list<Attachment>();
        filecount='';
        for(integer i=1; i<3; i++){
            countlist.add(new selectoption(''+i,''+i));
        }
        dispatcher();
    }
    public  pagereference addattachment(){
        attach.clear();
       // Attaches.clear();
        for(integer i=1;i<=integer.valueof(filecount);i++){
            attach.add(new attachment());
           
        }
         return null;
        
    }   
    public void Uploaddoc(){
       //if(comObj.id==null ||comObj.id==''){
   //ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'No record is associated. Please pass record Id in parameter.'));

       //}
             attachesid.clear();
        list<attachment>listtoinsert=new list<attachment>();
        for(Attachment a:attach){
            if(a.name!='' && a.body!=null){
                listtoinsert.add(new attachment(parentid=comObj.id,name=a.name,body=a.body));
            /*Messaging.Emailfileattachment a1=new Messaging.Emailfileattachment();
                a1.setfilename(a.name);
                a1.setbody(a1.body);
                attaches.add(a1);*/
            }
        }
        if(listtoinsert.size()>0){
            insert listtoinsert;
          ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, listToInsert.size() + ' file(s) are uploaded successfully'));
            for(Attachment a:listtoinsert){
                Attnames.add(a.name);
                attachesid.add(a.parentid);
            }

         //Attnames=new list<string>(listtoinsert[0].name);
            //attachesid=new list<id>(listtoinsert[0].id);
           // system.debug('myattach'+myattach);

            filecount='';
          attach=new list<attachment>(); 
          
        }
         
    }
        
    private void dispatcher() {
        List<Contact> fcMarketList = new List<Contact>();
        comObj = calFicRecord();
        templateDeveName = findTemplate(comObj);
        System.debug('templateDeveName'+templateDeveName);
        List<Community_Survey__c> ficSurveyList = [Select id from Community_Survey__c Where Name=:templateDeveName AND Community_Investment__c=:comObj.id LIMIT 1];
       
        if(ficSurveyList.size()>0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Email has already been sent.'));
        }else {
            if(comObj.Market__c != null)
                fcMarketList = [Select id,Name,CRA_Contact_Title__c,CRA_Logo__c,Email from Contact Where CRA_Market_Name__c =: comObj.Market__c Limit 1];
             system.debug('%%%%Fcmarklist%%%%%%%'+fcMarketList.size());
            if(fcMarketList.size()>0)
               
                conObjMarket = fcMarketList[0];
            
            emailBody = createEmailStr();
            toAddress = calToAddress(comObj);
          //fromAddress = calFromAddress(comObj.Market__c);
            fromAddress = 'firstinthecommunity@fnni.com';
            blockBool = True;
        }
    }
    
    
    private String calFromAddress(String marketType) {
        String fromStr = '';
        if(conObjMarket != null && conObjMarket.Email != null) {
            fromStr = conObjMarket.Email;
        }else {
            fromStr = 'firstinthecommunity@fnni.com';
        }
        system.debug('fromStr'+fromStr);
        return fromStr;
    }
    
    private String calToAddress(Community_Giving__c ficObjVal) {
        String toStr = '';
        if(ficObjVal != null && ficObjVal.Grant_Contact_Email__c != null)
            toStr = ficobjVal.Grant_Contact_Email__c;
            if(ficObjVal != null && ficObjVal.requestor_Email__c != null)
            toStr = ficObjVal.requestor_Email__c;
                 system.debug('toStr'+toStr);    
        return toStr;
    }
    
    
    public Community_Giving__c calFicRecord() {
        Community_Giving__c ficObjToReturn = new Community_Giving__c();
        if(comObj != null && comObj.id != null) {
            comObj = [Select id,  FIC_Survey_Application__c,Grant_Contact_Email__c,Non_Profit_Organization__c ,Status_Picklist__c,Market__c,
            Total_Approved_Amount__c,Reviewed_by_MCIC_Decision__c,Reviewed_outside_of_MCIC_Decision__c,Reviewed_by_FIC_Disposition__c, requestor_Email__c, requestor_Name__c,
            RecordType.DeveloperName from Community_Giving__c Where id = :comObj.id];
           ficObjToReturn=comObj;
        }
        
        system.debug('ficObjToReturn'+ficObjToReturn);
        return ficObjToReturn;
    }
    
    public Pagereference sendEmail() {
      
            OrgWideEmailAddress orgWideAdd = [Select id from OrgWideEmailAddress Where address = 'firstinthecommunity@fnni.com'];
             list<Messaging.Emailfileattachment>Sendattach=new  list<Messaging.Emailfileattachment>();
          
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          // Attaches=new list<Messaging.Emailfileattachment>();
           /* if(attaches.size()>0){
                mail.setFileAttachments(Attaches);
            }*/
            mail.setOrgWideEmailAddressId(orgWideAdd.Id);
            if(attachesid.size()>0){
               list<attachment>attach=[select id,name,body,parentid from attachment where parentid in:attachesid]; 
                for(Attachment a:attach){
                   Messaging.Emailfileattachment ME=new Messaging.Emailfileattachment();
                    ME.setfilename(a.name);
                    ME.setbody(a.body);
                    Sendattach.add(ME);
                }
            }
            String[] toAddresses = new String[]{toAddress};
            mail.setToAddresses(toAddresses);
          //mail.setInReplyTo(fromAddress);
          //mail.setReplyTo(fromAddress);
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
          //mail.setSenderDisplayName(fromName);
          //mail.setSenderDisplayName('First in the Community');
             mail.setFileAttachments(Sendattach);
            //mail.setOrgWideEmailAddressId(orgWideAdd.id);
           
            mail.setHtmlBody(emailBody);
            mail.setSubject(EmailSubject);
            //mail.setWhatId(comObj.id); 
            //mail.setTemplateId(tempID.Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            blockBool = False;
            insertSurveyEmailRecord();
            //system.debug()
           ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Confirm, 'Email Sent Successfully.'));
        
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Error, ex.getMessage()));
           // system.debug(ex.getMessage());
      
        return null;
    }
    
    private void insertSurveyEmailRecord() {
        try {
            Community_Survey__c ficSurObj = new Community_Survey__c();
            ficSurObj.Name = templateDeveName;
            ficSurObj.Community_Investment__c = comObj.id;
            ficSurObj.Date_sent__c = System.Today();
            ficSurObj.Email_Body__c  = emailBody;
            ficSurObj.From_Email__c  = fromAddress;
            ficSurObj.To_Email__c = toAddress;
            insert ficSurObj;
            system.debug('ficSurObj'+ficSurObj);
        }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Error, ex.getMessage()));
        }
    }
    
    public String createEmailStr() {
        String emailStr = '';
        List<EmailTemplate> templateList = new List<EmailTemplate>();
        if(templateDeveName != null && templateDeveName != '') {
            templateList = [SELECT Id,HTMLValue,Name,subject,developername FROM EmailTemplate WHERE developername =: templateDeveName];
        }
        
        if(templateList.size()>0) {
            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateList[0].id, conObjMarket.id, comObj.id);
            EmailSubject = templateList[0].subject;
            emailStr = mail.getHTMLBody();
        }
        system.debug('emailStr&&&'+emailStr);
        return emailStr;
    }
     @Testvisible  private String findTemplate( Community_Giving__c comObjVal ) {
        String templateName = '';
        if(comObjVal != null) {
           if( comObjVal.RecordType.DeveloperName == 'Community_Development_Grant' ){
              if(comObjVal.Status_Picklist__c == 'Market Decline' || comObjVal.Status_Picklist__c == 'Declined') {
                  if(comObj.Market__c == 'South Dakota') {
                      templatename = 'Grant_Decline_Template_SD';
                  } else if(comObj.Market__c == 'North Platte') {
                       templatename = 'Grant_Decline_Template_NP';
                      } else if(comObj.Market__c == 'Texas') {
                           templatename = 'Grant_Decline_Template_SW';
                          } else {
                              templatename = 'Grant_Decline_template_FNB';
                          }
              } else if(comObjVal.Status_Picklist__c == 'Market Approve' || comObjVal.Status_Picklist__c == 'Approve') {
                   if(comObj.Market__c == 'South Dakota') {
                       templatename = 'Grant_Award_Template_SD';
                   } else if(comObj.Market__c == 'North Platte') {
                        templatename = 'Grant_Award_Template_NP';
                       } else if(comObj.Market__c == 'Texas') {
                            templatename = 'Grant_Award_Template_SW';
                           } else {
                               templatename = 'Grant_Award_template_FNB';
                           }
                       }
           }else if( comObjVal.RecordType.DeveloperName == 'Donation') {
              if((comObjVal.Reviewed_by_MCIC_Decision__c == 'Approved' ) ||
                (comObjVal.Reviewed_outside_of_MCIC_Decision__c == 'Approved' ) || 
                (comObjVal.Reviewed_by_FIC_Disposition__c == 'Approved')) {
                   if(comObj.Market__c == 'South Dakota') {
                       templatename = 'Donation_Approve_Template_SD';
                   } else if(comObj.Market__c == 'North Platte') {
                        templatename = 'Donation_Approve_Template_NP';
                       } else if(comObj.Market__c == 'Texas') {
                            templatename = 'Donation_Approve_Template_SW';
                           } else {
                               templatename = 'Donation_Approve_template_FNB';
                           }
              }else if((comObjVal.Reviewed_by_MCIC_Decision__c == 'Denied' ) ||
                (comObjVal.Reviewed_outside_of_MCIC_Decision__c == 'Denied' ) || 
                (comObjVal.Reviewed_by_FIC_Disposition__c == 'Denied')) {
                   if(comObj.Market__c == 'South Dakota') {
                       templatename = 'Donation_Decline_Template_SD';
                   } else if(comObj.Market__c == 'North Platte') {
                        templatename = 'Donation_Decline_Template_NP';
                       } else if(comObj.Market__c == 'Texas') {
                            templatename = 'Donation_Decline_Template_SW';
                           } else {
                               templatename = 'Donation_Decline_template_FNB';
                           }
              }
           }else if( comObjVal.RecordType.DeveloperName == 'Sponsorship'){
              if((comObjVal.Reviewed_by_MCIC_Decision__c == 'Approved' ) ||
                (comObjVal.Reviewed_outside_of_MCIC_Decision__c == 'Approved' ) || 
                (comObjVal.Reviewed_by_FIC_Disposition__c == 'Approved')) {
                   if(comObj.Market__c == 'South Dakota') {
                       templatename = 'Sponsorship_Approve_Template_SD';
                   } else if(comObj.Market__c == 'North Platte') {
                        templatename = 'Sponsorship_Approve_Template_NP';
                       } else if(comObj.Market__c == 'Texas') {
                            templatename = 'Sponsorship_Approve_Template_SW';
                           } else {
                               templatename = 'Sponsorship_Approve_template_FNB';
                           }
              }else if((comObjVal.Reviewed_by_MCIC_Decision__c == 'Denied' ) ||
                (comObjVal.Reviewed_outside_of_MCIC_Decision__c == 'Denied' ) || 
                (comObjVal.Reviewed_by_FIC_Disposition__c == 'Denied')) {
                   if(comObj.Market__c == 'South Dakota') {
                       templatename = 'Sponsorship_Decline_Template_SD';
                   } else if(comObj.Market__c == 'North Platte') {
                        templatename = 'Sponsorship_Decline_Template_NP';
                       } else if(comObj.Market__c == 'Texas') {
                            templatename = 'Sponsorship_Decline_Template_SW';
                           } else {
                               templatename = 'Sponsorship_Decline_template_FNB';
                           }
              }
           }    
        }
         system.debug('templateName&&&'+templateName);
        return templateName;
        }
        }