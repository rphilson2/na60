@istest
    public class Test_VolunteerTrackingExtension {
         ApexPages.StandardController sc;
         public static Volunteer_Activity__c vact = new Volunteer_Activity__c();  
         public static Integer CurrYear = date.today().year(); // Two variables here for restricting board entries to current year only. 
         public static  ApexPages.StandardController stdvact = new ApexPages.StandardController(vact);
         public static  VolunteerTrackingExtension vte = new VolunteerTrackingExtension(stdvact);     
         public Employee__c employee;
         public static String emp = '1241';
        
         public Test_VolunteerTrackingExtension(ApexPages.StandardController standardController) {
             sc = standardController;
         }
         /*
         public static testMethod void BoardReportingControllerTest() {
             BoardReportingController b = new BoardReportingController();
         } */
         @TestSetup
        public static void setup() {
            
        }
         @istest
         public static void InitNullTest() {
              vte.Init();
              String vteInitURL = vte.Init().getURL();
              System.assertEquals('/apex/volunteersignin',vteInitURL);
         }
         
         @istest
         public static void InitNotNullTest() {
              Employee__c employee = new Employee__c();
                employee.Cost_Center__c = '100010'; 
                employee.Last_Name__c = 'Mouse';
                employee.First_Name__c = 'Mickey';
                employee.Email__c = 'mmouse@gmail.com';
                employee.User_Logon_Name__c = emp;
              insert employee;     
              apexpages.currentpage().getparameters().put('q' , '1241');
              vte.Init();
         }
    
         @istest
         public static void signin_Usecase1_User_exists() {
              setEmployee();
              vte.q = emp;
              String signinURL = vte.signin().getURL();
              System.assertEquals('/apex/volunteerreporting',signinURL);
    
        }
    
         @istest
         public static void signin_Usecase2_User_not_exist() {
              setEmployee();
              vte.q = '994994';
              String signinURL = vte.signin().getURL();
              System.assertEquals('/apex/volunteerreporting',signinURL);
    
        }
    
        @istest
        public static void viewVolunterReporting() {
             Employee__c employee = new Employee__c();
                employee.Cost_Center__c = '100010';
                employee.Last_Name__c = 'Mouse';
                employee.First_Name__c = 'Mickey';
                employee.Email__c = 'mmouse@gmail.com';
                employee.User_Logon_Name__c = emp;
            insert employee;
            vte.employee = employee;
            String VolReportingURL = vte.viewVolunteerReporting().getURL();
            System.assertEquals('/apex/VolunteerReporting?q=1241',VolReportingURL);
        }
    
         @istest
         public static void test_viewVolunteerAddMore() {
              apexpages.currentpage().getparameters().put('Market' , 'Omaha');     
              String VolAddMoreURL = vte.VolunteerAddMore().getURL();
              System.assertEquals('/apex/volunteeraddition',VolAddMoreURL);
        }
    
         @istest
         public static void test_viewVolFinish() {
              String VolFinishURL = vte.viewVolFinish().getURL();
              System.assertEquals('/apex/volunteerthankyou',VolFinishURL);
        }
    
         @istest
         public static void test_viewVolSignin() {
              String SignInURL = vte.viewVolunteerSignIn().getURL();
              System.assertEquals('/apex/volunteersignin',SignInURL);
        }
    
        @istest
         public static void test_getemployee() {
              setemployee();
              apexpages.currentpage().getparameters().put('q' , emp);
              Employee__c chkempl = vte.getemployee();
              System.assertEquals(emp,chkempl.user_logon_name__c);
        }
    
         @istest
         public static void test_viewVolActivity() {
              apexpages.currentpage().getparameters().put('q' , emp);
              String ActivityURL = vte.viewVolunteerActivity().getURL();
              System.assertEquals('/apex/volunteeraddition',ActivityURL);
        }
    
         @istest
         public static void test_addVolActivity_allFieldsFilled() {
              createVactAllFilledIn();
              String AddFinishURL = vte.addVolunteerActivity().getURL();
              System.assertEquals('/apex/volunteeraddfinish',AddFinishURL);
        }

         @istest
         public static void test_addVolActivity_NoOrg() {
              createVactNoOrg();
              vte.addVolunteerActivity();
         //Nothing to assert here.  This will return null because of invalid Volunteer_Activity__c data.
        }

         @istest
         public static void test_addVolActivity_BlankData() {
              createVactNoSummary();
              vte.addVolunteerActivity();
         //Nothing to assert here.  This will return null because of invalid Volunteer_Activity__c data.
        }

         @istest
         public static void test_addVolActivity_OtherOrgBlankVolOrg() {
              createVactOtherOrg();
              String AddFinishURL = vte.addVolunteerActivity().getURL();
              System.assertEquals('/apex/volunteeraddfinish',AddFinishURL);
        }

         @istest
         public static void test_addVolActivity_OtherOrgThatExists() {
              createVactOtherOrgthatExists();
              String AddFinishURL = vte.addVolunteerActivity().getURL();
              System.assertEquals('/apex/volunteeraddfinish',AddFinishURL);
        }

         @istest
         public static void test_addVolActivity_OtherOrgAndVolOrg() {
              createVactOtherOrgAndVolOrg();
              String AddFinishURL = vte.addVolunteerActivity().getURL();
              System.assertEquals('/apex/volunteeraddfinish',AddFinishURL);
        }

         @istest
         public static void test_viewVolAddFinish() {
              String AddFinishURL = vte.viewVolunteerAddFinish().getURL();
              System.assertEquals('/apex/volunteeraddfinish',AddFinishURL);
        }

         @istest
         public static void test_getEmployeeActivitiesNoActivities() {
              vte.getEmployeeVolActivities();
         //Nothing to assert here.  This will return null because of no activities created.
        }

         @istest
         public static void test_getEmployeeActivitiesWithActivities() {
         createVactAndInsert();
         Employee__c fillemployee = new Employee__c();
             fillemployee.Cost_Center__c = '100010'; 
             fillemployee.Last_Name__c = 'Mouse';
             fillemployee.First_Name__c = 'Mickey';
             fillemployee.Email__c = 'mmouse@gmail.com';
             fillemployee.User_Logon_Name__c = emp;
         vte.employee = fillemployee;
         vte.index = 0;
         list<Volunteer_Activity__c> volactlist = new list<volunteer_activity__c>();
         volactlist = vte.getEmployeeVolActivities();
                 
        }

         @istest
         public static void test_getEmployeeActivitiesWithActivitiesOtherOrg() {
         createVactAndInsertOtherOrg();
         Employee__c fillemployee = new Employee__c();
             fillemployee.Cost_Center__c = '100010'; 
             fillemployee.Last_Name__c = 'Mouse';
             fillemployee.First_Name__c = 'Mickey';
             fillemployee.Email__c = 'mmouse@gmail.com';
             fillemployee.User_Logon_Name__c = emp;
         vte.employee = fillemployee;
         vte.index = 0;
         list<Volunteer_Activity__c> volactlist = new list<volunteer_activity__c>();
         volactlist = vte.getEmployeeVolActivities();
                 
        }

         @istest
         public static void test_getEmployeeActivitiesWithActivitiesOtherOrgThatExists() {
         createVactAndInsertOtherOrgExists();
         Employee__c fillemployee = new Employee__c();
             fillemployee.Cost_Center__c = '100010'; 
             fillemployee.Last_Name__c = 'Mouse';
             fillemployee.First_Name__c = 'Mickey';
             fillemployee.Email__c = 'mmouse@gmail.com';
             fillemployee.User_Logon_Name__c = emp;
         vte.employee = fillemployee;
         vte.index = 0;
         list<Volunteer_Activity__c> volactlist = new list<volunteer_activity__c>();
         volactlist = vte.getEmployeeVolActivities();
                 
        }

        @istest
        public static void setEmployee() {
            Employee__c employee = new Employee__c();
                employee.Cost_Center__c = '100010'; 
                employee.Last_Name__c = 'Mouse';
                employee.First_Name__c = 'Mickey';
                employee.Email__c = 'mmouse@gmail.com';
                employee.User_Logon_Name__c = emp;
            insert employee;
            vte.setEmployee(employee);
        }
    
        @istest
        public static void createVactAllFilledIn() {
            Volunteer_Organization__c organization = new Volunteer_Organization__c();
            organization.Name = 'Food for Life';
            insert organization;
            ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
            setemployee();
            vte.vact = new Volunteer_Activity__c();  //DAG_2019_01_22 Change this from Employee_Board_Membership__c.
            vte.vact.Volunteer_Organization__c = org_id;
            list<RecordType> iarecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vte.vact.Recordtypeid = iarecordtype[0].id;
            vte.vact.Employee_Market__c = 'Omaha';
            vte.vact.name = 'Helped with Food Drive';
            vte.vact.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Volunteer_Events__c = 'Animal Services';
            vte.vact.Duration_hours__c = 4;
            vte.vact.Sessions__c = 1;
            vte.vact.Event_Summary__c = 'Did a lot of heavy lifting';
            vte.vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vte.vact.Employee_ID__c =emp;
        }    

        @istest
        public static void createVactNoOrg() {
            setemployee();
            vte.vact = new Volunteer_Activity__c();
            vte.vact.volunteer_organization__c = null;
            vte.vact.organization_other__c = '';
            list<RecordType> iarecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vte.vact.Recordtypeid = iarecordtype[0].id;
            vte.vact.Employee_Market__c = 'Omaha';
            vte.vact.name = 'Helped with Food Drive';
            vte.vact.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Volunteer_Events__c = 'Animal Services';
            vte.vact.Duration_hours__c = 4;
            vte.vact.Sessions__c = 1;
            vte.vact.Event_Summary__c = 'Did a lot of heavy lifting';
            vte.vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vte.vact.Employee_ID__c =emp;
        }    

        @istest
        public static void createVactNoSummary() {
            Volunteer_Organization__c organization = new Volunteer_Organization__c();
            organization.Name = 'Food for Life';
            insert organization;
            ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
            setemployee();
            vte.vact = new Volunteer_Activity__c();
            vte.vact.Volunteer_Organization__c = org_id;
            vte.vact.organization_other__c = '';
            list<RecordType> iarecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vte.vact.Recordtypeid = iarecordtype[0].id;
            vte.vact.Employee_Market__c = 'Omaha';
            vte.vact.name = '';
            vte.vact.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Volunteer_Events__c = 'Animal Services';
            vte.vact.Duration_hours__c = 4;
            vte.vact.Sessions__c = 1;
            vte.vact.Event_Summary__c = null;
            vte.vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vte.vact.Employee_ID__c =emp;
        }    
        
        @istest
        public static void createVactOtherOrg() {
            Volunteer_Organization__c organization = new Volunteer_Organization__c();
            organization.Name = 'Food for Life';
            insert organization;
            Volunteer_Organization__c new_organization = new Volunteer_Organization__c();
            new_organization.Name = 'New Organization';
            insert new_organization;
            ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
            setemployee();
            vte.vact = new Volunteer_Activity__c();
            vte.vact.organization_other__c = 'Yosemite Sam Politeness School';
            list<RecordType> iarecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vte.vact.Recordtypeid = iarecordtype[0].id;
            vte.vact.Employee_Market__c = 'Omaha';
            vte.vact.name = 'Helped with Food Drive';
            vte.vact.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Volunteer_Events__c = 'Animal Services';
            vte.vact.Duration_hours__c = 4;
            vte.vact.Sessions__c = 1;
            vte.vact.Event_Summary__c = 'Did a lot of heavy lifting';
            vte.vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vte.vact.Employee_ID__c =emp;
        }    
        
        @istest
        public static void createVactOtherOrgThatExists() {
            Volunteer_Organization__c organization = new Volunteer_Organization__c();
            organization.Name = 'Food for Life';
            insert organization;
            ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
            setemployee();
            vte.vact = new Volunteer_Activity__c();
            vte.vact.organization_other__c = 'Food For Life';
            list<RecordType> iarecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vte.vact.Recordtypeid = iarecordtype[0].id;
            vte.vact.Employee_Market__c = 'Omaha';
            vte.vact.name = 'Helped with Food Drive';
            vte.vact.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Volunteer_Events__c = 'Animal Services';
            vte.vact.Duration_hours__c = 4;
            vte.vact.Sessions__c = 1;
            vte.vact.Event_Summary__c = 'Did a lot of heavy lifting';
            vte.vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vte.vact.Employee_ID__c =emp;
        }    

        @istest
        public static void createVactOtherOrgAndVolOrg() {
            Volunteer_Organization__c organization = new Volunteer_Organization__c();
            organization.Name = 'Food for Life';
            insert organization;
            Volunteer_Organization__c new_organization = new Volunteer_Organization__c();
            new_organization.Name = 'New Organization';
            insert new_organization;
            ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
            setemployee();
            vte.vact = new Volunteer_Activity__c();
            vte.vact.organization_other__c = 'Yosemite Sam Politeness School';
            list<RecordType> iarecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vte.vact.Recordtypeid = iarecordtype[0].id;
            vte.vact.Employee_Market__c = 'Omaha';
            vte.vact.name = 'Helped with Food Drive';
            vte.vact.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vte.vact.Volunteer_Events__c = 'Animal Services';
            vte.vact.Duration_hours__c = 4;
            vte.vact.Sessions__c = 1;
            vte.vact.Event_Summary__c = 'Did a lot of heavy lifting';
            vte.vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vte.vact.Employee_ID__c =emp;
        }    

        @istest
        public static void createVactAndInsert() {
            Volunteer_Organization__c organization = new Volunteer_Organization__c();
            organization.Name = 'Food for Life';
            insert organization;
            ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life'].id;   
            setemployee();
            vact = new Volunteer_Activity__c();
            vact.Volunteer_Organization__c = org_id;
            list<RecordType> iarecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vact.Recordtypeid = iarecordtype[0].id;
            vact.Employee_Market__c = 'Omaha';
            vact.name = 'Helped with Food Drive';
            vact.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vact.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vact.Volunteer_Events__c = 'Animal Services';
            vact.Duration_hours__c = 4;
            vact.Sessions__c = 1;
            vact.Event_Summary__c = 'Did a lot of heavy lifting';
            vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vact.Employee_ID__c =emp;
            insert vact;
        }    

        @istest
        public static void createVactAndInsertOtherOrg() {
            Volunteer_Organization__c organization = new Volunteer_Organization__c();
            organization.Name = 'New Organization';
            insert organization;
            ID org_id = [select id from Volunteer_Organization__c where name = 'New Organization'].id;   
            setemployee();
            vact = new Volunteer_Activity__c();
            vact.Organization_Other__c = 'Yosemite Sam Politeness School';
            list<RecordType> iarecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vact.Recordtypeid = iarecordtype[0].id;
            vact.Employee_Market__c = 'Omaha';
            vact.name = 'Helped with Food Drive';
            vact.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vact.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vact.Volunteer_Events__c = 'Animal Services';
            vact.Duration_hours__c = 4;
            vact.Sessions__c = 1;
            vact.Event_Summary__c = 'Did a lot of heavy lifting';
            vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vact.Employee_ID__c =emp;
            insert vact;
        }
        @istest
        public static void createVactAndInsertOtherOrgExists() {
            Volunteer_Organization__c organization = new Volunteer_Organization__c();
            organization.Name = 'New Organization';
            insert organization;
            ID org_id = [select id from Volunteer_Organization__c where name = 'New Organization'].id;   
            Volunteer_Organization__c existing_organization = new Volunteer_Organization__c();
            existing_organization.Name = 'Yosemite Sam Politeness School';
            insert existing_organization;            
            setemployee();
            vact = new Volunteer_Activity__c();
            vact.Organization_Other__c = 'Yosemite Sam Politeness School';
            list<RecordType> iarecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vact.Recordtypeid = iarecordtype[0].id;
            vact.Employee_Market__c = 'Omaha';
            vact.name = 'Helped with Food Drive';
            vact.Date_and_Time__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vact.Activity_Date_Intranet__c = date.newInstance(date.today().year(), date.today().month(), date.today().day());
            vact.Volunteer_Events__c = 'Animal Services';
            vact.Duration_hours__c = 4;
            vact.Sessions__c = 1;
            vact.Event_Summary__c = 'Did a lot of heavy lifting';
            vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vact.Employee_ID__c =emp;
            insert vact;
        }            
        
    }