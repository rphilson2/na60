// Author: James McCord
// Date Created / Modified: 09/13/2016
// Project: Employee Salesforce User Review
// Purpose: Test Methods for Testing Classes for Board Reporting
// DAG_2019_01_22 VersionOne Feature E-08549-- Large Modification on this date.  Changed the whole BoardReportingExtension class 
//                from updating the Employee Board Membership object to updating the Volunteer Activity object.  So, made corresponding changes here. 

@istest
public class BoardReportingExtensionTestMethod {
     ApexPages.StandardController sc;
     public static Volunteer_Activity__c ebm = new Volunteer_Activity__c();  //DAG_2019_01_22 Change this from Employee_Board_Membership__c. 
     public static Volunteer_Board_Activity__c vba = new Volunteer_Board_Activity__c();  //DAG_2019_01_22 New child record of Volunteer Activity.
     public static Integer CurrYear = date.today().year();  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only. 
     public static date CurrYearJan1 = date.newInstance(CurrYear, 1, 1);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only.
     public static  ApexPages.StandardController stdebm = new ApexPages.StandardController(ebm);
     public static  BoardReportingExtension be = new BoardReportingExtension(stdebm);     
     public Employee__c employee;
     public static String emp = '1241';
    
     public BoardReportingExtensionTestMethod(ApexPages.StandardController standardController) {
         sc = standardController;
     }
     public static testMethod void BoardReportingControllerTest() {
         BoardReportingController b = new BoardReportingController();
     }
     @TestSetup
    public static void setup() {
        
    }
     @istest
     public static void InitNullTest() {
          be.Init();
          String beInitURL = be.Init().getURL();
          //System.assertEquals('/apex/boarddelegation',beInitURL);
     }

     public static testMethod void InitNotNullTest() {
          Employee__c employee = new Employee__c();
            employee.Cost_Center__c = '100010'; 
            employee.Last_Name__c = 'Mouse';
            employee.First_Name__c = 'Mickey';
            employee.Email__c = 'mmouse@gmail.com';
            employee.User_Logon_Name__c = emp;
          insert employee;     
          apexpages.currentpage().getparameters().put('q' , '1241');
          be.Init();
          //String beInitURL = be.Init().getURL();
          //System.assertEquals('/apex/boarddelegation',beInitURL);
     }

      public static testMethod void QTest() {
        be.q='1241';
        System.assertEquals(be.q,'1241');
      }

      public static testMethod void getQTestWithQ() {
        be.q='339181';
        be.getq();
      //System.assertEquals(CheckEmployee[0].User_Logon_Name__c, '339181');
      }

      public static testMethod void getQTestNoQ() {
        be.q=null;
        be.getq();
      //System.assertEquals(CheckEmployee[0].User_Logon_Name__c, '339181');
      }

      public static testMethod void AddFalseTest() {
        be.add=false;
        System.assertEquals(false,be.add);
      }

      public static testMethod void AddTrueTest() {
        be.add=true;
        System.assertEquals(true,be.add);
      }

      public static testMethod void BackwardFalseTest() {
        be.backward=false;
        System.assertEquals(be.backward,false);
      }

      public static testMethod void BackwardTrueTest() {
        be.backward=true;
        System.assertEquals(be.backward,true);
      }

      public static testMethod void ForwardFalseTest() {
        be.forward=false;
        System.assertEquals(be.forward,false);
      }

      public static testMethod void ForwardTrueTest() {
        be.forward=true;
        System.assertEquals(be.forward,true);
      }

      public static testMethod void AddEbm() {
        be.ebm=ebm;
        System.assertEquals(be.ebm,ebm);
      }

      public static testMethod void delegateBoard() {
       be.q = '1241';
       String delegateURL = be.delegateBoard().getURL();
       //System.assertEquals('/apex/boarddelegation',delegateURL );
      }     

      public static testMethod void delegateBoardEBM() {
       be.q = '1241';
       createEBM();
       String delegateURL = be.delegateBoard().getURL();
       //System.assertEquals('/apex/boardreporting',delegateURL );
      }     
    
 //DAG_2019_01_22 This paragraph no longer being used. 
 /*
    public static testMethod void thankyouBoard() {
       String thankyouURL = be.thankyouBoard().getURL();
       //System.assertEquals('/apex/boardthankyou',thankyouURL);
    }
 */ 
    public static testMethod void viewBoardReporting() {
        be.index = 0;
         Employee__c employee = new Employee__c();
            employee.Cost_Center__c = '100010';
            employee.Last_Name__c = 'Mouse';
            employee.First_Name__c = 'Mickey';
            employee.Email__c = 'mmouse@gmail.com';
            employee.User_Logon_Name__c = '1241';
        insert employee;
        be.employee = employee;
        String BoardReportingURL = be.viewBoardReporting().getURL();
        //System.assertEquals('/apex/boardreporting',BoardReportingURL);
    }
    
    public static testMethod void viewBoardAddMore() {
        integer index = 0;
        String BoardAdditionURL = be.viewBoardAddMore().getURL();
        //System.assertEquals('/apex/boardaddition',BoardAdditionURL);
    }

  //DAG_2019_01_22 This paragraph no longer being used. 
  /*
    public static testMethod void viewBoardAddFinish() {
        integer index = 0;
        be.viewBoardAddFinish();
        String BoardAddFinishURL = be.viewBoardAddFinish().getURL();
        //System.assertEquals('/apex/boardaddfinish',BoardAddFinishURL);
    }
  */
    
    public static testMethod void viewBoardfinish() {
        integer index = 0;
        be.viewBoardFinish();
        String BoardFinishURL = be.viewBoardFinish().getURL();
        //System.assertEquals('/apex/boardthankyou',BoardFinishURL);
    }
    
  //DAG_2019_01_22 This paragraph no longer being used. 
  /*
    public static testMethod void delegateBoardSave() {
        be.index = 0;
        createEBM();
        be.getEmployeeBoardMembership();
        be.delegateBoard_save();
        String BoardAddition = be.viewBoardActivity().getURL();
        //System.assertEquals('/apex/boardactivity',BoardAddition);
    }
  */
  //DAG_2019_01_22 This paragraph no longer being used. 
  /*
    public static testMethod void viewBoardActivityAdd() {
        be.index = 0;
        createEBM();
        be.getEmployeeBoardMembership();
        be.viewBoardActivityAdd();
        String BoardActivity = be.viewBoardActivity().getURL();
        //System.assertEquals('/apex/boardactivity',BoardActivity);
    }
  */
    @istest    
    public static void addBoardActivity() {
        //Assign
        be.index = 0;
        createEBMNoInsert();
        be.CurrYearJan1 = date.newInstance(CurrYear, 1, 1);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only.
        be.CurrYearDec31 = date.newInstance(CurrYear, 12, 31);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only.        
        be.vba.Board_Activity_Date__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
      //Act
        String actual = be.addBoardActivity().getURL();
      //Assert
        System.assertEquals('/apex/boardaddition',actual);                
    }

    public static testMethod void addBoardActivityOtherOrg() {
        be.index = 0;
        createEBMNoInsertOtherOrg();
        be.CurrYearJan1 = date.newInstance(CurrYear, 1, 1);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only.
        be.CurrYearDec31 = date.newInstance(CurrYear, 12, 31);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only.        
        be.vba.Board_Activity_Date__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
      //Act
        String actual = be.addBoardActivity().getURL();
      //Assert
        System.assertEquals('/apex/boardaddition',actual);                
    }

    public static testMethod void addBoardActivityNulls() {
        be.index = 0;
        createEBMNoInsert();
        be.vba.name = null;
        be.vba.board_activity_date__c = null;
        be.vba.Duration__c = null;        
        vba.served_on_committee__c = 'Advisory';
        be.addBoardActivity();
      //String activity = be.addBoardActivity().getURL();
      //System.assertEquals(null,be.addBoardActivity().getURL());                
    }

    public static testMethod void addBoardActivityWrongDate() {
        be.index = 0;
        createEBMNoInsert();
        be.vba.Board_Activity_Date__c = date.newInstance(2018, 12, 02);
        be.addBoardActivity();
      //String activity = be.addBoardActivity().getURL();
    }

    public static testMethod void boardDelegation_Pos() {
        be.index = 0;
        createEBM();
        be.getEmployeeBoardMembership();
        be.viewBoardDelegation();
        String BoardDelegation = be.viewBoardDelegation().getURL();
        System.assertEquals('/apex/boarddelegation',BoardDelegation);
    }
/*
    public static testMethod void boardDelegation_Neg() {
        emp = '1111';
        be.index = 0;
        createEBM();
        be.getEmployeeBoardMembership();
        be.viewBoardDelegation();
        String BoardDelegation = be.viewBoardDelegation().getURL();
        //System.assertEquals('/apex/boarddelegation',BoardDelegation);
    }
*/
      //DAG_2019_01_22 Comment out these two procedure.  The procedure viewboardactivity is no longer being used.
      /*
        public static testMethod void boardActivity_Pos() {
        be.index = 0;
        createEBM();
        be.ebm = ebm;
      //be.getEmployeeBoardMembership();
      //be.viewBoardDelegation();
        String BoardActivity = be.viewBoardActivity().getURL();
        System.assertEquals('/apex/boardorganizationlist',BoardActivity);
    }
    
    public static testMethod void boardActivity_Neg() {
      //emp = '1111';
        be.index = 0;
        createEBM2();
      //be.getEmployeeBoardMembership();
      //be.viewBoardActivity();
        String BoardPage = be.viewBoardActivity().getURL();
        System.assertEquals('/apex/board_choose_organization',BoardPage);
    } 
  */
  //DAG_2019_01_22 This paragraph no longer being used.
  /*
    public static testMethod void noserve_pos() {
        be.index = 0;
        createEBM();
        be.getEmployeeBoardMembership();
        be.noserve();    
        String noserve = be.noserve().getURL();
        System.assertEquals('/apex/boardaddfinish',noserve);
    }
  */
    public static testMethod void getEmployee() {
        apexpages.currentpage().getparameters().put('q' , '1241');
        be.q = '1241';
        String q = ApexPages.currentPage().getParameters().get('q');    
        Employee__c employee = new Employee__c();
            employee.Cost_Center__c = '100010';
            employee.Last_Name__c = 'Mouse';
            employee.First_Name__c = 'Mickey';
            employee.Email__c = 'mmouse@gmail.com';
            employee.User_Logon_Name__c = '1241';
        insert employee;
        employee = [SELECT id, User_Logon_Name__c, First_Name__c, Last_Name__c, Email__c FROM Employee__c WHERE User_Logon_Name__c =: q limit 1 ];     
        be.setEmployee(employee);
        employee = be.getEmployee();
        System.assertEquals(be.employee, employee);        
    }    
    
    public static testMethod void getEmployeeBoardMembership() {
        createEBM();
        be.getEmployeeBoardMembership();
        System.assertEquals(true, be.forward);
        //System.assertEquals(false, be.backward);
    }

    public static testMethod void getEBMNoEBM() {
      //createEBM();
      //Assign
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
      //Act
        be.getEmployeeBoardMembership();
      //Assert
        System.assertEquals(false, be.forward);
    }

    public static testMethod void getEBMBack() {
        be.index = 0;
        createEBM();
        be.getEmployeeBoardMembership();
        //System.assertEquals(true, be.forward);
    }
/*
    public static testMethod void getEBMNoRecords() {
        emp = '1111';
        createEBM();
        be.getEmployeeBoardMembership();
        //System.assertEquals(false, be.forward);
    }
*/
  //DAG_2019_01_22 The method ViewBoardActivityForward no longer exists in the Apex Class, so commenting out this method.    
  /*
    public static testMethod void viewBoardActivityForward() {
        be.index = 0;
        setEmployee();
        createEBM();
        be.getEmployeeBoardMembership();
      //be.viewBoardActivityForward();
        String activityFoward = be.viewBoardActivityForward().getURL();
        System.assertEquals('/apex/boardorganizationlist',activityFoward);        
    }
  */
    public static testMethod void SaveBoardOrganization() {
        be.index = 0;
        setEmployee();
        createEBM();
        be.ebm = ebm;
      //be.getEmployeeBoardMembership();
      //be.viewBoardActivityForward();
        String activityFoward = be.SaveBoardOrganization().getURL();
        System.assertEquals('/apex/boardorganizationlist',activityFoward);        
    }

  //DAG_2019_01_22 The method ViewBoardActivityBack no longer exists in the Apex Class, so commenting out this method.    
  /*
    public static testMethod void viewBoardActivityBack() {
        be.index = 0;
        setEmployee();
        createEBM();
        be.getEmployeeBoardMembership();
        be.viewBoardActivityBack();
        String activityBack = be.viewBoardActivityBack().getURL();
        System.assertEquals('/apex/boardactivity',activityBack);        
        
    }
  */
   @istest
   public static void EditBoardActivity() {
      CreateEBM();
      apexpages.currentpage().getparameters().put('SelectedBoardActivity' , vba.id);
      String EditBoardActivity = be.EditBoardActivity().getURL();
      System.assertEquals('/apex/boardactivityedit',EditBoardActivity);      
   }

   @istest
   public static void EditBoardActivityNoActivity() {
      CreateEBM();
    //apexpages.currentpage().getparameters().put('SelectedBoardActivity' , vba.id);
      be.ebm = ebm;
      String EditBoardActivity = be.EditBoardActivity().getURL();
      System.assertEquals('/apex/boardactivityedit',EditBoardActivity);      
   }

   @istest
   public static void DeleteBoardActivity() {
      CreateEBM();
      be.ebm = ebm;
      apexpages.currentpage().getparameters().put('BoardActivityToDelete' , vba.id);
      String DeleteBoardActivity = be.DeleteBoardActivity().getURL();
      System.assertEquals('/apex/boardaddition',DeleteBoardActivity);      
   }

   @istest
   public static void EditBoardOrganization() {
      CreateEBM();
      apexpages.currentpage().getparameters().put('SelectedBoardOrganization' , ebm.id);
      String EditBoardOrganization = be.EditBoardOrganization().getURL();
      System.assertEquals('/apex/boardaddition',EditBoardOrganization);      
   }

   @istest
   public static void EditBoardOrganizationOtherOrg() {
      CreateEBM3();
      apexpages.currentpage().getparameters().put('SelectedBoardOrganization' , ebm.id);
      String EditBoardOrganization = be.EditBoardOrganization().getURL();
      System.assertEquals('/apex/boardaddition',EditBoardOrganization);      
   }

   @istest
   public static void DeleteBoardOrganization() {
      CreateEBM();
      be.ebm = ebm;
      apexpages.currentpage().getparameters().put('BoardOrganizationToDelete' , ebm.id);
      String DeleteBoardOrganization = be.DeleteBoardOrganization().getURL();
      System.assertEquals('/apex/boardorganizationlist',DeleteBoardOrganization);
   }

   @istest
   public static void ChooseOrganizationAgain() {
      Employee__c employee = new Employee__c();
         employee.Cost_Center__c = '100010'; 
         employee.Last_Name__c = 'Mouse';
         employee.First_Name__c = 'Mickey';
         employee.Email__c = 'mmouse@gmail.com';
         employee.User_Logon_Name__c = emp;
      be.employee = employee;
      String ChooseBoardOrganization = be.choose_Organization_page().getURL();
      System.assertEquals('/apex/board_choose_organization',ChooseBoardOrganization);
   }

   public static testMethod void setEmployee() {
        Employee__c employee = new Employee__c();
            employee.Cost_Center__c = '100010'; 
            employee.Last_Name__c = 'Mouse';
            employee.First_Name__c = 'Mickey';
            employee.Email__c = 'mmouse@gmail.com';
            employee.User_Logon_Name__c = emp;
        insert employee;
        be.setEmployee(employee);
        System.assertEquals(employee,be.employee);
    }

   public static testMethod void NoOrgs() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'New Organization';
        insert organization;
        Employee__c employee = new Employee__c();
            employee.Cost_Center__c = '100010'; 
            employee.Last_Name__c = 'Mouse';
            employee.First_Name__c = 'Mickey';
            employee.Email__c = 'mmouse@gmail.com';
            employee.User_Logon_Name__c = emp;
        insert employee;
        be.setEmployee(employee);
        be.GetPrevBoardMemberships();
        System.assertEquals(false,be.has_prev_board_memberships);
    }

    public static testMethod void createEBMGetPrev() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Food for Life';
        insert organization;
        Volunteer_Organization__c organization2 = new Volunteer_Organization__c();
        organization2.Name = 'New Organization';
        insert organization2;        
        ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        ebm = new Volunteer_Activity__c();  //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
            ebm.Volunteer_Organization__c = org_id;
            list<RecordType> boardrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Board/Committee Meeting' limit 1];
            ebm.Recordtypeid = boardrecordtype[0].id;
            ebm.Date_and_Time__c = Date.newInstance(2018,11,20);
            ebm.Activity_Date_Intranet__c = Date.newInstance(2018,11,20);
            ebm.Provided_HR_IT_or_Legal_Services__c = false;
            ebm.Contributed_Accounting_or_Bookkeeping__c = true;
          //ebm.Board_Appointment_Start_Date_employee__c = Date.newInstance(2008,11,20);
          //ebm.Board_Appointment_End_Date_employee__c = Date.newInstance(2016,01,10);
            ebm.Served_on_Board_of_Directors__c = true;
            ebm.Served_on_a_Sub_Committee__c = true;
            ebm.Served_on_Loan_Review_Committee__c = false;                
            ebm.Assisted_with_Fundraising__c = false;
            ebm.Taught_Financial_Education__c = true;
            ebm.Provided_Technical_Assistance__c = true;
            ebm.Provided_Workforce_Dev_Assistance__c = true;
            ebm.Served_on_Committee__c = 'Governance';  
            ebm.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            ebm.Employee_ID__c = emp;
        insert ebm;
        be.GetPrevBoardMemberships();
        System.assertEquals(true,be.has_prev_board_memberships);        
    }
    @istest
    public static void createEBM() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Food for Life';
        insert organization;
        ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        ebm = new Volunteer_Activity__c();  //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
            ebm.Volunteer_Organization__c = org_id;
            list<RecordType> boardrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Board/Committee Meeting' limit 1];
            ebm.Recordtypeid = boardrecordtype[0].id;
            ebm.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            ebm.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            ebm.Activity_Year__c = date.today().year();
            ebm.Provided_HR_IT_or_Legal_Services__c = false;
            ebm.Contributed_Accounting_or_Bookkeeping__c = true;
          //ebm.Board_Appointment_Start_Date_employee__c = Date.newInstance(2008,11,20);
          //ebm.Board_Appointment_End_Date_employee__c = Date.newInstance(2016,01,10);
            ebm.Served_on_Board_of_Directors__c = true;
            ebm.Served_on_a_Sub_Committee__c = true;
            ebm.Served_on_Loan_Review_Committee__c = false;                
            ebm.Assisted_with_Fundraising__c = false;
            ebm.Taught_Financial_Education__c = true;
            ebm.Provided_Technical_Assistance__c = true;
            ebm.Provided_Workforce_Dev_Assistance__c = true;
            ebm.Served_on_Committee__c = 'Governance';  
            ebm.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            ebm.Employee_ID__c ='1241';
        insert ebm;
      //DAG_2019_01_22 New child record for Volunteer Activity  
        vba = new Volunteer_Board_Activity__c();
            vba.name = 'New Board Activity';
            vba.volunteer_activity__c = ebm.id;
            vba.board_activity_date__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vba.Duration__c = 5;
        insert vba;
            
    }
    public static void createEBMNoInsert() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Food for Life';
        insert organization;
        ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        be.ebm = new Volunteer_Activity__c();  //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
        be.ebm.Volunteer_Organization__c = org_id;
        list<RecordType> boardrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Board/Committee Meeting' limit 1];
        be.ebm.Recordtypeid = boardrecordtype[0].id;
        be.ebm.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
        be.ebm.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
        be.ebm.Provided_HR_IT_or_Legal_Services__c = false;
        be.ebm.Contributed_Accounting_or_Bookkeeping__c = true;
        be.ebm.Served_on_Board_of_Directors__c = true;
        be.ebm.Served_on_a_Sub_Committee__c = true;
        be.ebm.Served_on_Loan_Review_Committee__c = false;                
        be.ebm.Assisted_with_Fundraising__c = false;
        be.ebm.Taught_Financial_Education__c = true;
        be.ebm.Provided_Technical_Assistance__c = true;
        be.ebm.Provided_Workforce_Dev_Assistance__c = true;
        be.ebm.Served_on_Committee__c = 'Governance';  
        be.ebm.Employee_Email_Intranet__c = 'mmouse@gmail.com';
        be.ebm.Employee_ID__c ='1241';
      //insert ebm;
        be.vba = new Volunteer_Board_Activity__c();
        be.vba.name = 'New Board Activity';
          //vba.volunteer_activity__c = ebm.id;
        be.vba.board_activity_date__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
        be.vba.Duration__c = 5;
      //insert vba;       
    }    
    public static void createEBMNoInsertOtherOrg() {
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        be.ebm = new Volunteer_Activity__c();  //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
        be.ebm.Organization_Other__c = 'Tazmanian Devil Spinning School';
        list<RecordType> boardrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Board/Committee Meeting' limit 1];
        be.ebm.Recordtypeid = boardrecordtype[0].id;
        be.ebm.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
        be.ebm.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
        be.ebm.Provided_HR_IT_or_Legal_Services__c = false;
        be.ebm.Contributed_Accounting_or_Bookkeeping__c = true;
        be.ebm.Served_on_Board_of_Directors__c = true;
        be.ebm.Served_on_a_Sub_Committee__c = true;
        be.ebm.Served_on_Loan_Review_Committee__c = false;                
        be.ebm.Assisted_with_Fundraising__c = false;
        be.ebm.Taught_Financial_Education__c = true;
        be.ebm.Provided_Technical_Assistance__c = true;
        be.ebm.Provided_Workforce_Dev_Assistance__c = true;
        be.ebm.Served_on_Committee__c = 'Governance';  
        be.ebm.Employee_Email_Intranet__c = 'taz@gmail.com';
        be.ebm.Employee_ID__c ='1241';
      //insert ebm;
        be.vba = new Volunteer_Board_Activity__c();
        be.vba.name = 'New Board Activity';
        be.vba.board_activity_date__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
        be.vba.Duration__c = 5;
      //insert vba;       
    }    
    public static void createEBMNoInsertNoOrg() {
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        be.ebm = new Volunteer_Activity__c();  //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
        list<RecordType> boardrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Board/Committee Meeting' limit 1];
        be.ebm.Recordtypeid = boardrecordtype[0].id;
        be.ebm.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
        be.ebm.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
        be.ebm.Provided_HR_IT_or_Legal_Services__c = false;
        be.ebm.Contributed_Accounting_or_Bookkeeping__c = true;
        be.ebm.Served_on_Board_of_Directors__c = true;
        be.ebm.Served_on_a_Sub_Committee__c = true;
        be.ebm.Served_on_Loan_Review_Committee__c = false;                
        be.ebm.Assisted_with_Fundraising__c = false;
        be.ebm.Taught_Financial_Education__c = true;
        be.ebm.Provided_Technical_Assistance__c = true;
        be.ebm.Provided_Workforce_Dev_Assistance__c = true;
        be.ebm.Served_on_Committee__c = 'Governance';  
        be.ebm.Employee_Email_Intranet__c = 'taz@gmail.com';
        be.ebm.Employee_ID__c ='1241';
      //insert ebm;
        be.vba = new Volunteer_Board_Activity__c();
        be.vba.name = 'New Board Activity';
        be.vba.board_activity_date__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
        be.vba.Duration__c = 5;
      //insert vba;       
    }    
    
    public static testMethod void createEBM2() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Anita Home';
        insert organization;
        ID org_id = [select id from Volunteer_Organization__c where name = 'Anita Home'].id;   
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Donald',
            First_Name__c = 'Duck',
            Email__c = 'dduck@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        ebm = new Volunteer_Activity__c(); //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
            ebm.Volunteer_Organization__c = org_id;
            ebm.Date_and_Time__c = Date.newInstance(2018,11,20);
            ebm.Provided_HR_IT_or_Legal_Services__c = false;
            ebm.Contributed_Accounting_or_Bookkeeping__c = true;
          //ebm.Board_Appointment_Start_Date_employee__c = Date.newInstance(2008,11,20);
          //ebm.Board_Appointment_End_Date_employee__c = Date.newInstance(2016,01,10);
            ebm.Served_on_Board_of_Directors__c = true;
            ebm.Served_on_a_Sub_Committee__c = true;
            ebm.Served_on_Loan_Review_Committee__c = false;                
            ebm.Assisted_with_Fundraising__c = false;
            ebm.Taught_Financial_Education__c = true;
            ebm.Provided_Technical_Assistance__c = true;
            ebm.Provided_Workforce_Dev_Assistance__c = true;
            ebm.Served_on_Committee__c = 'Governance';  
            ebm.Employee_Email_Intranet__c = 'dduck@gmail.com';
            ebm.Employee_ID__c ='1111';
        insert ebm;
        
        organization = new Volunteer_Organization__c();
        organization.Name = 'Food for Life';
        insert organization;
        org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
        employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        ebm = new Volunteer_Activity__c();  //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
            ebm.Volunteer_Organization__c = org_id;
            ebm.Date_and_Time__c = Date.newInstance(2018,11,20);
            ebm.Provided_HR_IT_or_Legal_Services__c = false;
            ebm.Contributed_Accounting_or_Bookkeeping__c = true;
          //ebm.Board_Appointment_Start_Date_employee__c = Date.newInstance(2008,11,20);
          //ebm.Board_Appointment_End_Date_employee__c = Date.newInstance(2016,01,10);
            ebm.Served_on_Board_of_Directors__c = true;
            ebm.Served_on_a_Sub_Committee__c = true;
            ebm.Served_on_Loan_Review_Committee__c = false;                
            ebm.Assisted_with_Fundraising__c = false;
            ebm.Taught_Financial_Education__c = true;
            ebm.Provided_Technical_Assistance__c = true;
            ebm.Provided_Workforce_Dev_Assistance__c = true;
            ebm.Served_on_Committee__c = 'Governance';  
            ebm.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            ebm.Employee_ID__c ='1241';
        insert ebm;    
    }

        public static testMethod void createEBM3() {        
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Food for Life';
        insert organization;
            
        ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
            Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        ebm = new Volunteer_Activity__c();  //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
            ebm.Date_and_Time__c = Date.newInstance(2018,11,20);
            ebm.Provided_HR_IT_or_Legal_Services__c = false;
            ebm.Contributed_Accounting_or_Bookkeeping__c = true;
          //ebm.Board_Appointment_Start_Date_employee__c = Date.newInstance(2008,11,20);
          //ebm.Board_Appointment_End_Date_employee__c = Date.newInstance(2016,01,10);
            ebm.Served_on_Board_of_Directors__c = true;
            ebm.Served_on_a_Sub_Committee__c = true;
            ebm.Served_on_Loan_Review_Committee__c = false;                
            ebm.Assisted_with_Fundraising__c = false;
            ebm.Taught_Financial_Education__c = true;
            ebm.Provided_Technical_Assistance__c = true;
            ebm.Provided_Workforce_Dev_Assistance__c = true;
            ebm.Served_on_Committee__c = 'Governance';  
            ebm.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            ebm.Employee_ID__c ='1241';
            ebm.Organization_Other__c = 'Growing Sprouts';            
        insert ebm;    
    }
    public static testMethod void createEBMNoOrg() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Anita Home';
        insert organization;
        ID org_id = [select id from Volunteer_Organization__c where name = 'Anita Home'].id;   
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Donald',
            First_Name__c = 'Duck',
            Email__c = 'dduck@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        ebm = new Volunteer_Activity__c(); //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
            ebm.Date_and_Time__c = Date.newInstance(2018,11,20);
            ebm.Provided_HR_IT_or_Legal_Services__c = false;
            ebm.Contributed_Accounting_or_Bookkeeping__c = true;
          //ebm.Board_Appointment_Start_Date_employee__c = Date.newInstance(2008,11,20);
          //ebm.Board_Appointment_End_Date_employee__c = Date.newInstance(2016,01,10);
            ebm.Served_on_Board_of_Directors__c = true;
            ebm.Served_on_a_Sub_Committee__c = true;
            ebm.Served_on_Loan_Review_Committee__c = false;                
            ebm.Assisted_with_Fundraising__c = false;
            ebm.Taught_Financial_Education__c = true;
            ebm.Provided_Technical_Assistance__c = true;
            ebm.Provided_Workforce_Dev_Assistance__c = true;
            ebm.Served_on_Committee__c = 'Governance';  
            ebm.Employee_Email_Intranet__c = 'dduck@gmail.com';
            ebm.Employee_ID__c =emp;
        insert ebm;
     }
     
    public static testMethod void TestCreateNewActivitySelectedOrgNewActivity() {
        //Assign
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Donald',
            First_Name__c = 'Duck',
            Email__c = 'dduck@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Anita Home';
        insert organization;
        be.selectedOrg = organization.id;
        
        List<Volunteer_Activity__c> VolAct = be.getEmployeeBoardMembership();
        string Expected = '/apex/boardaddition';
        //Act
        String Actual = be.New_Board_Activity().getURL();
        
        //Assert
        system.assertEquals(Expected, actual);
    }

   @istest
    public static void ReturnToOrganizationList() {
        string Expected = '/apex/boardorganizationlist';
        String Actual = be.ReturnToOrganizationList().getURL();
        //Assert
        system.assertEquals(Expected, actual);        
    }

/************************************************************************************************
               Test ReturnToOpen
 ************************************************************************************************/
   @istest
   static void test_Return_to_open(){
    //Assign employee
      Employee__c employee = new Employee__c(
      Cost_Center__c = '100010',
      Last_Name__c = 'Mouse',
      First_Name__c = 'Mickey',
      Email__c = 'mmouse@gmail.com',
      User_Logon_Name__c ='SQUID');
      insert employee;
      be.employee = employee;
      be.employee.User_Logon_Name__c = employee.user_logon_name__c;
      string expected = '/boardreporting/Board_vol_open?q=SQUID';
    //Act
      string actual = be.ReturnToOpen().getURL();
    //Assert
      system.assertEquals(Expected, actual);
   }

/***********  End test ReturntoOpen  **************************************************************/
    
   @istest    
    public static void TestCreateNewActivitySelectedOrgNewActivityNewOrg() {
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Donald',
            First_Name__c = 'Duck',
            Email__c = 'dduck@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'New Organization';
        insert organization;
        be.ebm = new Volunteer_Activity__c();
        be.selectedOrg = 'NewOrg__Yosemite Sam Politeness School';
        be.New_Board_Activity();
        system.assertEquals('Yosemite Sam Politeness School', be.SelectedOrgName);
   }
   @isTest
   public static void TestCreateNewActivitySelectedOrgNewActivityExistingOrgNoActivity() {
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Donald',
            First_Name__c = 'Duck',
            Email__c = 'dduck@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Anita Home';
        insert organization;
        be.ebm = new Volunteer_Activity__c();
        be.ebm.Volunteer_Organization__c = organization.id;
        string Expected = '/apex/boardaddition';
        //Act
        String Actual = be.New_Board_Activity().getURL();
        
        //Assert
        system.assertEquals(Expected, actual);       
   }
   @isTest
   public static void TestCreateNewActivitySelectedOrgNewActivityExistingOrgWithActivity() {
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Donald',
            First_Name__c = 'Duck',
            Email__c = 'dduck@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Anita Home';
        insert organization;
        list<RecordType> boardrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Board/Committee Meeting' limit 1];
        ebm.Recordtypeid = boardrecordtype[0].id;
        ebm.Volunteer_Organization__c = organization.id;
        ebm.name = 'Board Hours for 2035';
        ebm.date_and_time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
      //ebm.Activity_Year__c = date.today().year();
        ebm.Provided_HR_IT_or_Legal_Services__c = false;
        ebm.Contributed_Accounting_or_Bookkeeping__c = true;
        ebm.Served_on_Board_of_Directors__c = true;
        ebm.Served_on_a_Sub_Committee__c = true;
        ebm.Served_on_Loan_Review_Committee__c = false;                
        ebm.Assisted_with_Fundraising__c = false;
        ebm.Taught_Financial_Education__c = true;
        ebm.Provided_Technical_Assistance__c = true;
        ebm.Provided_Workforce_Dev_Assistance__c = true;
        ebm.Served_on_Committee__c = 'Governance';  
        ebm.Employee_Email_Intranet__c = 'dduck@gmail.com';
        ebm.Employee_ID__c =emp;
        insert ebm;
        be.ebm = new Volunteer_Activity__c();
        be.ebm.Volunteer_Organization__c = organization.id;
        be.CurrYear = date.today().year();
        string Expected = '/apex/boardaddition';
        //Act
        String Actual = be.New_Board_Activity().getURL();
        
        //Assert
        system.assertEquals(Expected, actual);
       
   }
    
   @istest
   public static void TestCreateNewActivitySelectedOrgNewActivityOtherOrg() {
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Donald',
            First_Name__c = 'Duck',
            Email__c = 'dduck@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        be.setEmployee(employee);
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'New Organization';
        insert organization;
        ebm.Volunteer_Organization__c = organization.id;
        ebm.name = 'Board Hours for 2035';
        ebm.Organization_Other__c = 'Porky Pig Speech School';
        ebm.date_and_time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
        ebm.Provided_HR_IT_or_Legal_Services__c = false;
        ebm.Contributed_Accounting_or_Bookkeeping__c = true;
        ebm.Served_on_Board_of_Directors__c = true;
        ebm.Served_on_a_Sub_Committee__c = true;
        ebm.Served_on_Loan_Review_Committee__c = false;                
        ebm.Assisted_with_Fundraising__c = false;
        ebm.Taught_Financial_Education__c = true;
        ebm.Provided_Technical_Assistance__c = true;
        ebm.Provided_Workforce_Dev_Assistance__c = true;
        ebm.Served_on_Committee__c = 'Governance';  
        ebm.Employee_Email_Intranet__c = 'dduck@gmail.com';
        ebm.Employee_ID__c =emp;
        insert ebm;
        be.ebm = new Volunteer_Activity__c();
        be.ebm.Organization_Other__c = 'Porky Pig Speech School';
        be.CurrYear = date.today().year();       
        string Expected = '/apex/boardaddition';
        //Act
        String Actual = be.New_Board_Activity().getURL();
        
        //Assert
        system.assertEquals(Expected, actual);       
   }  
    
     public static testMethod void TestGetSelectedOrg() {
       be.getSelectedOrg();
     }
     public static testMethod void TestSetSelectedOrg() {
        ebm = new Volunteer_Activity__c(); //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
            ebm.Date_and_Time__c = Date.newInstance(2018,11,20);
            ebm.Provided_HR_IT_or_Legal_Services__c = false;
            ebm.Contributed_Accounting_or_Bookkeeping__c = true;
          //ebm.Board_Appointment_Start_Date_employee__c = Date.newInstance(2008,11,20);
          //ebm.Board_Appointment_End_Date_employee__c = Date.newInstance(2016,01,10);
            ebm.Served_on_Board_of_Directors__c = true;
            ebm.Served_on_a_Sub_Committee__c = true;
            ebm.Served_on_Loan_Review_Committee__c = false;                
            ebm.Assisted_with_Fundraising__c = false;
            ebm.Taught_Financial_Education__c = true;
            ebm.Provided_Technical_Assistance__c = true;
            ebm.Provided_Workforce_Dev_Assistance__c = true;
            ebm.Served_on_Committee__c = 'Governance';  
            ebm.Employee_Email_Intranet__c = 'dduck@gmail.com';
            ebm.Employee_ID__c =emp;
        insert ebm;
       be.setSelectedOrg(ebm.id);
     }
    @istest
    public static void testgetBoardActivityDetails() {
        createEBM();
        be.ebm = new Volunteer_Activity__c();
        be.ebm.id = ebm.id;
        be.getBoardActivityDetails();
        system.assertEquals('New Board Activity', be.boardMembershipActivities[0].name);
    }
         
}