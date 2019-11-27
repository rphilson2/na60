public class GrantEmailtemplate {
    
    public Community_Giving__c   CMG{set;get;}
    public String templateDeveName  {get;set;}
    public String fromAddress  {get;set;}
    public String toAddress  {get;set;}
    public String emailBody  {get;set;}
    public boolean blockBool {get;set;}
    
public GrantEmailtemplate(Apexpages.standardcontroller controller)
{
        CMG=(Community_Giving__c)controller.getrecord();
         blockBool=true;
    Emailformate();
      
}
public void calculateexpiredate(){

     
    }
    public void Emailformate()
{
         CMG=calFicRecord();
         templateDeveName = findTemplate(CMG);
         toAddress = calToAddress(CMG);
         emailBody=createEmailStr();
         fromAddress = calFromAddress();
}
    
public string findTemplate(Community_Giving__c   comObjVal)
 {     
          String templateName = '';
          if(comObjVal != null) 
          {
             if(comObjVal.RecordType.DeveloperName == 'Community_Development_Grant'){
                if(comObjVal.Survey_Email_notification__c==true) {
                   if(comObjVal.Market__c=='Texas') {
                      templateName='Grant_Survey_Response_2nd_Notification_FNBSW';
                   } else if(comObjVal.Market__c=='South Dakota') {
                      templateName='Grant_Survey_Response_2nd_Notification_FNBSD';
                   } else if(comObjVal.Market__c=='North Platte') {
                      templateName='Grant_Survey_Response_2nd_Notification_FNBNP';
                   } else {templateName='Grant_Survey_Response_2nd_Notification_FNB';}
                } else {
                   if(comObjVal.Market__c=='Texas') {
                      templateName='Grant_Survey_Response_1st_Notification_FNBSW';
                   } else if(comObjVal.Market__c=='South Dakota') {
                      templateName='Grant_Survey_Response_1st_Notification_FNBSD';
                   } else if(comObjVal.Market__c=='North Platte') {
                      templateName='Grant_Survey_Response_1st_Notification_FNBNP';
                   } else {templateName='Grant_Survey_Response_1st_Notification_FNB';}
                }
             }
          
          }
        
   return templatename;
        
 }
    public string createEmailStr(){
        
         String emailStr = '';
        List<EmailTemplate> templateList = new List<EmailTemplate>();
        if(templateDeveName != null && templateDeveName != '') {
            templateList = [SELECT Id,HTMLValue,Name,developername FROM EmailTemplate WHERE developername =: templateDeveName];
        }
        
        
        if(templateList.size()>0) {
            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateList[0].id,Null, CMG.id);
            emailStr = mail.getHTMLBody();
        }
        system.debug('emailStr&&&'+emailStr);
        return emailStr;        
      
    }
    
    
    public string calToAddress(Community_Giving__c CMGto){
        String toStr = '';
        if(CMGto != null && CMGto.Grant_Contact_Email__c != null){
            toStr = CMGto.Grant_Contact_Email__c;
        }
                 system.debug('toStr'+toStr);    
        return toStr;
        
    }
private String calFromAddress() 
{
        String fromStr = '';
        
       
            fromStr = 'firstinthecommunity@fnni.com';
      
        system.debug('fromStr'+fromStr);
        return fromStr;
}
    
    
   public Community_Giving__c calFicRecord() 
{
    
   Community_Giving__c returncommunity=new Community_Giving__c();
     if(CMG != null && CMG.id !=null) 
     {
          CMG=[select id,RecordType.DeveloperName,Survey_Email_notification__c,Grant_Contact_Name__c,Grant_Contact_Email__c,Market__c, Awarded_Date__c from Community_Giving__c where id=:CMG.id];
         returncommunity=CMG;
     }
     return returncommunity;  
}
    public Pagereference sendEmail() {
        if (CMG.Awarded_Date__c==null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Error, 'Date Awarded needs to be filled in.  Go back and fill that in, then try again.'));
      } else {
         try {
            OrgWideEmailAddress orgWideAdd = [Select id from OrgWideEmailAddress Where DisplayName =: 'First in the Community'];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            PageReference Respform = new pageReference('/grantsurveyresponse?id='+CMG.id);
            string Respheader = Respform.getHeaders().get('Host');
            string Respurl=Respform.geturl();
            string Resppagename='https://'+ Respheader + Respurl;
            String[] toAddresses = new String[]{toAddress};
            mail.setToAddresses(toAddresses);
            mail.setInReplyTo(fromAddress);
            mail.setSubject('Grant Progress Report');
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
            //mail.setSenderDisplayName(fromName);
             //mail.setFileAttachments(Sendattach);
            mail.setOrgWideEmailAddressId(orgWideAdd.id);
           
            mail.setHtmlBody(emailBody);
            //mail.setWhatId(comObj.id); 
            //mail.setTemplateId(tempID.Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
             blockBool = False;
            insertSurveyEmailRecord();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Confirm, 'Email Sent Successfully.'));
         }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Error, ex.getMessage()));
         }
      }
         return null; 
    }
    private void insertSurveyEmailRecord() {
        try {
            Progress_Report_Forms__c ficSurObj = new Progress_Report_Forms__c();
            ficSurObj.Name = templateDeveName;
            ficSurObj.Community_Investment__c=CMG.id;
            ficSurObj.Date_sent__c = System.Today();
            ficSurObj.Email_Body__c  = emailBody;
            ficSurObj.From_Email__c  = fromAddress;
            ficSurObj.To_Email__c = toAddress;
            insert ficSurObj;
          Community_Giving__c  CG=new  Community_Giving__c ();
            CG.id=CMG.id;
            CG.Survey_Email_notification__c=true;
            update CG;
            System.debug('Community%%%%'+CG);
            
        }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Error, ex.getMessage()));
        }
    }
    
}