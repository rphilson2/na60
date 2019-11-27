// DAG_2019_01_22 VersionOne Feature E-08549-- Large Modification on this date.  Changed this whole class from updating the Employee_Board_Membership__c object to updating the Volunteer_Activity__c object.
public with sharing class BoardReportingExtension 
{
    private ApexPages.StandardController sc;
  //private List<Employee_Board_Membership__c> boardMembershipList = null;
    public String SelectedOrg{get; set;} //DAG_2019_01_22 New Variable for previously served organizations selectlist. 
    public String SelectedOrgName{get; set;} //DAG_2019_01_22 New Variable for previously served organizations selectlist. 
    private List<Volunteer_Activity__c> boardMembershipList = null;  //DAG_2019_01_22 This variable replaces the one above.  Same variable name, but different Sobjecttype.
    private List<Volunteer_Activity__c> CheckActivity = null; //DAG_2019_01_22 Change this from type Employee_Board_Membership__c to Volunteer_Activity__c.
    @TestVisible private List<Volunteer_Board_Activity__c> boardMembershipActivities = null;  //DAG_2019_01_22 New list to show on each Board Activity page.  Shows the individual activities for each organization for the current year.
  //private List<AggregateResult> boardMembershipDropdown = null;
    private List<Volunteer_Activity__c> boardMembershipDropdown = null;
    private static final decimal time_adjust = .25;  //DAG_2019_05_13 New variable to adjust for GMT.  Have to add 6 hours so date will display correctly in Salesforce.
    private id NewOrgId = null;  //DAG_2019_01_22 New variable.
    private string VolOrg = null;  //DAG_2019_01_22 New variable.
    private string VolOrgName = null;  //DAG_2019_01_22 New variable.
    @TestVisible private integer CurrYear = null;  //DAG_2019_01_22 New variable here used for restricting activity dates to current year.  Is set in controller method.
    @TestVisible private date CurrYearJan1 = null;  //DAG_2019_01_22 New variable here used for restricting activity dates to current year.  Uses the variable above, and is set in controller method.
    @TestVisible private date CurrYearDec31 = null;  //DAG_2019_01_22 New variable here used for restricting activity dates to current year.  Uses the variable above, and is set in controller method.    
    public List<SelectOption> options = null; //DAG_2019_01_22 New variable.
    private List<Volunteer_Organization__c> volunteerOrganizationList = null;
    private List<Volunteer_Organization__c> organizations = null;
    private List<Employee__c> CheckEmployee = null;  //DAG_2019_01_22 New variable.
  //private String hash = '01p22000000D6DW';  
    public integer index = 0;
    public integer numberofactivities {get; set;}
    public decimal totBoardHoursThisYear {get; set;}    
    public boolean forward {get; set;}
    public boolean backward {get; set;}
    public boolean add{get; set;}
    public boolean showmessage{get; set;}
    public boolean has_prev_board_memberships{get;set;}  //DAG_2019_01_22 New variable for new Visualforce page where user is selecting board memberships. 
    public boolean has_Curr_Year_board_memberships{get;set;}  //DAG_2019_01_22 New variable for new Visualforce page where user is selecting board memberships. 
    public boolean ShowBack{get; set;}
    public boolean ShowGreeting{get; set;}
    public String q{get; set;}
    public string logon_user {get; set;}  //DAG_2019_01_22 New Variable. 
  //public datetime twoyears_ago{get; set;}  //DAG_2019_01_22 New Variable. 
    public datetime twoyears_ago = System.now().addYears(-2);

    public Volunteer_Activity__c ebm {get; set;} //DAG_2019_01_22 Change this from type Employee_Board_Membership__c to Volunteer_Activity__c.
    public Volunteer_Board_Activity__c vba {get; set;} //DAG_2019_01_22 new child record to Volunteer_Activity__c.    
    public Employee__c employee;
   
 
    public BoardReportingExtension(ApexPages.StandardController standardController){
    sc = standardController;
    CurrYear = date.today().year();  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only. 
    CurrYearJan1 = date.newInstance(CurrYear, 1, 1);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only. 
    CurrYearDec31 = date.newInstance(CurrYear, 12, 31);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only. 
     
     }
     
     public PageReference Init()     { 
        String query = q!=null?q:ApexPages.currentPage().getParameters().get('q');
        if (string.ISBLANK(query)) {
            system.debug('Got Here Init ISBLANK'); 
          //PageReference page = new pageReference('/CRAGrant/gr13?id='+ grantId);
          //page.setRedirect(true);
            return page.BoardDelegation; 
        } else {
            CheckEmployee = [SELECT id, User_Logon_Name__c, First_Name__c, Last_Name__c, Email__c FROM Employee__c WHERE User_Logon_Name__c =: query limit 1 ];            
            if (CheckEmployee.size() == 0) {
             //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'This Employee ID was not found in our system.  Please try another.'));         
               return page.BoardDelegation; 
            } else {
               employee = CheckEmployee[0];
               List<Volunteer_Activity__c> CheckBoardMemberships = [select id, name FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and (Volunteer_Events__c = 'Board/Committee Meeting' or Recordtype.name = 'Board/Committee Meeting') and Activity_Year__c = :CurrYear limit 1 ];
               if (CheckBoardMemberships.size() > 0) {
                  has_Curr_Year_board_memberships = true;
               } else {
                  has_Curr_Year_board_memberships = false;
               }

               ShowGreeting = true;
               return page.BoardOrganizationList;
            }       
        }
     } 

   //DAG_2019_01_22 New procedure for logging in with the Board_Vol_Open page.  For this procedure, we do not need a page returned, so this one is a void return type.
     public void getq()     { 
        String query = q!=null?q:ApexPages.currentPage().getParameters().get('q');
        if (string.ISBLANK(query)) {
           logon_user = '';
        } else { 
           system.debug('Got Here getq query = '+query);       
           CheckEmployee = [SELECT id, User_Logon_Name__c, First_Name__c, Last_Name__c, Email__c FROM Employee__c WHERE User_Logon_Name__c =: query limit 1 ];
           if (CheckEmployee.size() == 0) {
              logon_user = '';
           } else {
              logon_user = CheckEmployee[0].User_Logon_Name__c;
           }
        }
     } 
   //DAG_2019_01_22 end.
    
    // Defines the navigation for the pages within Board Reporting     
    public PageReference delegateBoard()     { 
        system.debug('Got Here delegateBoard before string check. q = ' + q);
        
        try {
            employee = [SELECT id FROM Employee__c WHERE User_Logon_Name__c =: q limit 1 ];     
        } 
            catch(Exception e)  {
                return page.BoardReporting;
        }
        return Page.BoardReporting;        
    }    
  //DAG_2019_01_22 Comment out this procedure.  It is no longer being used.
  /*public PageReference delegateBoard_save()     { 
        boardMembershipList = getEmployeeBoardMembership();
        return boardMembershipList.size()>0?Page.BoardAddition:Page.BoardActivity; 
    } */
    
    //DAG_2019_01_22 New procedure here for setting the Volunteer Organization on a new Volunteer Activity.  Called when user hits Continue button on Board_Choose_Organization page. 
    public PageReference New_Board_Activity() {
        numberofactivities = 0;
        string EditPage = apexpages.currentpage().getparameters().get('EditPage');
        ShowBack = false;
        Integer CurrYear = date.today().year();  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only.
        system.debug('Got Here New Board Activity before string check. Vol Org: ' + ebm.Volunteer_Organization__c + '. Org Other: ' + ebm.Organization_Other__c + ' SelectedOrg: ' + SelectedOrg);
        if (string.ISBLANK(ebm.Volunteer_Organization__c) && string.ISBLANK(ebm.Organization_Other__c) && string.ISBLANK(SelectedOrg)) {
      
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter an organization name. If you cannot find the organization name in the drop down or by using the search function, enter the organization name in the “Enter in new Organization” field.'));
            return null;
        }
        List<Volunteer_Organization__c> NewOrgList = [SELECT Id, name FROM Volunteer_Organization__c WHERE name = 'New Organization' LIMIT 1];        
        system.debug('Got Here New Board Activity After NewOrg select. New Org List Size: ' + NewOrgList.size());
        if (string.ISBLANK(ebm.Organization_Other__c)) {
         //List<Volunteer_Organization__c> NewOrgList = [SELECT Id, name FROM Volunteer_Organization__c WHERE name = 'New Organization' LIMIT 1];        
           if (string.ISBLANK(ebm.Volunteer_Organization__c)) {
              System.debug('Got Here New Board Activity-- Volunteer Org isblank. Selected Org: ' + SelectedOrg);
              if (SelectedOrg.startswith('NewOrg__')) {
                 system.debug('Got Here New Board Activity-- New Org Organization. SelectedOrg = ' + SelectedOrg);
                 SelectedOrgName = SelectedOrg.Substring(8);
                 CheckActivity  = [SELECT id, name,Volunteer_Organization__r.Name,Provided_HR_IT_or_Legal_Services__c,Contributed_Accounting_or_Bookkeeping__c,Volunteer_Organization__c,Activity_Date_Intranet__c,
                                   Served_on_Board_of_Directors__c,Served_on_a_Sub_Committee__c,Served_on_Loan_Review_Committee__c, duration_hours__c,
                                   Assisted_with_Fundraising__c,Taught_Financial_Education__c,Provided_Technical_Assistance__c,Provided_Workforce_Dev_Assistance__c,Served_on_Committee__c,Organization_Other__c,Board_Service_Details__c,Service_Not_Listed__c
                                   FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Recordtype.name = 'Board/Committee Meeting' and Activity_Year__c = :CurrYear and Organization_Other__c = :SelectedOrgName];
                 if ((CheckActivity ==null) || (CheckActivity.size()==0)) {
                    numberofactivities = 0;
                    if(NewOrgList.size()>0){        
                       ebm.Volunteer_organization__c = NewOrgList[0].Id;
                       ebm.Organization_Other__c = SelectedOrg.Substring(8);
                    }
                 } else {
                    numberofactivities = 1; //Just need something > 0 here. 
                    ebm = CheckActivity[0];
                 }                    
              } else {
                 system.debug('Got Here New Board Activity-- Organization Activity Check. SelectedOrg = ' + SelectedOrg); 
                 CheckActivity  = [SELECT id, name,Volunteer_Organization__r.Name,Provided_HR_IT_or_Legal_Services__c,Contributed_Accounting_or_Bookkeeping__c,Volunteer_Organization__c,Activity_Date_Intranet__c,
                                   Served_on_Board_of_Directors__c,Served_on_a_Sub_Committee__c,Served_on_Loan_Review_Committee__c, duration_hours__c,
                                   Assisted_with_Fundraising__c,Taught_Financial_Education__c,Provided_Technical_Assistance__c,Provided_Workforce_Dev_Assistance__c,Served_on_Committee__c,Organization_Other__c,Board_Service_Details__c,Service_Not_Listed__c
                                   FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Recordtype.name = 'Board/Committee Meeting' and Activity_Year__c = :CurrYear and Volunteer_organization__c = :SelectedOrg];
                 if ((CheckActivity ==null) || (CheckActivity.size()==0)) {
                    ebm.Volunteer_organization__c = SelectedOrg;
                 } else {
                    ebm = CheckActivity[0];
                 }
                 List<Volunteer_Organization__c> volunteerOrgList = [SELECT Id, name FROM Volunteer_Organization__c WHERE id = :SelectedOrg LIMIT 1];
                 SelectedOrgName = volunteerOrgList[0].Name;                                 
              }
           } else {
              system.debug('Got Here New Board Activity-- Organization Activity Check Volunteer Org <> blank. Vol Org = ' + ebm.Volunteer_organization__c);            
              CheckActivity  = [SELECT id, name,Volunteer_Organization__r.Name,Provided_HR_IT_or_Legal_Services__c,Contributed_Accounting_or_Bookkeeping__c,Volunteer_Organization__c,Activity_Date_Intranet__c,
                                Served_on_Board_of_Directors__c,Served_on_a_Sub_Committee__c,Served_on_Loan_Review_Committee__c, duration_hours__c,
                                Assisted_with_Fundraising__c,Taught_Financial_Education__c,Provided_Technical_Assistance__c,Provided_Workforce_Dev_Assistance__c,Served_on_Committee__c,Organization_Other__c,Board_Service_Details__c,Service_Not_Listed__c
                                FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Recordtype.name = 'Board/Committee Meeting' and Activity_Year__c = :CurrYear and Volunteer_organization__c = :ebm.Volunteer_organization__c];
              if ((CheckActivity ==null) || (CheckActivity.size()==0)) {
                 List<Volunteer_Organization__c> volunteerOrgList = [SELECT Id, name FROM Volunteer_Organization__c WHERE id = :ebm.Volunteer_organization__c LIMIT 1];
                 SelectedOrgName = volunteerOrgList[0].Name; 
                 numberofactivities = 0;               
              } else {
                 ebm = CheckActivity[0];
                 SelectedOrgName = CheckActivity[0].Volunteer_Organization__r.Name;   
                 numberofactivities = 1;
              }                           
           }
        } else {
           numberofactivities = 0;        
           if(NewOrgList.size()>0){
              ebm.Volunteer_Organization__c = NewOrgList[0].Id;
              SelectedOrgName = ebm.Organization_Other__c + ' (' + NewOrgList[0].Name +')';               
            //string checkotherorg = ebm.Organization_Other__c.toLowerCase();
              CheckActivity  = [SELECT id, name,Volunteer_Organization__r.Name,Provided_HR_IT_or_Legal_Services__c,Contributed_Accounting_or_Bookkeeping__c,Volunteer_Organization__c,Activity_Date_Intranet__c,
                                Served_on_Board_of_Directors__c,Served_on_a_Sub_Committee__c,Served_on_Loan_Review_Committee__c, duration_hours__c,
                                Assisted_with_Fundraising__c,Taught_Financial_Education__c,Provided_Technical_Assistance__c,Provided_Workforce_Dev_Assistance__c,Served_on_Committee__c,Organization_Other__c,Board_Service_Details__c,Service_Not_Listed__c
                                FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and Recordtype.name = 'Board/Committee Meeting' and Activity_Year__c = :CurrYear and Organization_Other__c = :ebm.organization_other__c];
              if (CheckActivity.size()>0) {
                 ebm = CheckActivity[0];
                 numberofactivities = 1;
              }
           } else {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact Community Development (email communitydevelopment@fnni.com).  New Organization setup not complete.'));
              return null;            
           }
           ebm.Not_Listed__c = true;
        }
        vba = new Volunteer_Board_Activity__c();
        if (EditPage == 'BoardOrganizationList') {
           ShowBack = false;
        } else {
           ShowBack = true;
        }
        return Page.BoardAddition; 
    }    

    public PageReference viewBoardReporting() {
        index=0;
        q=employee.User_Logon_Name__c;
        PageReference pageRef = new PageReference('/apex/boardreporting?q='+employee.User_Logon_Name__c);
        return pageRef;
        return Page.BoardReporting;
    }    
  //DAG_2019_01_22 This procedure is no longer being used.  Leaving it uncommented as it is still called by Visualforce page BoardAddFinish.  That page is no longer in use, 
  //               but don't want to get rid of it yet.
    public PageReference viewBoardAddMore() { 
        index=0;
        ebm= new Volunteer_Activity__c();  
        return Page.BoardAddition; 
    }  
  //DAG_2019_01_22 Same with this procedure.  Leaving it uncommented as it is also still called by Visualforce page BoardAddFinish. 
    public PageReference viewBoardFinish() { 
        index=0; 
        return Page.BoardThankyou;
    }    

    public PageReference viewBoardDelegation() { return Page.BoardDelegation; }   

    public PageReference choose_Organization_page() {
       ebm= new Volunteer_Activity__c();
       integer prev_board_memberships = [select count() from volunteer_activity__c where employee_id__c = :employee.User_Logon_Name__c and Volunteer_Events__c = 'Board/Committee Meeting' and date_and_time__c >= :twoyears_ago];
       if (prev_board_memberships > 0) {
          has_prev_board_memberships = true;
       } else {
          has_prev_board_memberships = false;
       }
       return Page.Board_Choose_Organization; 
    }

  //DAG_2019_01_22 This procedure is no longer being used.
  /*
      public PageReference viewBoardActivity() {
        employee = getEmployee();
        boardMembershipList = getEmployeeBoardMembership();
        if(boardMembershipList.size()==0) { return Page.Board_Choose_Organization; } 
        else { return Page.BoardOrganizationList ;}
    }
  */
    public PageReference addBoardActivity() {
     //DAG 2019_01_22 Major changes to this paragraph.  Change from Employee Board Membership to Volunteer Activity object, and also add upsert of Volunteer Board Activity child object.
       boolean hasvba = true;
       boolean error_flag = false;
       showmessage = true;  //DAG_2019_01_22 indicator if we want to show apex pagemessages on the page.
       string EditPage = apexpages.currentpage().getparameters().get('EditPage');
     //DAG_2019_01_22 Comment out these conditionals, they are no longer being used. 
     /*if (string.ISBLANK( ebm.Volunteer_Organization__c) && string.ISBLANK(ebm.Organization_Other__c) ) {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter an organization name, if not found after searching enter the new organization name in the blank on the right.'));
           return null;
       }    
       if (ebm.Organization_Other__c> '') {
          ebm.Not_Listed__c = true;
       } */
       ebm.Employee_Name_Intranet__c = employee.First_Name__c +' '+ employee.Last_Name__c;
       ebm.Employee_Email_Intranet__c = employee.Email__c;
       ebm.Employee_ID__c =  employee.User_Logon_Name__c;
     //DAG_2019_01_22 New -- Populate Activity Date_and_time__c, set to Jan 1 of current year.  Individual Board activities will have the dates on them.
       ebm.date_and_time__c = CurrYearJan1;
       ebm.date_and_time__c = ebm.date_and_time__c + time_adjust;  //DAG_2019_05_13 Add 6 hours to this field to accommodate how it displays in Salesforce.
       ebm.activity_date_intranet__c = ebm.date_and_time__c.date();  //DAG_2019_05_13 Adding set of this field so it matches the rest of the Volunteer Activities.
     //DAG_2019_01_22 New -- Populating Activity name, record type, and new field Activity Year.  New record type added to Volunteer Activity since we're logging all there now.  Type is Board/Committee Meeting.
       ebm.name = 'Board Hours for ' + date.today().Year();
       ebm.Activity_Year__c = date.today().Year();
       ebm.RecordTypeid = [SELECT Id,SobjectType,Name FROM RecordType WHERE SobjectType='Volunteer_Activity__c' and name = 'Board/Committee Meeting' LIMIT 1].id;
       ebm.Volunteer_Events__c = 'Board/Committee Meeting';
     //DAG_2019_01_22 end.
     //DAG 2019_01_22 New code here for Volunteer Board Activity child record.
       if (vba.name == null && vba.Board_Activity_Date__c == null && vba.duration__c == null && vba.Served_on_Committee__c == null && EditPage == 'BoardAddition') {
          hasvba = false;
       } else {
          showmessage = false;  //DAG_2019_01_22 Showing messages on individual fields, so don't need pagemessage.
          if (vba.name == null) {
             vba.name.addError('Activity Description must be filled in.');
             error_flag = true;
          }
          if (vba.Board_Activity_Date__c == null) {
             vba.Board_Activity_Date__c.addError('Date of Activity must be filled in.');
             error_flag = true;
          } else {
             if (vba.Board_Activity_Date__c < CurrYearJan1 || vba.Board_Activity_Date__c > CurrYearDec31) {
                vba.Board_Activity_Date__c.addError('Activity dates must be in Current Year only');
                error_flag = true;
             }
          }
          if (vba.Duration__c == null) {
             vba.Duration__c.addError('Activity Duration must be filled in.');
             error_flag = true;
          }              
       }
       if (error_flag == true) {
          return null;
       }
       showmessage = true;  //DAG_2019_01_22 Want pagemessage here, though, to show nice comfy confirm messages.
       upsert ebm;
       if (hasvba == true) {
          vba.Volunteer_Activity__c = ebm.id;
          upsert vba;
          if (EditPage == 'BoardAddition') {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'New Activity Added Successfully.'));
          } else {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Board Activity / Nature of Service Updated Successfully.'));
          }
       } else {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Nature of Service Updated Successfully.'));
       }
       vba = new Volunteer_Board_Activity__c();
       numberofactivities = [select count() from Volunteer_Board_Activity__c where Volunteer_Activity__c = :ebm.id];
       has_Curr_Year_board_memberships = true;
       ShowGreeting = false;
       return Page.BoardAddition;
    }

    public PageReference SaveBoardOrganization() {
        update ebm;
        ShowGreeting = false;
        return Page.BoardOrganizationList;
    }

    public PageReference ReturntoOrganizationList() { 
       ShowGreeting = false;
       return Page.BoardOrganizationList;
    }

    public PageReference ReturnToOpen() {
       PageReference page = new pageReference('/boardreporting/Board_vol_open?q='+ employee.User_Logon_Name__c);
       page.setRedirect(true);
       return page;        
    }

  //DAG_2019_01_22 This paragraph no longer is being used.
  /*
    public PageReference viewBoardAddFinish() {
        return Page.BoardAddFinish;
    }
  */
  //DAG_2019_01_22 This paragraph no longer is being used.
  /*
    public PageReference viewBoardActivityForward() {
        ebm.Employee_Name_Intranet__c = employee.First_Name__c +' '+ employee.Last_Name__c;
        ebm.Employee_Email__c = employee.Email__c;
        upsert ebm;
        index+=1;
        boardMembershipList = getEmployeeBoardMembership();
        return index+1>boardMembershipList.size()?Page.BoardAddFinish:Page.BoardActivity;
    }
  */
    public PageReference EditBoardActivity() { 
       string selectedBoardActivity = apexpages.currentpage().getparameters().get('SelectedBoardActivity');
       if (selectedBoardActivity == null || selectedBoardActivity == '') {
          vba = new Volunteer_Board_Activity__c();
          vba.Volunteer_Activity__c = ebm.id;
       } else {
          vba = GetBoardVolActivity(selectedBoardActivity);
       }
     //selectedOrgName = ebm.Volunteer_organization__r.name;
       return Page.BoardActivityEdit;
    }

    public PageReference CancelEditBoardActivity() {
       vba = new Volunteer_Board_Activity__c(); 
       return Page.BoardAddition;
    }

    public PageReference EditBoardOrganization() { 
       string VolOrgID = apexpages.currentpage().getparameters().get('SelectedBoardOrganization');
       ebm = GetVolActivityDetail(VolOrgID);
       if (!string.ISBLANK(ebm.Organization_Other__c) && ebm.Volunteer_Organization__r != null) {
          ebm.Volunteer_Organization__r.name = ebm.Organization_Other__c + '  (' + ebm.Volunteer_Organization__r.name + ') ';
       }
       SelectedOrgName = ebm.Volunteer_Organization__r.name;
       vba = new Volunteer_Board_Activity__c();
       numberofactivities = [select count() from volunteer_board_activity__c where volunteer_activity__c = :ebm.id];
       ShowBack = false;
       return Page.BoardAddition;
     
    }

    public PageReference DeleteBoardActivity() { 
       string VolActID = apexpages.currentpage().getparameters().get('BoardActivityToDelete');
       vba = new Volunteer_Board_Activity__c();
       vba.id = VolActID;
       if (vba.Id != null) {
          delete vba;
          vba = new Volunteer_Board_Activity__c();
       }
       numberofactivities = [select count() from volunteer_board_activity__c where volunteer_activity__c = :ebm.id];
       return Page.BoardAddition;
    }

    public PageReference DeleteBoardOrganization() { 
       string VolOrgID = apexpages.currentpage().getparameters().get('BoardOrganizationToDelete');
       
       ebm.id = VolOrgID;
       if (ebm.Id != null) {
          delete ebm;
       }
       return Page.BoardOrganizationList;
    }

  //DAG_2019_01_22 This paragraph no longer being used.
  /*
    public PageReference viewBoardActivityBack() { 
        if (index>0) {index-=1;}
            ebm.Employee_Name_Intranet__c = employee.First_Name__c +' '+ employee.Last_Name__c;
            ebm.Employee_Email__c = employee.Email__c;
            upsert ebm;
            boardMembershipList = getEmployeeBoardMembership();
        return Page.BoardActivity; 
    } 
  */
  //DAG_2019_01_22 This paragraph no longer being used.
  /*  
     public PageReference noserve() {
        if (ebm.Id != null) {
            delete ebm;
            //index+=1;
        }
        boardMembershipList = getEmployeeBoardMembership();
        return index+1>boardMembershipList.size()?Page.BoardAddFinish:Page.BoardActivity;
    }
  */
  //DAG_2019_01_22 This paragraph no longer being used.
  /*    
    public PageReference viewBoardActivityAdd() { 
        index+=1;
        boardMembershipList = getEmployeeBoardMembership();
        return Page.BoardActivity; 
    }
  */

  //DAG_2019_01_22 This paragraph no longer being used.
  /*      
    public PageReference thankyouBoard()     {
     return Page.BoardThankyou; } 
  */
    public Employee__c getEmployee() {
       if (! string.ISBLANK(q)) {        
            employee = [SELECT id, User_Logon_Name__c, First_Name__c, Last_Name__c, Email__c FROM Employee__c WHERE User_Logon_Name__c =: q limit 1 ];     
        }
        
            return employee;
    }   

    public void setEmployee(Employee__c value) {
        employee = value;    
    }

  //DAG_2019_01_22 New procedure
    public Volunteer_Activity__c GetVolActivityDetail(string VolActID) {
       Volunteer_Activity__c BoardActivityDetail = [SELECT id, name,Volunteer_Organization__r.Name,Provided_HR_IT_or_Legal_Services__c,Contributed_Accounting_or_Bookkeeping__c,Volunteer_Organization__c,Activity_Year__c,
             Served_on_Board_of_Directors__c,Served_on_a_Sub_Committee__c,Served_on_Loan_Review_Committee__c, duration_hours__c,
             Assisted_with_Fundraising__c,Taught_Financial_Education__c,Provided_Technical_Assistance__c,Provided_Workforce_Dev_Assistance__c,Served_on_Committee__c,Organization_Other__c,Board_Service_Details__c,Service_Not_Listed__c, Total_Board_Hours__c
             FROM Volunteer_Activity__c WHERE id = :VolActID];
        
       return BoardActivityDetail; 
    }

  //DAG_2019_01_22 New procedure
    public Volunteer_Board_Activity__c GetBoardVolActivity(string volBoardActID) {
       Volunteer_Board_Activity__c boardVolActivityDetail = [SELECT id, name, Volunteer_Activity__c, Board_Activity_Date__c, Duration__c, Served_on_Committee__c FROM Volunteer_Board_Activity__c WHERE id = :VolBoardActID];
       
       return boardVolActivityDetail; 
    }
        
    public List<Volunteer_Activity__c> getEmployeeBoardMembership() {
            system.debug('Got Here GetEmployeeBoardMembership.  employee: ' + employee.user_logon_name__c);
            Integer CurrYear = date.today().year();  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only. 
            date CurrYearJan1 = date.newInstance(CurrYear, 1, 1);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only. 
            Integer i=0;
            if(employee != null){
            has_prev_board_memberships = true; //DAG_2019_01_22 New variable for new Visualforce page where user is selecting board memberships.  
            boardMembershipList = [SELECT id, name,Volunteer_Organization__r.Name,Provided_HR_IT_or_Legal_Services__c,Contributed_Accounting_or_Bookkeeping__c,Volunteer_Organization__c,Activity_Year__c,
                                       Served_on_Board_of_Directors__c,Served_on_a_Sub_Committee__c,Served_on_Loan_Review_Committee__c, duration_hours__c,
                                       Assisted_with_Fundraising__c,Taught_Financial_Education__c,Provided_Technical_Assistance__c,Provided_Workforce_Dev_Assistance__c,Served_on_Committee__c,Organization_Other__c, Organization_Name__c, Board_Service_Details__c,Service_Not_Listed__c, Total_Board_Hours__c
                                       FROM Volunteer_Activity__c WHERE Employee_ID__c = :employee.User_Logon_Name__c and (Volunteer_Events__c = 'Board/Committee Meeting' or Recordtype.name = 'Board/Committee Meeting') and Activity_Year__c = :CurrYear
                                       order by Organization_Name__c];
            }
            if ((boardMembershipList ==null) || (boardMembershipList.size()==0)) {                    
                 has_prev_board_memberships = false; //DAG_2019_01_22 New variable for new Visualforce page where user is selecting board memberships.              
                 system.debug('Got Here GetEmployeeBoardMembership.  No memberships exist, so adding new one');
                 add= true;
                 forward= false;
                 backward= false;
                 ebm = new Volunteer_Activity__c();                       
            } else if (boardMembershipList.size()>0 && boardMembershipList.size() > index ) {
                 totBoardHoursThisYear = 0; 
                 for (i=0; i < boardMembershipList.size(); i++) {
                     totBoardHoursThisYear += boardMembershipList[i].Total_Board_Hours__c;
                 }
                 if (index==0) { 
                     forward= true;
                     backward= false;
                 } 
                 ebm = boardMembershipList[index];
                 System.debug(ebm.Volunteer_Organization__r+'#ebm#'+ebm);
                 if (!string.ISBLANK(ebm.Organization_Other__c) && ebm.Volunteer_Organization__r != null) {
                    ebm.Volunteer_Organization__r.name = ebm.Organization_Other__c + '  (' + ebm.Volunteer_Organization__r.name + ') ';                   
                 }                            
               organizations = [SELECT Id, Name FROM Volunteer_Organization__c WHERE name =: ebm.Volunteer_Organization__c ];
            }
        
       return boardMembershipList;
    }
    
    public List<Volunteer_Board_Activity__c> getBoardActivityDetails() {
       boardMembershipActivities = [SELECT id, name, Volunteer_Activity__c, Board_Activity_Date__c, Duration__c, Served_on_Committee__c FROM Volunteer_Board_Activity__c WHERE Volunteer_Activity__c = :ebm.id order by board_activity_date__c desc];
       numberofactivities = boardMembershipActivities.size();
       if ((boardMembershipActivities ==null) || (boardMembershipActivities.size()==0)) {
          return null;
       } else {
          return boardMembershipActivities;
       }
    }
       
    //DAG_2019_01_22 New procedure to populate the Dropdown list on the Board_Choose_Organization page. 
    public List<SelectOption> GetPrevBoardMemberships() {
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
       
       boardMembershipDropdown = [SELECT Volunteer_Organization__c, Volunteer_Organization__r.Name, Organization_Other__c from Volunteer_Activity__c where employee_id__c = :employee.User_Logon_Name__c
       and (Volunteer_Events__c = 'Board/Committee Meeting' or Recordtype.name = 'Board/Committee Meeting') and date_and_time__c >= :twoyears_ago];
       
       if (boardMembershipDropdown.size() > 0) {
          has_prev_board_memberships = true;         
          options.add(new SelectOption('', ' '));
          for (Volunteer_Activity__c selectlist : boardMembershipDropdown) {
             if (selectlist.Volunteer_Organization__c == NewOrgId) {
                VolOrgName = selectList.Organization_Other__c;               
                optionset.add(new SelectOption(string.valueof('NewOrg__' + selectList.Organization_Other__c), VolOrgName));
             } else {
                VolOrgName = string.valueof(selectList.Volunteer_Organization__r.Name);
                optionset.add(new SelectOption(string.valueof(selectList.get('Volunteer_Organization__c')), VolOrgName));
             }
          }
          options.addAll(optionset);          
          return options;

       } else {
          has_prev_board_memberships = false;
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