public with sharing class VolunteerTrackingExtension
{
    private ApexPages.StandardController sc;
    private List<Volunteer_Activity__c> VolunteerActivityList = null;
  //private List<Volunteer_Organization__c> volunteerOrganizationList = null;
    private List<Volunteer_Organization__c> organizations = null;
    private List<Volunteer_Activity__c> volunteerActivitiesThisYear = null;
    private List<AggregateResult> volunteerOrganizationList = null;
    private List<Volunteer_Activity__c> CheckActivity = null;    
    public integer index = 0;
    private List<Volunteer_Activity__c> VolActivityDropdown = null;    
    private id NewOrgId = null;  //DAG_2019_08_22 New variable.
    private string VolOrg = null;  //DAG_2019_08_22 New variable.
    private string VolOrgName = null;  //DAG_2019_08_22 New variable.    
  //public boolean forward {get; set;}
  //public boolean backward {get; set;}
  //public boolean add{get; set;}
    public String q{get; set;}
    public String query{get; set;}
    private static final decimal time_adjust = .25;  //DAG_2019_05_13 New variable to adjust for GMT.  Have to add 6 hours so date will display correctly in Salesforce.
    public string Employee_fullname{get; set;}
    public String SelectedOrg{get; set;} //DAG_2019_08_22 New Variable for previously served organizations selectlist. 
    public String SelectedOrgName{get; set;} //DAG_2019_08_22 New Variable for previously served organizations selectlist.
    @TestVisible private integer CurrYear = null;  //DAG_2019_09_12 New variable here used for restricting activity dates to current year.  Is set in controller method.
    @TestVisible private date CurrYearJan1 = null;  //DAG_2019_09_12 New variable here used for restricting activity dates to current year.  Uses the variable above, and is set in controller method.
    @TestVisible private date CurrYearDec31 = null;  //DAG_2019_09_12 New variable here used for restricting activity dates to current year.  Uses the variable above, and is set in controller method.        
  //public string Orgname_color{get;set;}
  //public string Organization_name{get; set;}
    public boolean hasActivities {get; set;}
    public boolean ShowBack{get; set;}
    public boolean ShowGreeting{get; set;}   
    public boolean has_prev_vol_activities {get; set;}
    public boolean has_Vol_Activities_For_This_Org{get;set;}
    public decimal totYearHours{get;set;}
    public datetime twoyears_ago{get; set;}
    public Volunteer_Activity__c vact {get; set;}
    public Employee__c employee;
    
    public VolunteerTrackingExtension(ApexPages.StandardController standardController){
     sc = standardController;
     vact=new Volunteer_Activity__c();
     CurrYear = date.today().year();  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only. 
     CurrYearJan1 = date.newInstance(CurrYear, 1, 1);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only. 
     CurrYearDec31 = date.newInstance(CurrYear, 12, 31);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only.
        
     }

    public class VolOrgsThisYear{
       public string volActivityID {get; set;}
       public string volOrganizationID {get; set;}
       public String volOrganizationName {get; set;}
       public String volOrganizationNameNoApost {get; set;}
       public String organizationOther {get; set;}
       public String organizationOtherNoApost {get; set;}
       public String numOrganizations {get; set;}
       public decimal totHours {get; set;}
       public VolOrgsThisYear(string z, string v, string n, string c, string o, string x, string s, decimal h){
          this.volActivityID=z;
          this.volOrganizationID=v;
          this.volOrganizationName=n;
          this.volOrganizationNameNoApost=c;
          this.organizationOther=o;
          this.organizationOtherNoApost=x;
          this.numOrganizations=s;
          this.totHours=h;
       }
    }

    public list<VolOrgsThisYear> employeeVolOrgs = new list<VolOrgsThisYear>();

    public class VolActivitiesThisOrg{
       public string volActivityID {get; set;}
       public string volActivityName {get; set;}
       public string volActivityNameNoApost {get; set;}
       public date   volActivityDate {get; set;}
       public Decimal volActivityHours {get; set;}
       public string numActivities {get; set;}
       public VolActivitiesThisOrg(string v, string n, string x, date d, decimal h, string a){
          this.volActivityID=v;
          this.volActivityName=n;
          this.volActivityNameNoApost=x;
          this.volActivityDate=d;
          this.volActivityHours=h;
          this.numActivities=a;
       }
    }

    public list<VolActivitiesThisOrg> employeeVolActivities = new list<VolActivitiesThisOrg>();


    public PageReference Init()     { 
       String query = q!=null?q:ApexPages.currentPage().getParameters().get('q');
       if (string.ISBLANK(query)) {
          system.debug('Got Here Init ISBLANK'); 
          return page.VolunteerSignIn; 
       } else {
          List<Employee__c> CheckEmployee = [SELECT id, User_Logon_Name__c, First_Name__c, Last_Name__c, Email__c FROM Employee__c WHERE User_Logon_Name__c =: query limit 1 ];
          system.debug('Got Here after check employee. query = ' + query + '. q=' + q);
          if (CheckEmployee.size() == 0) {
           //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'This Employee ID was not found in our system.  Please try another.'));         
             return page.VolunteerSignIn; 
          } else {
             employee = CheckEmployee[0];
             List<Volunteer_Activity__c> checkVolActivities = [select id, name FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Recordtype.name = 'Intranet Activity Record' and Activity_Year_Formula__c = :string.valueof(CurrYear) limit 1 ];
             if (checkVolActivities.size() > 0) {
                has_prev_vol_activities = true;
             } else {
                has_prev_vol_activities = false;
             }
             system.debug('Got here init end.  Going to return Vol Org List page.  Employee = ' + employee.User_Logon_Name__c + ' Has prev: ' + has_prev_vol_activities);
             ShowGreeting = true;
             return page.VolunteerOrganizationList;
          }       
       }
    } 
     
    // Defines the navigation for the pages within Volunteer Reporting 

    public PageReference SignIn()     { 
        system.debug ('Got here signin-- q = ' + q);
        try {
            employee = [SELECT id FROM Employee__c WHERE User_Logon_Name__c =: q limit 1 ];
        } 
            catch(Exception e)  {
               apexPages.addMessage( new apexPages.Message(apexPages.Severity.Info, 'Error: ID not found!!!'));
        }
        
        return Page.VolunteerReporting;
        
    }
   /*
    public PageReference viewVolunteerReporting() {
        index=0; 
        q=employee.User_Logon_Name__c;
        PageReference pageRef = new PageReference('/apex/apex/VolunteerReporting?q='+employee.User_Logon_Name__c);
        return pageRef;
      //return Page.VolunteerReporting;
    }    
   */
    public PageReference choose_Organization_page() {
       system.debug('Got Here choose_Organization_page, before set of vact');
       twoyears_ago = System.now().addYears(-2);
       vact = new Volunteer_Activity__c();
       VolActivityDropdown = [SELECT id from Volunteer_Activity__c where employee_id__c = :employee.User_Logon_Name__c
       and Recordtype.name = 'Intranet Activity Record' and date_and_time__c >= :twoyears_ago];
       
       if (VolActivityDropdown.size() > 0) {
          has_prev_vol_activities = true;
       }
       system.debug('Got Here choose_Organization_page, AFTER set of vact');
       return Page.Vol_Choose_Organization; 
    }

    public PageReference ReturnToOpen() {
       PageReference page = new pageReference('/volunteer/Board_vol_open?q='+ employee.User_Logon_Name__c);
     //system.debug('Got Here ReturnToOpen VolAct. Page = ' + page + '. q=' + q);
       page.setRedirect(true);
       return page;        
    }
    
  /*
    public PageReference viewVolFinish() { 
        index=0; 
        return Page.VolunteerThankyou;
    }
  */
    
    public PageReference ReturntoOrganizationList() { 
       ShowGreeting = false;
       List<Volunteer_Activity__c> checkVolActivities = [select id, name FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Recordtype.name = 'Intranet Activity Record' and Activity_Year_Formula__c = :string.valueof(CurrYear) limit 1 ];
       if (checkVolActivities.size() > 0) {
          has_prev_vol_activities = true;
       } else {
          has_prev_vol_activities = false;
       }       
       return Page.VolunteerOrganizationList;
    }

    public PageReference viewVolunteerSignIn() { return Page.VolunteerSignIn; }   
   /* 
    public pagereference hereForTheFirstTime() {
      employee = getEmployee();
      system.debug ('Got here for the first time.  Employee ID: ' + employee.user_logon_name__c);
      pagereference page = choose_Organization_page();
      return page;
    } 
   */
    public List<VolActivitiesThisOrg> getEmployeeVolActivitiesForOrganizationThisYear() {
       Integer CurrYear = date.today().year();  //DAG_2019_09_12 Two new variables here for restricting Volunteer entries to current year only.
       Integer i=0;
       string activityNameNoSpecChar = null;
       date CurrYearJan1 = date.newInstance(CurrYear, 1, 1);  //DAG_2019_09_12 Two new variables here for restricting board entries to current year only.

       volunteerActivitiesThisYear = [SELECT id, name, activity_date_intranet__c, duration_hours__c
                                      FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Volunteer_Organization__c = :vact.Volunteer_Organization__c and Organization_Other__c = :vact.Organization_Other__c and RecordType.name = 'Intranet Activity Record' and Activity_Year_Formula__c = :string.valueof(CurrYear)];
       
       employeeVolActivities.clear();
       system.debug('Got here retrieved vol activities for org: ' + selectedOrgName + '. Employee = ' + employee.user_logon_name__c + '. List size: ' + volunteerActivitiesThisYear.size());
       
       for (i=0; i < volunteerActivitiesThisYear.size(); i++) {
           system.debug('Got here inside for loop adding to list: ' + i + '. Vol Act Name: ' + volunteerActivitiesThisYear[i].name);
           activityNameNoSpecChar = '';
           activityNameNoSpecChar = volunteerActivitiesThisYear[i].name.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '-');
           employeeVolActivities.add(new VolActivitiesThisOrg(string.valueof(volunteerActivitiesThisYear[i].id), volunteerActivitiesThisYear[i].name, activityNameNoSpecChar, volunteerActivitiesThisYear[i].activity_date_intranet__c, 
               volunteerActivitiesThisYear[i].duration_hours__c, string.valueof(volunteerActivitiesThisYear.size())));
       }
       return employeeVolActivities;
    }

    public pagereference editVolunteerOrganization() { 
       string volActID = apexpages.currentpage().getparameters().get('SelectedVolActID');
       volunteer_Activity__c volOrgName = new Volunteer_Activity__c();
       system.debug ('Got Here editVolOrganization.  SelectedID = ' + volActID);
       if (!string.ISBLANK(volActID)) {
          volOrgName = getVolOrgName(volActID);
          system.debug ('Got Here editVolOrganization going to return.  SelectedID = ' + volActID +'.  Orgname = ' + selectedOrgName);
          if (volOrgName.Volunteer_Organization__r.name.contains ('New Organization')) {
             selectedOrgName = volOrgName.Organization_Other__c + ' (New Organization)';
          } else {
             selectedOrgName = volOrgName.Volunteer_Organization__r.Name;
          }
          has_Vol_Activities_For_This_Org = true;
          vact = new Volunteer_Activity__c();
          vact.volunteer_organization__c = volOrgName.Volunteer_Organization__c;
          vact.organization_other__c = volOrgName.Organization_Other__c;          
          return page.VolunteerAddition;          
       } else {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Something went wrong here. Please close your browser and try again.'));
          return null;
       }
    }

    public Volunteer_Activity__c getVolOrgName(string volunteerActivityID) {
       Volunteer_Activity__c getVolOrgName = [select id, volunteer_Organization__c, volunteer_organization__r.name, organization_other__c from volunteer_activity__c
          where id = :volunteerActivityID limit 1];
       return getVolOrgName;
    }
      
    public PageReference editVolunteerActivity() { 
       string selectedVolunteerActivity = apexpages.currentpage().getparameters().get('SelectedVolunteerActivity');
       system.debug('Got Here editVolunteeractivity selectedactivity = ' + selectedVolunteerActivity);
     //if (selectedVolunteerActivity == null || selectedVolunteerActivity == '') {
     //   vact = new Volunteer_Activity__c();
     //} else {
          vact = GetVolActivityDetails(selectedVolunteerActivity);
          system.debug('Got Here editVolunteeractivity after get activity details.  Org = ' + vact.Volunteer_Organization__c + ' Org Name = ' + vact.Volunteer_Organization__r.Name + '  Org Other = ' + vact.Organization_Other__c);
     //}
     //selectedOrgName = ebm.Volunteer_organization__r.name;
       return Page.VolunteerActivityEdit;
    }
    
   /*
    public PageReference CancelEditVolunteerActivity() {
       string saveVolOrgID = vact.Volunteer_Organization__c;
       string saveOrgOther = vact.Organization_Other__c;
       vact = new Volunteer_Activity__c(); 
       vact.Volunteer_Organization__c = saveVolOrgID;
       vact.Organization_Other__c = saveOrgOther;
       return Page.VolunteerAddition;
    }
    */
    
    public Volunteer_Activity__c GetVolActivityDetails(string volActID) {
       Volunteer_Activity__c volActivityDetail = [SELECT id, name, Employee_Market__c, Volunteer_Organization__c, Volunteer_Organization__r.name, Organization_Other__c, Activity_Date_Intranet__c, Volunteer_Events__c, Not_Listed__c, Number_of_FNB_Employees_Involved__c, Sessions__c, 
         Duration_hours__c, Number_of_Participants__c, Activity_Focus_Area__c, Event_Summary__c FROM Volunteer_Activity__c WHERE id = :VolActID];
       
       return volActivityDetail; 
    }
        
    //DAG_2019_08_22 New procedure here for setting the Volunteer Organization on a new Volunteer Activity.  Called when user hits Continue button on Vol_Choose_Organization page. 
    public PageReference New_Volunteer_Activity() {
        hasActivities = false;
        string EditPage = apexpages.currentpage().getparameters().get('EditPage');
        ShowBack = false;
        Integer CurrYear = date.today().year();  //DAG_2019_08_22 Two new variables here for restricting entries to current year only.
        if (string.ISBLANK(vact.Volunteer_Organization__c) && string.ISBLANK(vact.Organization_Other__c) && string.ISBLANK(SelectedOrg)) {
      
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter an organization name. If you cannot find the organization name in the drop down or by using the search function, enter the organization name in the “Enter in new Organization” field.'));
            return null;
        }
        List<Volunteer_Organization__c> NewOrgList = [SELECT Id, name FROM Volunteer_Organization__c WHERE name = 'New Organization' LIMIT 1];
        if (string.ISBLANK(vact.Organization_Other__c)) {
           if (string.ISBLANK(vact.Volunteer_Organization__c)) {
              if (SelectedOrg.startswith('NewOrg__')) {
                 SelectedOrgName = SelectedOrg.Substring(8);
                 system.debug ('Got Here New Activity. Selected Org = ' + SelectedOrg + '.  SelectedOrgName = ' + SelectedOrgName + '. New Org List Size: ' + NewOrgList.size());
                 if(NewOrgList.size()>0){        
                    vact.Volunteer_organization__c = NewOrgList[0].Id;
                    vact.Organization_Other__c = SelectedOrg.Substring(8);
                 } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact Community Development (email communitydevelopment@fnni.com).  New Organization setup not complete.'));
                    return null;            
                 }
                 CheckActivity  = [SELECT id, name,Volunteer_Organization__r.Name
                                  FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Recordtype.name = 'Intranet Activity Record' and Activity_Year__c = :CurrYear and Organization_Other__c = :SelectedOrgName];
                 system.debug ('Got Here New Activity Selected Activity.  Selected Org name: ' + SelectedOrgName + '  Employee: ' + employee.User_Logon_Name__c + ' Check Activity Size: ' + CheckActivity.size());                                  
                 if (CheckActivity.size() > 0) {
                    has_Vol_Activities_For_This_Org = true;
                 } else {
                    has_Vol_Activities_For_This_Org = false;
                 }                    
              } else {
                 vact.Volunteer_organization__c = SelectedOrg;
                 List<Volunteer_Organization__c> volunteerOrgList = [SELECT Id, name FROM Volunteer_Organization__c WHERE id = :SelectedOrg LIMIT 1];
                 SelectedOrgName = volunteerOrgList[0].Name;                                 
              
                 CheckActivity  = [SELECT id, name,Volunteer_Organization__r.Name
                                   FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Recordtype.name = 'Intranet Activity Record' and Activity_Year__c = :CurrYear and Volunteer_organization__c = :SelectedOrg];
                 if (CheckActivity.size() > 0) {
                    has_Vol_Activities_For_This_Org = true;
                 } else {
                    has_Vol_Activities_For_This_Org = false;
                 }
              }
           } else {
              CheckActivity  = [SELECT id, name, Volunteer_Organization__c, Volunteer_Organization__r.Name
                                FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Recordtype.name = 'Intranet Activity Record' and Activity_Year__c = :CurrYear and Volunteer_organization__c = :vact.Volunteer_organization__c];
              system.debug('Got Here New Vol Activity:  Existing Org selected on choose org page, name = ' + vact.Volunteer_Organization__r.Name + '.  ID = ' + vact.volunteer_organization__c);
              if (CheckActivity.size() > 0) {
                 SelectedOrgName = CheckActivity[0].Volunteer_Organization__r.Name;              
                 has_Vol_Activities_For_This_Org = true;
              } else {
                 List<Volunteer_Organization__c> volunteerOrgList = [SELECT Id, name FROM Volunteer_Organization__c WHERE id = :vact.Volunteer_organization__c LIMIT 1];
                 SelectedOrgName = volunteerOrgList[0].Name; 
                 has_Vol_Activities_For_This_Org = false;
              }                           
           }
        } else {
           has_Vol_Activities_For_This_Org = false;
           if(NewOrgList.size()>0){
              vact.Volunteer_Organization__c = NewOrgList[0].Id;
              SelectedOrgName = vact.Organization_Other__c + ' (' + NewOrgList[0].Name +')';               
              CheckActivity  = [SELECT id, name,Volunteer_Organization__r.Name
                                FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Recordtype.name = 'Intranet Activity Record' and Activity_Year__c = :CurrYear and Organization_Other__c = :vact.organization_other__c];
              if (CheckActivity.size() > 0) {
                 has_Vol_Activities_For_This_Org = true;
              } else {
                 has_Vol_Activities_For_This_Org = false;
              }
           } else {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact Community Development (email communitydevelopment@fnni.com).  New Organization setup not complete.'));
              return null;            
           }
           vact.Not_Listed__c = true;
        }
        if (EditPage == 'VolOrganizationList') {
           ShowBack = false;
        } else {
           ShowBack = true;
        }
        return Page.VolunteerAddition; 
    }    
   
    public PageReference addVolunteerActivity() {
        system.debug ('Got Here addvol activity begin');
        vact.Not_Listed__c = false;
        boolean addError = false;
        string pageCameFrom = apexpages.currentpage().getparameters().get('EditPage');
        if (string.ISBLANK( vact.Volunteer_Organization__c) && string.ISBLANK(vact.Organization_Other__c)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Something went wrong here... no organization selected.  Please exit site and re-enter.'));
            return null;
        } else {
         //DAG_2019_05_03 Added to this conditional and changed pagemessage below-- all fields need to be filled in now.
           if (string.ISBLANK(vact.Employee_Market__c)) {
              vact.Employee_Market__c.addError('Please choose a value');
              addError = true;
           }
           if (string.ISBLANK(vact.Name)) {
              vact.Name.addError('Please enter a value');
              addError = true;
           }
           if (vact.Activity_Date_Intranet__c == NULL) {
              vact.Activity_Date_Intranet__c.addError('Please choose a value');
              addError = true;
           }
           if (string.ISBLANK(vact.Volunteer_Events__c)) {
              vact.Volunteer_Events__c.addError('Please choose a value');
              addError = true;
           }
           if (vact.Number_of_FNB_Employees_Involved__c == NULL) {
              vact.Number_of_FNB_Employees_Involved__c.addError('Please enter a value');
              addError = true;
           }
           if (vact.Sessions__c == null) {
              vact.Sessions__c.addError('Please enter a value');
              addError = true;
           }
           if (vact.Duration_hours__c == NULL) {
              vact.Duration_hours__c.addError('Please enter a value');
              addError = true;
           }
           if (vact.Number_of_Participants__c == NULL) {
              vact.Number_of_Participants__c.addError('Please enter a value');
              addError = true;
           }
           if (string.ISBLANK(vact.Activity_Focus_Area__c)) {
              vact.Activity_Focus_Area__c.addError('Please choose a value');
              addError = true;
           }
           if (string.ISBLANK(vact.Event_Summary__c)) {
              vact.Event_Summary__c.addError('Please enter a value');
              addError = true;
           }

           if (addError == true) {
              return null;             
           } else {
               system.debug('Got Here addvolunteeractivity check that date.  Employee_id__c: ' + vact.employee_id__c + '. Curr Year: ' + CurrYear + '. Activity date year: ' + vact.Activity_Date_Intranet__c.year());        
               if (vact.Activity_Date_Intranet__c.year() != CurrYear) {
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Activity dates must be in Current year only.  Thanks.')); 
                  vact.Activity_Date_Intranet__c.addError('Activity dates must be in Current year only.  Thanks.');
                  return null;
               } else {
                  vact.Employee_Name_Intranet__c = employee.First_Name__c +' '+ employee.Last_Name__c;
                  vact.Employee_ID__c =  employee.User_Logon_Name__c;
                  vact.Employee_Email_Intranet__c = employee.email__c;
                  vact.RecordTypeid = [SELECT Id,SobjectType,Name FROM RecordType WHERE SobjectType='Volunteer_Activity__c' and name = 'Intranet Activity Record' LIMIT 1].id;
                  vact.date_and_time__c = datetime.newInstance(vact.Activity_Date_Intranet__c.year(), vact.Activity_Date_Intranet__c.month(),vact.Activity_Date_Intranet__c.day());
                  vact.date_and_time__c = vact.date_and_time__c + time_adjust;
                  system.debug('Got Here going to upsert vact.  Employee_id__c: ' + vact.employee_id__c + '. Org name: ' + vact.volunteer_organization__r.name + '. Org Other: ' + vact.Organization_Other__c);
                  string saveVolOrgID = vact.Volunteer_Organization__c;
                  string saveVolOrgOther = vact.Organization_Other__c;              
                  upsert vact;
                  has_Vol_Activities_For_This_Org = true;
                  vact = new Volunteer_Activity__c();
                  vact.volunteer_Organization__c = saveVolOrgID;
                  vact.Organization_Other__c = saveVolOrgOther;
                  if (pageCameFrom == 'VolunteerActivityEdit') {
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Activity Saved Successfully.'));
                  } else {
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Activity Added Successfully.'));
                  }
                  return Page.VolunteerAddition;
               }
           }
        }
     }

    public Employee__c getEmployee() {
    
       if (! string.ISBLANK(q)) {        
            employee = [SELECT id, User_Logon_Name__c, First_Name__c, Last_Name__c, Email__c FROM Employee__c WHERE User_Logon_Name__c =: q limit 1 ];     
        }
        
            return employee;
    }   

    public void setEmployee(Employee__c value) {
        employee = value;    
    }

    public List<VolOrgsThisYear> getEmpVolOrgsThisYear(){
       boolean firstTimeThrough = true;
       string curVolActID = null;
       string curVolOrgID = null;
       string curVolOrgName = null;
       string volOrgNameNoSpecChar = null;
       string curOrgOtherName = null;
       string orgOtherNameNoSpecChar = null;
       string prevVolActID = null;
       string prevVolOrgID = null;
       string prevVolOrgName = null;
       string prevOrgOtherName = null;
       decimal totOrgHours = 0;
       totYearHours = 0;
       integer i= 0;
       integer numActivities = 0;
       List<Volunteer_Activity__c> thisYearActivities = new List<Volunteer_Activity__c>();
       thisYearActivities = [SELECT id, Volunteer_Organization__c, Volunteer_Organization__r.Name, Organization_Other__c, Duration_hours__c FROM Volunteer_Activity__c WHERE Employee_id__c = :employee.User_Logon_Name__c
          and RecordType.name = 'Intranet Activity Record'
          and Activity_Year_Formula__c = :string.valueof(CurrYear)
          ORDER BY Volunteer_Organization__r.Name, Organization_Other__c];
          employeeVolOrgs.clear();
       if (thisYearActivities.size() > 0) {
          for (i=0; i < thisYearActivities.size(); i++) {
             curVolActID = thisYearActivities[i].id;
             curVolOrgID = thisYearActivities[i].Volunteer_Organization__c;
             curVolOrgName = thisYearActivities[i].Volunteer_Organization__r.Name;
             curOrgOtherName = thisYearActivities[i].Organization_Other__c;
             if (firstTimeThrough == true) {
                numActivities = 1;
                prevVolActID = thisYearActivities[i].id;
                prevVolOrgID = thisYearActivities[i].Volunteer_Organization__c;
                prevVolOrgName = thisYearActivities[i].Volunteer_Organization__r.Name;
                prevOrgOtherName = thisYearActivities[i].Organization_Other__c;
                firstTimeThrough = false;
             } else {
                system.debug('Got Here get this years orgs.  Activity id = ' + curVolActID + '. curOrgname = ' + curVolOrgName+ '.  PrevOrgName = ' + prevVolOrgName);
                if ((curVolOrgName != prevVolOrgName) || (curOrgOtherName != prevOrgOtherName)) {
                   numActivities = 2;
                   volOrgNameNoSpecChar = '';
                   orgOtherNameNoSpecChar = '';
                   volOrgNameNoSpecChar = prevVolOrgName.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '-');
                   if (prevOrgOtherName != null) {
                      orgOtherNameNoSpecChar = prevOrgOtherName.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '-');
                   }
                   system.debug('Got Here get this years orgs.  Activity id = ' + prevVolActID + '. prevVolOrgID = ' + prevVolOrgID + '.  PrevOrgName = ' + prevVolOrgName +'. prevOrgOtherName ' + prevOrgOtherName);
                   employeeVolOrgs.add(new VolOrgsThisYear(prevVolActID, prevVolOrgID, prevVolOrgName, volOrgNameNoSpecChar, prevOrgOtherName, orgOtherNameNoSpecChar, string.valueof(numActivities), totOrgHours));
                   prevVolActID = curVolActID;
                   prevVolOrgID = curVolOrgID;
                   prevVolOrgName = curVolOrgName;
                   prevOrgOtherName = curOrgOtherName;
                   totOrgHours = 0;
                }
            //totOrgHours += thisYearActivities[i].Duration_Hours__c;
             }
             system.debug('Got Here get this years orgs Load up them totals.  curOrgname = ' + curVolOrgName+ '.  PrevOrgName = ' + prevVolOrgName + '. Hours = ' + thisYearActivities[i].Duration_Hours__c + '. i: ' + i);
             totOrgHours += thisYearActivities[i].Duration_Hours__c;
             totYearHours += thisYearActivities[i].Duration_Hours__c;
          }
          system.debug('Got Here Load Last One.  curOrgname = ' + curVolOrgName + '. VolActID = ' + curVolActID);
          volOrgNameNoSpecChar = '';
          orgOtherNameNoSpecChar = '';
          volOrgNameNoSpecChar = prevVolOrgName.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '-');
          if (curOrgOtherName != null) {
              orgOtherNameNoSpecChar = curOrgOtherName.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '-');
          }
          employeeVolOrgs.add(new VolOrgsThisYear(curVolActID, curVolOrgID, curVolOrgName, volOrgNameNoSpecChar, curOrgOtherName, orgOtherNameNoSpecChar, string.valueof(numActivities), totOrgHours));
          has_prev_vol_activities = true;       
       } else {
          has_prev_vol_activities = false;
       }
       return employeeVolOrgs;       
    }
    
    public PageReference DeleteVolunteerActivity() { 
       string VolActIDParam = apexpages.currentpage().getparameters().get('VolunteerActivityToDelete');
       volunteer_Activity__c activityToDelete = new Volunteer_Activity__c();
       integer numActivities = integer.valueof(volActIDParam.substringbefore('^'));
       string volActID = volActIDParam.substringafter('^');
       activityToDelete.id = VolActID;
       if (activityToDelete.Id != null) {
          delete activityToDelete;
          if (numActivities > 1) {
             has_Vol_Activities_For_This_Org = true;
          } else {
             has_Vol_Activities_For_This_Org = false;
          }          
       }
       return Page.VolunteerAddition;
    }
    
    public pagereference deleteAllActivitiesForOrganization() {
       string volOrgIDNumActivities = apexpages.currentpage().getparameters().get('VolActAndNumActivities');
       list<Volunteer_Activity__c> volOrgToDelete = new list<Volunteer_Activity__c>();
       string strNumberOrgsServed = volOrgIDNumActivities.substringbefore('^');
       string volActID = volOrgIDNumActivities.substringafter('^');
       Volunteer_Activity__c volOrgInfo = getVolOrgName(volActID);
       integer numberOrgsServed = integer.valueof(strNumberOrgsServed);
       system.debug('Got Here Delete All.  Number orgs served: ' + numberOrgsServed);
       volOrgToDelete = [select id FROM Volunteer_Activity__c WHERE Employee_id__c = :employee.User_Logon_Name__c
          and Volunteer_Organization__c = :volOrgInfo.Volunteer_Organization__c
          and Organization_Other__c = :volOrgInfo.Organization_Other__c
          and Activity_Year_Formula__c = :string.valueof(CurrYear)];
       if (volOrgToDelete.size() > 0) {
          delete volOrgToDelete;
       }
       if (numberOrgsServed == 1) {
          has_prev_vol_activities = false;
       } else {
          has_prev_vol_activities = true;
       }
       return Page.VolunteerOrganizationList;
    }    
        
    //DAG_2019_08_22 New procedure to populate the Dropdown list on the Vol_Choose_Organization page. 
    public List<SelectOption> GetPrevVolActivities() {
       SelectedOrg = '';
       twoyears_ago = System.now().addYears(-2);
       Set<String> SelectOptionSet = new Set<String>();
       Set<SelectOption> optionset = new Set<SelectOption>();
       List<SelectOption> options = new List<SelectOption>();
       List<Volunteer_Organization__c> volunteerOrgList = [SELECT Id FROM Volunteer_Organization__c WHERE name = 'New Organization' LIMIT 1];
       if (volunteerOrgList.size() > 0) {
          NewOrgId = volunteerOrgList[0].Id;
       } else {
          NewOrgId = null;
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact Community Development department.  New Organization entry missing.'));
          return null;
       }
       VolActivityDropdown = [SELECT Volunteer_Organization__c, Volunteer_Organization__r.Name, Organization_Other__c from Volunteer_Activity__c where employee_id__c = :employee.User_Logon_Name__c
       and Recordtype.name = 'Intranet Activity Record' and date_and_time__c >= :twoyears_ago];

       system.debug('Got here GetPrevVolActivities.  Employee ID:  ' + employee.User_Logon_Name__c + '  Two Years Ago: ' + twoyears_ago + '.  List Size: ' + VolActivityDropdown.size());
       
       if (VolActivityDropdown.size() > 0) {
          has_prev_vol_activities = true;         
          options.add(new SelectOption('', ' '));
          system.debug('Got here GetPrevVolActivities Before for Loop.  Employee ID:  ' + employee.User_Logon_Name__c + '  Two Years Ago: ' + twoyears_ago + '.  List Size: ' + VolActivityDropdown.size());
          for (Volunteer_Activity__c selectlist : VolActivityDropdown) {
          system.debug('Got here GetPrevVolActivities Inside for Loop.  Employee ID:  ' + employee.User_Logon_Name__c + '  Two Years Ago: ' + twoyears_ago + '.  Vol Org Id: ' + selectlist.Volunteer_Organization__c
           +'. Org Other: ' + selectList.Organization_Other__c);          
             if (selectlist.Volunteer_Organization__c == NewOrgId) {
                if (selectList.Organization_Other__c != null) {
                   VolOrgName = selectList.Organization_Other__c;               
                   optionset.add(new SelectOption(string.valueof('NewOrg__' + selectList.Organization_Other__c), VolOrgName));
                }
             } else {
                if (string.valueof(selectList.Volunteer_Organization__r.Name) != null) {
                   VolOrgName = string.valueof(selectList.Volunteer_Organization__r.Name);
                   optionset.add(new SelectOption(string.valueof(selectList.get('Volunteer_Organization__c')), VolOrgName));
                }
             }
          }
          options.addAll(optionset);          
          return options;

       } else {
          has_prev_vol_activities = false;
       }
       return null;
    }
    
   public String getSelectedOrg() {
      return SelectedOrg;
   }
            
   public void setSelectedOrg(String SelectedOrg) {
      this.SelectedOrg = SelectedOrg;
   }
    
}