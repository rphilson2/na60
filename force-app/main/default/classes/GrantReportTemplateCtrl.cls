public class GrantReportTemplateCtrl {
   
    private List<Community_Giving__c> grantrptheader = null;
    private List<Contact> get_cra_website = null;  
    public list<attachment> listofattach{set;get;}
    public list<attachment> listofattach1{set;get;}
    public Community_Giving__c CMG{set;get;}    
    public boolean stronglocal{set;get;}
    public Boolean EducatedWorkforce{set;get;}
    public Boolean Stabilization{set;get;}
    public Boolean Anyofthem{set;get;}
    public Boolean IsInputError{set;get;}
    public Boolean Attached{set;get;}
    public Boolean Attached1{set;get;}
    public Boolean ShowMain{set;get;}
    public Boolean ShowSec{set;get;} 
    public string  PrioColor{set;get;}
    public string  twolofc1{set;get;}
    public string  organization_name{set;get;}
    public Date    Date_awarded{set;get;}
    public string  Date_awarded_formatted{set;get;}
    public String  Name_of_program{set;get;}
    public string  brief_program_description{set;get;}
    public string  purpose{set;get;}
    public string  promised_outcomes{set;get;}
    public string  id{set;get;}
    public string  thisid{set;get;}
    public string  market{set;get;}
    public string  cra_website{set;get;}
    public string  attach_name{set;get;}
    public string  attach1_name{set;get;}      
    public integer numattach=0;
    public decimal housing_units_created_built{set;get;}
    public decimal Homeownership_Educ_Sessions{set;get;}
    public decimal Individuals_Rec_Homeownership_Educ{set;get;}
    public decimal Number_of_Housing_Units_Rehab_Renov{set;get;}
    public decimal Housing_Units_Financed{set;get;}
    public decimal Individuals_Served_in_Prop_Program{set;get;}
    public decimal Adults_Provided_Education{set;get;}
    public decimal Adults_Provided_Vocational_Training{set;get;}
    public decimal Youth_Provided_Work_Career_Educ{set;get;}
    public decimal Youth_Provided_Voc_Train_Work_Dev{set;get;}
    public decimal Small_Businesses_Assisted{set;get;}
    public decimal Workshops_Training_Events_Provided{set;get;}
    public decimal Jobs_Created_Full_Time{set;get;}
    public decimal Jobs_Retained{set;get;}
    public decimal New_Businesses_Served{set;get;}
    public decimal Indiv_Coaching_Sessions_w_Small_Bus{set;get;}
    public decimal Jobs_Created_Part_Time{set;get;}
    public integer Housing_Units_Created_Built_AI{set;get;}
    public integer Individuals_Rec_Homeownership_Educ_AI{set;get;}
    public integer Housing_Units_Rehabilitated_Renovated_AI{set;get;}
    public integer Homeownership_Educ_Sessions_AI{set;get;}
    public integer Housing_Units_Financed_AI{set;get;}
    public integer Individuals_Served_in_Prop_Program_AI{get;set;}
    public integer Adults_Provided_Education_AI{get;set;}
    public integer Youth_Provided_Work_Career_Educ_AI{get;set;}
    public integer Adults_Provided_Vocational_Training_AI{get;set;}
    public integer Youth_Provided_Voc_Train_Work_Dev_AI{get;set;}
    public integer Small_Businesses_Assisted_AI{get;set;}
    public integer New_Businesses_Served_AI{get;set;}
    public integer Workshops_Training_Events_Provided_AI{get;set;}
    public integer Indiv_Coaching_Sessions_w_Small_Bus_AI{get;set;}
    public integer Jobs_Created_Full_Time_AI{get;set;}
    public integer Jobs_Created_Part_Time_AI{get;set;}    
    public integer index=0;
   
    private TestAttachment__c TA;
    public  Attachment attachment {
      get {
         if (attachment == null)
           attachment = new Attachment();
      return attachment;
      }
      set;
    }
    
    public  Attachment attachment1 {
      get {
         if (attachment1 == null)
           attachment1 = new Attachment();
      return attachment1;
      }
      set;
    }
    
    public GrantReportTemplateCtrl(Apexpages.standardcontroller controller){
        CMG=(Community_Giving__c)controller.getrecord();
        stronglocal=false;
        EducatedWorkforce=false;
        Stabilization=false;
        Anyofthem=false;
        ShowMain=true;
        ShowSec=false;
        TA=new TestAttachment__c(name='test');  //Initialize new test attachment.  Used in Upload and Upload1 procedures.
        String thisid = id!=null?id:ApexPages.currentPage().getParameters().get('id');  //Get id param from URL
        //List grantrptheader.  Pulling all of the data already on the Community investment record (What they filled out on the Grant application). Putting it all in its own variables.
        //Easiest way to make it work for access by the page.
        grantrptheader = [SELECT id, name, Non_Profit_Organization__r.name, Request_Title__c, Awarded_Date__c, purpose__c, Market__c, brief_program_description__c, Outcomes_directly_attributed_to_grant__c,
        Housing_Units_Created_Built__c, Homeownership_Educ_Sessions__c, Individuals_Rec_Homeownership_Educ__c,  Number_of_Housing_Units_Rehab_Renov__c, Housing_Units_Financed__c, X2_c__c,
        Individuals_Served_in_Prop_Program__c, Adults_Provided_Education__c, Adults_Provided_Vocational_Training__c, Youth_Provided_Work_Career_Educ__c, Youth_Provided_Voc_Train_Work_Dev__c,
        Small_Businesses_Assisted__c, Workshops_Training_Events_Provided__c, Jobs_Created_Full_Time__c, Jobs_Retained__c, New_Businesses_Served__c, Indiv_Coaching_Sessions_w_Small_Bus__c, 
        Jobs_Created_Part_Time__c FROM Community_giving__c WHERE id =:thisid limit 1 ];
        organization_name = grantrptheader[0].Non_Profit_Organization__r.name;
        Market=grantrptheader[0].Market__c;
        if (grantrptheader[0].Awarded_date__c != null) {
           Date_awarded = grantrptheader[0].Awarded_date__c;
           Date_awarded_formatted=date_awarded.format();
        } else {
           Date_awarded = null;
        }
        purpose = grantrptheader[0].purpose__c;
        promised_outcomes = grantrptheader[0].Outcomes_directly_attributed_to_grant__c;
        Name_of_Program = grantrptheader[0].request_title__c;
        brief_program_description = grantrptheader[0].brief_program_description__c;
        housing_units_created_built = grantrptheader[0].housing_units_created_built__c;
        Homeownership_Educ_Sessions = grantrptheader[0].Homeownership_Educ_Sessions__c;
        Individuals_Rec_Homeownership_Educ = grantrptheader[0].Individuals_Rec_Homeownership_Educ__c;
        Number_of_Housing_Units_Rehab_Renov = grantrptheader[0].Number_of_Housing_Units_Rehab_Renov__c;
        Individuals_Served_in_Prop_Program = grantrptheader[0].Individuals_Served_in_Prop_Program__c;
        Adults_Provided_Education = grantrptheader[0].Adults_Provided_Education__c;
        Adults_Provided_Vocational_Training = grantrptheader[0].Adults_Provided_Vocational_Training__c;
        Youth_Provided_Work_Career_Educ = grantrptheader[0].Youth_Provided_Work_Career_Educ__c;
        Youth_Provided_Voc_Train_Work_Dev = grantrptheader[0].Youth_Provided_Voc_Train_Work_Dev__c;
        Housing_Units_Financed = grantrptheader[0].Housing_Units_Financed__c;
        twolofc1 = grantrptheader[0].X2_c__c;
        Small_Businesses_Assisted = grantrptheader[0].Small_Businesses_Assisted__c;
        Workshops_Training_Events_Provided = grantrptheader[0].Workshops_Training_Events_Provided__c;
        Jobs_Created_Full_Time = grantrptheader[0].Jobs_Created_Full_Time__c;
        Jobs_Retained = grantrptheader[0].Jobs_Retained__c;
        New_Businesses_Served = grantrptheader[0].New_Businesses_Served__c;
        Indiv_Coaching_Sessions_w_Small_Bus = grantrptheader[0].Indiv_Coaching_Sessions_w_Small_Bus__c;
        Jobs_Created_Part_Time = grantrptheader[0].Jobs_Created_Part_Time__c;
        
        if(grantrptheader[0].purpose__c=='Strong Local Economies'){
            Anyofthem=true;
            stronglocal=true;
            EducatedWorkforce=false;
            Stabilization=false;
        } else if(grantrptheader[0].purpose__c=='Educated Workforce'){
            Anyofthem=true;
            EducatedWorkforce=true;
            stronglocal=false;
            Stabilization=false;
      //DAG_2018_12_26 Changing this else clause to use the Contains function, since the verbiage on this grant purpose was changed to combine stable housing and Neighborhood Revitalization.
      //} else if((grantrptheader[0].purpose__c=='Stable housing') || (grantrptheader[0].purpose__c=='Neighborhood Revitalization') || (grantrptheader[0].purpose__c=='Vibrant Neighborhoods')){
        } else if((grantrptheader[0].purpose__c.Contains('Stable')) || (grantrptheader[0].purpose__c.Contains('hood')) || (grantrptheader[0].purpose__c.contains('vital'))){
            Anyofthem=true;
            EducatedWorkforce=false;
            stronglocal=false;
            Stabilization=true;
        }
        if(Anyofthem==false){
           PrioColor='#5A0FDB';
        } else {
           PrioColor='Black';
        }
        //DAG 11/5/2018 Bug fix.  Add where recordtype.name = 'CRA Contacts' and also an if conditional for if list size = 0
        get_cra_website = [SELECT CRA_Website__c from Contact where recordtype.name = 'CRA Contacts' and CRA_Market_Name__c = :grantrptheader[0].Market__c limit 1];
        if(get_cra_website.size()==0) {
           cra_website = 'https://www.fnbo.com/community';
        } else {
           if(get_cra_website[0].cra_Website__c==null) {
              cra_website = 'https://www.fnbo.com/community';
           } else {
              cra_website = 'http://'+get_cra_website[0].cra_Website__c;
           }
        }        
      //organization_name = grantrptheader[1].Non_Profit_Organization__r.name;
      //Date_awarded = grantrptheader[1].Awarded_date__c;
        
    }
    
    public pagereference  upload() {
        upsert TA;
        Attached=false;
        system.debug('TA&&&&'+TA);
        if(TA.id!=null){
           TestAttachment__c TS=[select id,name from TestAttachment__c where id=:TA.id];
        
           system.debug('TA'+TA);
           if(TS.id!=null ){
              attachment.ParentId =Ts.id; // the record the file is attached to
           }
       }
       attachment.IsPrivate = true;

       try {
         insert attachment;
     // system.debug('attachment'+Attachment);
       } catch (DMLException e) {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
         return null;
       } finally {
      //attachment.body=null;
       attachment = new Attachment(); 
       }
       listofattach = [SELECT id, name from attachment where ParentID = :TA.id];
       attach_name = listofattach[0].name;
       Attached=true;     
     //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully: '+attach_name));
       return null;
    }
     

    public pagereference upload1(){
      Attached1=false;
      if(TA.id!=null){
        TestAttachment__c QueryTestAtt=[select id,name from TestAttachment__c where id=:TA.id];
      //system.debug('QueryTestAtt'+QueryTestAtt);
        if(QueryTestAtt.id!=null){
         // system.debug('QueryTestAtt.id'+QueryTestAtt.id);
          attachment1.ParentId =QueryTestAtt.id; // the record the file is attached to
        }
      }
      attachment1.IsPrivate = true;

    try {
      insert attachment1;
        
    //system.debug('attachment1'+attachment1);
    } catch (DMLException e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
      //system.debug('attachment1e'+e.getmessage());
        return null;
    } finally {
      
      attachment1 = new Attachment(); 
    }
    listofattach1 = [SELECT id, name from attachment where ParentID = :TA.id and name <> :attach_name];
    attach1_name = listofattach1[0].name;
    Attached1=true;
  //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Additional file uploaded successfully'+attach1_name));
    return null;
  }
     
    public pagereference Savecommunityinvestment(){
       IsInputError=false;
       if(CMG.full_name_and_date__c == null || CMG.Signed_Date__c == null) {
          IsInputError=true;
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Full name and Date must be filled in.'));    
       }
       list<string>toaddresses=new list<string>();
     //DAG 11/08/2018 Remove reference to Org Wide email addresses.
     //OrgWideEmailAddress orgWideAdd = [Select id,Address from OrgWideEmailAddress Where DisplayName =:'First in the Community'];
     //toaddresses.add('jurban@fnni.com');
       toaddresses.add('communitydevelopment@fnni.com');
       if(CMG.id!=Null){
          if(IsInputError==false) {
             if(twolofc1!=''){
               CMG.X2_c__c =twolofc1;
             }          
             upsert CMG;
             if(TA.id!=null){
                TestAttachment__c QueryTestAtt=[select id,name from TestAttachment__c where id=:TA.id];
                list<Attachment>CMIAttachment=new list<Attachment>();
     
                if(QueryTestAtt.id!=null){            
                   list<Attachment>atch=[select id,name,body,parentid,contenttype from Attachment where parentid=:QueryTestAtt.id];
                   if(atch.size()>0) {
                      for(Attachment a:atch){
                         if(CMG.id!=null){
                            Attachment a1=new Attachment();
                            a1.name=a.name;
                            a1.body=a.body;
                            a1.parentid=CMG.id;
                            CMIAttachment.add(a1);
                         }                                       
                      }      
                   }
                }
                if(CMIAttachment.size()>0){
                   insert CMIAttachment;
                   delete QueryTestAtt;
                }
             }
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          // New code here to attempt to attach PDF to email reply. 
             PageReference pdf = new pageReference('/grantsurveyresponse/GrantSurveyResponse_GeneratePDF?id='+CMG.id);
             string pdfheader = ApexPages.currentPage().getHeaders().get('Host');
             string pdfurl=pdf.geturl();
             string pdfpagename='https://'+ pdfheader + pdfurl;
          // Set rest of email attributes  
             mail.setToAddresses(toAddresses);
             mail.setInReplyTo(CMG.Grant_Contact_Email__c);
             mail.setUseSignature(false);
             mail.setSaveAsActivity(false);
             mail.setSenderDisplayName('First in the Community');
             mail.setsubject('Grant Progress Report Received: '+organization_name);
             mail.setHtmlBody('<font-family:Palatino> <b>Program name: </b>' +Name_of_Program+'<br/><b>Priority:  </b>'+purpose+'<br/><b>Date Awarded:  </b>'+Date_awarded_formatted+'<br/><a href="'+pdfpagename+'">PDF</a></font>');
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
             pagereference p=new pagereference('/grantsurveyresponse/Thankyou?id='+CMG.id);
             p.setredirect(true);
             return p;                     
          }
       }
       return null;
    }       

    public pagereference nextpage() {
          IsInputError=false;  //initialize this to false.  Numeric checks below will possibly reset it.        
          //enforce that all entered values are numeric in the "actual outcomes" area
          if(Stabilization == true) {
             if (CMG.Housing_Units_Created_Built_AI__c.isNumeric()) {
                Housing_Units_Created_Built_AI=integer.valueof(CMG.Housing_Units_Created_Built_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Housing Units created/built must be numeric'));
                IsInputError=true;
                return null;
             } 
             if (CMG.Individuals_Rec_Homeownership_Educ_AI__c.isNumeric()) {
                Individuals_Rec_Homeownership_Educ_AI=integer.valueof(CMG.Individuals_Rec_Homeownership_Educ_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Individuals Receiving Home Ownership Education must be numeric'));
                IsInputError=true;
                return null;
             } 
             if (CMG.Housing_Units_Rehabilitated_Renovated_AI__c.isNumeric()) {
                Housing_Units_Rehabilitated_Renovated_AI=integer.valueof(CMG.Housing_Units_Rehabilitated_Renovated_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Housing Units Rehabilitated/Renovated must be numeric'));
                IsInputError=true;
                return null;
             } 
             if (CMG.Homeownership_Educ_Sessions_AI__c.isNumeric()) {
                Homeownership_Educ_Sessions_AI=integer.valueof(CMG.Homeownership_Educ_Sessions_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of Homeownership Education Sessions must be numeric'));
                IsInputError=true;
                return null;
             } 
             if (CMG.Housing_Units_Financed_AI__c.isNumeric()) {
                Housing_Units_Financed_AI=integer.valueof(CMG.Housing_Units_Financed_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of Housing Units Financed must be numeric'));
                IsInputError=true;
                return null;
             }              
          }
          if(EducatedWorkforce == true) {
             if (CMG.Individuals_Served_in_Prop_Program_AI__c.isNumeric()) {
                Individuals_Served_in_Prop_Program_AI=integer.valueof(CMG.Individuals_Served_in_Prop_Program_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Individuals served in Prop program must be numeric'));
                IsInputError=true;
                return null;
             }
             if (CMG.Adults_Provided_Education_AI__c.isNumeric()) {
                Adults_Provided_Education_AI=integer.valueof(CMG.Adults_Provided_Education_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of Adults provided education must be numeric'));
                IsInputError=true;
                return null;
             }             
             if (CMG.Youth_Provided_Work_Career_Educ_AI__c.isNumeric()) {
                Youth_Provided_Work_Career_Educ_AI=integer.valueof(CMG.Youth_Provided_Work_Career_Educ_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of youth provided workforce/career Education must be numeric'));
                IsInputError=true;
                return null;
             } 
             if (CMG.Adults_Provided_Vocational_Training_AI__c.isNumeric()) {
                Adults_Provided_Vocational_Training_AI=integer.valueof(CMG.Adults_Provided_Vocational_Training_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of adults provided vocational/career training or workforce development must be numeric'));
                IsInputError=true;
                return null;
             } 
             if (CMG.Youth_Provided_Voc_Train_Work_Dev_AI__c.isNumeric()) {
                Youth_Provided_Voc_Train_Work_Dev_AI=integer.valueof(CMG.Youth_Provided_Voc_Train_Work_Dev_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of youth provided vocational/career training or workforce development must be numeric'));
                IsInputError=true;
                return null;
             } 
          }
          if(stronglocal == true) {
             if (CMG.Small_Businesses_Assisted_AI__c.isNumeric()) {
                Small_Businesses_Assisted_AI=integer.valueof(CMG.Small_Businesses_Assisted_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of small businesses assisted must be numeric'));
                IsInputError=true;
                return null;
             }
             if (CMG.New_Businesses_Served_AI__c.isNumeric()) {
                New_Businesses_Served_AI=integer.valueof(CMG.New_Businesses_Served_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of new businesses served must be numeric'));
                IsInputError=true;
                return null;
             }             
             if (CMG.Workshops_Training_Events_Provided_AI__c.isNumeric()) {
                Workshops_Training_Events_Provided_AI=integer.valueof(CMG.Workshops_Training_Events_Provided_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of workshops and training events provided must be numeric'));
                IsInputError=true;
                return null;
             } 
             if (CMG.Indiv_Coaching_Sessions_w_Small_Bus_AI__c.isNumeric()) {
                Indiv_Coaching_Sessions_w_Small_Bus_AI=integer.valueof(CMG.Indiv_Coaching_Sessions_w_Small_Bus_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of individual coaching sessions with small businesses must be numeric'));
                IsInputError=true;
                return null;
             } 
             if (CMG.Jobs_Created_Full_Time_AI__c.isNumeric()) {
                Jobs_Created_Full_Time_AI=integer.valueof(CMG.Jobs_Created_Full_Time_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of full time jobs created must be numeric'));
                IsInputError=true;
                return null;
             } 
             if (CMG.Jobs_Created_Part_Time_AI__c.isNumeric()) {
                Jobs_Created_Part_Time_AI=integer.valueof(CMG.Jobs_Created_Part_Time_AI__c);
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'NNumber of part time jobs created must be numeric'));
                IsInputError=true;
                return null;
             }              
          }        
        ShowMain=false;
        ShowSec=true;
        return null;
    }

    public PageReference PrevPage() {
        ShowMain=true;
        ShowSec=false;
        return null;
    }
    
    public PageReference createpdf() {
     // Redirect
        PageReference page = new pageReference('/apex/GrantSurveyResponse_GeneratePDF?id='+CMG.id);
        page.setRedirect(true);
        return page;
    }
}