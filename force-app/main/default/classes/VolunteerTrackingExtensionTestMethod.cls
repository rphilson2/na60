@istest
public class VolunteerTrackingExtensionTestMethod {
     ApexPages.StandardController sc;
     public static Volunteer_Activity__c vact = new Volunteer_Activity__c();  //DAG_2019_08_22 Change this from Employee_Board_Membership__c. 
     public static Integer CurrYear = date.today().year();  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only. 
     public static date CurrYearJan1 = date.newInstance(CurrYear, 1, 1);  //DAG_2019_01_22 Two new variables here for restricting board entries to current year only.
     public static ApexPages.StandardController stdvact = new ApexPages.StandardController(vact);
     public static VolunteerTrackingExtension vte = new VolunteerTrackingExtension(stdvact);     
     public Employee__c employee;
     public static String emp = '1241';
    
     public VolunteerTrackingExtensionTestMethod(ApexPages.StandardController standardController) {
         sc = standardController;
     }

/****************    Setup  ***********************************************************************************/     
    @testSetup
    static void setupTestData(){
        test.starttest();
        //volunteer organization with name
       Volunteer_Organization__c organization = new Volunteer_Organization__c(Name = 'Food for Life');
                       insert organization;
        //volunteer Activity
        Volunteer_Activity__c  Vd = new Volunteer_Activity__c();
        Vd.Volunteer_Organization__c=organization.id;
        Vd.employee_market__c='Colorado';
        Vd.Volunteer_Events__c='Field Trips';
        Vd.Activity_Date_Intranet__c=Date.Today();
        Vd.Date_and_Time__c=DateTime.Now();
        Vd.Number_of_FNB_Employees_Involved__c = 3;
        Vd.Sessions__c = 1;
        Vd.Number_of_Participants__c = 55;
        Vd.Activity_Focus_Area__c = 'Athletics – Sports organizations';
        Vd.Duration_hours__c=60;
        Vd.Event_Summary__c='Test Details';
        insert Vd;
       //Employee creation
            Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c ='test data');
            insert employee;
        
        test.stoptest();
        
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
      vte.employee = employee;
      vte.employee.User_Logon_Name__c = employee.user_logon_name__c;
      string expected = '/volunteer/Board_vol_open?q=SQUID';
    //Act
      string actual = vte.ReturnToOpen().getURL();
    //Assert
      system.assertEquals(Expected, actual);
   }

/***********  End test ReturntoOpen  **************************************************************/


/************************************************************************************************
               Test Signin
 ************************************************************************************************/

   @istest
   static void test_Signin_no_q(){
    //Assign
      string Expected = '/apex/volunteersignin';
    //Act
      String Actual = vte.signin().getURL();
    //Assert-- nothing to assert here-- returns null

   }

/***********  End test Signin  ******************************************************************/


/************************************************************************************************
               Test ReturnToSignin
 ************************************************************************************************/

   @istest
   static void test_Return_to_signin() {
    //Assign
      string expected = '/apex/volunteersignin';
    //Act
      string actual = vte.viewVolunteerSignIn().getURL();
    //Assert
      system.assertEquals(Expected, actual);
   }

/***************  end test ReturntoSignin  ***********************************************************************/


/*****************************************************************************************************************
                 Test Init
 *****************************************************************************************************************/
   @istest
   static void test_Init_UseCase1_no_q(){
    //Assign
      string Expected = '/apex/volunteersignin';
    //Act
      String Actual = vte.init().getURL();
    //Assert
      system.assertequals(expected, actual);

   }
   
    @istest 
    static void test_Init_UseCase2_bad_q(){
     //Assign
     //createEmployeeStandalone();
       PageReference pageRef = Page.VolunteerSignIn,VolunteerReporting,VolunteerAddition,VolunteerActivityEdit;      
       pageRef.getParameters().put('q','squid');
       Test.setCurrentPage(pageRef);
       string Expected = '/apex/volunteersignin';
    //Act      
       String Actual = vte.init().getURL();
    //Assert
       system.assertequals(expected, actual);
    }        

    @istest 
    static void test_Init_UseCase3_good_q_no_activities(){
     //Assign
       createEmployeeStandalone();
       PageReference pageRef = Page.VolunteerSignIn,VolunteerReporting,VolunteerAddition,VolunteerActivityEdit;
       pageRef.getParameters().put('q',emp);
       Test.setCurrentPage(pageRef);
       string Expected = '/apex/volunteerorganizationlist';
     //Act      
       String Actual = vte.init().getURL();
     //Assert
       system.assertequals(expected, actual);
    }

    @istest 
    static void test_Init_UseCase4_good_q_with_activities(){
     //Assign
       createNewVactExistingOrg();
       PageReference pageRef = Page.VolunteerSignIn,VolunteerReporting,VolunteerAddition,VolunteerActivityEdit;
       pageRef.getParameters().put('q',emp);
       Test.setCurrentPage(pageRef);
       string Expected = '/apex/volunteerorganizationlist';
     //Act  
       String Actual = vte.init().getURL();
     //Assert
       system.assertequals(expected, actual);
    }        
/**************  End Test Init  **************************************************************************************************/


/**********************************************************************************************************************************
                 Testing New_Volunteer_Activity method
***********************************************************************************************************************************/
   
   @istest
    public static void TestCreateNewActivityExistingOrg() {
     //Assign
       createEmployeeStandAlone();
        
       Volunteer_Organization__c organization = new Volunteer_Organization__c();
       organization.Name = 'Anita Home';
       insert organization;
       vte.selectedOrg = organization.id;
       string Expected = '/apex/volunteeraddition';

     //Act
       String Actual = vte.New_Volunteer_Activity().getURL();
     
     //Assert
       system.assertEquals(Expected, actual);
    }

   @istest    
    public static void TestCreateNewActivityNewOrg() {
     //Assign
       createEmployeeStandAlone();
       Volunteer_Organization__c organization = new Volunteer_Organization__c();
       organization.Name = 'New Organization';
       insert organization;
       vte.vact = new Volunteer_Activity__c();
       vte.selectedOrg = 'NewOrg__Yosemite Sam Politeness School';
     //Act
       vte.New_Volunteer_Activity();
     //Assert
       system.assertEquals('Yosemite Sam Politeness School', vte.SelectedOrgName);
   }

   @istest    
    public static void TestCreateNewActivityNoOrg() {
     //Assign
       createEmployeeStandAlone();
       vte.vact = new Volunteer_Activity__c();
     //Act
       vte.New_Volunteer_Activity();
     //Assert-- Nothing to assert here.  Nothing set in code in this case. 
   }

   @istest
   public static void TestCreateNewActivitySelectedOrgNewActivity() {
    //Assign
      createEmployeeStandAlone();        
      Volunteer_Organization__c organization = new Volunteer_Organization__c();
      organization.Name = 'Anita Home';
      insert organization;
      vte.selectedOrg = organization.id;
        
      string Expected = '/apex/volunteeraddition';
    //Act
      String Actual = vte.New_Volunteer_Activity().getURL();
        
    //Assert
      system.assertEquals(Expected, actual);
   }

   @istest    
   public static void TestCreateNewActivitySelectedOrgNewActivityNewOrg_NewOrgRowNotThere() {
    //Assign
      createEmployeeStandAlone();   
      vte.vact = new Volunteer_Activity__c();
      vte.selectedOrg = 'NewOrg__Yosemite Sam Politeness School';
    //Act
      vte.New_Volunteer_Activity();
    //Assert-- Nothing to assert-- nothing set in code and nothing returned.
   }

   @istest    
   public static void TestCreateNewActivitySelectedOrgNewActivityNewOrg() {
    //Assign
      createEmployeeStandAlone();   
      Volunteer_Organization__c organization = new Volunteer_Organization__c();
      organization.Name = 'New Organization';
      insert organization;
      vte.vact = new Volunteer_Activity__c();
      vte.selectedOrg = 'NewOrg__Yosemite Sam Politeness School';
    //Act
      vte.New_Volunteer_Activity();
    //Assert
      system.assertEquals('Yosemite Sam Politeness School', vte.SelectedOrgName);
   }

   @isTest
   public static void TestCreateNewActivitySelectedOrgNewActivityExistingOrgWithActivity() {
    //Assign
      createEmployeeStandAlone();   
      Volunteer_Organization__c organization = new Volunteer_Organization__c();
      organization.Name = 'Anita Home';
      insert organization;
      Volunteer_Activity__c exvact = new Volunteer_Activity__c(
           Volunteer_Organization__c = organization.id,
           employee_id__c = emp,
           Name = 'Speak Clearly Championship',
           Employee_Market__c = 'Omaha',
           date_and_time__c = system.now(),
           volunteer_events__c = 'Animal Services',
           duration_hours__c = 4,
           sessions__c = 2,
           event_summary__c = 'Did some of this and some of that'
      );
      insert exvact;
      vte.vact = new Volunteer_Activity__c();
      vte.vact.Volunteer_Organization__c = organization.id;
      string Expected = '/apex/volunteeraddition';
    //Act
      String Actual = vte.New_Volunteer_Activity().getURL();
    //Assert
      system.assertEquals(Expected, actual);       
   }
   
   @isTest
   public static void TestCreateNewActivitySelectedOrgNewActivityExistingOrgNoActivity() {
    //Assign
      Employee__c employee = new Employee__c(
         Cost_Center__c = '100010',
         Last_Name__c = 'Donald',
         First_Name__c = 'Duck',
         Email__c = 'dduck@gmail.com',
         User_Logon_Name__c = emp);
      insert employee;
      vte.setEmployee(employee);
      Volunteer_Organization__c organization = new Volunteer_Organization__c();
      organization.Name = 'Anita Home';
      insert organization;
      vte.vact = new Volunteer_Activity__c();
      vte.vact.Volunteer_Organization__c = organization.id;
      string Expected = '/apex/volunteeraddition';
    //Act
      String Actual = vte.New_Volunteer_Activity().getURL();
    //Assert
      system.assertEquals(Expected, actual);       
   }
    
   @istest
   public static void TestCreateNewActivitySelectedOrgNewActivityOtherOrg() {
      //Assign Employee
        createEmployeeStandAlone();   
      //Assign Organization
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'New Organization';
        insert organization;
        vte.vact = new Volunteer_Activity__c();
        vte.vact.Organization_Other__c = 'Porky Pig Speech School';
        string Expected = '/apex/volunteeraddition';
        //Act
        String Actual = vte.New_Volunteer_Activity().getURL();
        
        //Assert
        system.assertEquals(Expected, actual);       
   }

/*********************   End test New_Volunteer_Activity  *********************************************************/


/*******************************************************************************************************************
                             test getEmployee
 *******************************************************************************************************************/
   @istest
   static void test_getEmployee(){
    //Assign
      createEmployeeStandAlone();
      PageReference pageRef = Page.VolunteerSignIn,VolunteerReporting,VolunteerAddition,VolunteerActivityEdit;      
      pageRef.getParameters().put('q',emp);
      string expected = emp;
    //Act
      String actual = vte.getemployee().user_logon_name__c;
    //Assert
      system.assertequals(expected, actual);
   }

/*******************    end test getEmployee   ************************************************************************/


/***********************************************************************************************************************
               Testing choose_Organization_Page
************************************************************************************************************************/

   @istest
   public static void ChooseOrganizationPage_No_Activities() {
    //Assign
      createEmployeeStandalone();
    //Act
      String ChooseVolOrganization = vte.choose_Organization_page().getURL();
    //Assert
      System.assertEquals('/apex/vol_choose_organization',ChooseVolOrganization);
   }

   @istest
   public static void ChooseOrganizationPage_Has_Activities() {
      createNewVactExistingOrg();
      String ChooseVolOrganization = vte.choose_Organization_page().getURL();
      System.assertEquals('/apex/vol_choose_organization',ChooseVolOrganization);
   }

/*******************    end test choose_Organization_Page   ************************************************************/

 
/***********************************************************************************************************************
               Testing addVolunteerActivity
************************************************************************************************************************/
      
   @istest      
    static void test_addVolunteerActivity_Allfieldsfilledin(){
      //Assign Employee
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Donald',
            First_Name__c = 'Duck',
            Email__c = 'dduck@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        vte.setEmployee(employee);
      //Assign Organization
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'New Organization';
        insert organization;
      //Assign Volunteer Activity
        Volunteer_Activity__c vact = new volunteer_activity__c(
           Volunteer_Organization__c = organization.id,
           Name = 'Speak Clearly Championship',
           Employee_Market__c = 'Omaha',
           activity_date_intranet__c = date.today(),
           Number_of_FNB_Employees_Involved__c = 3, 
           volunteer_events__c = 'Animal Services',
           duration_hours__c = 4,
           sessions__c = 2,
           Number_of_Participants__c = 5,
           Activity_Focus_Area__c = 'Educated workforce – Colleges and Universities',
           event_summary__c = 'Did some of this and some of that'          
           );
        vte.vact = vact;
        string expected = '/apex/volunteeraddition';
      //Act
        string actual = vte.addVolunteerActivity().getURL();
      //Assert
        system.assertEquals(Expected, actual);       
    }

   @istest      
    static void test_addVolunteerActivity_Allfieldsfilledin_ActivityNotInThisYear(){
      //Assign Employee
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Donald',
            First_Name__c = 'Duck',
            Email__c = 'dduck@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        vte.setEmployee(employee);
      //Assign Organization
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'New Organization';
        insert organization;
      //Assign Volunteer Activity
        Volunteer_Activity__c vact = new volunteer_activity__c(
           Volunteer_Organization__c = organization.id,
           Name = 'Speak Clearly Championship',
           Employee_Market__c = 'Omaha',
           activity_date_intranet__c = date.today().Addmonths(-14),
           Number_of_FNB_Employees_Involved__c = 3, 
           volunteer_events__c = 'Animal Services',
           duration_hours__c = 4,
           sessions__c = 2,
           Number_of_Participants__c = 5,
           Activity_Focus_Area__c = 'Educated workforce – Colleges and Universities',
           event_summary__c = 'Did some of this and some of that'          
           );
        vte.vact = vact;
        string expected = '/apex/volunteeraddition';
      //Act
        vte.addVolunteerActivity();
      //Assert-- returns null so cannot assert
    }
    
   @istest      
    static void test_addVolunteerActivity_Nofieldsfilledin(){
      //Assign Employee
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Donald',
            First_Name__c = 'Duck',
            Email__c = 'dduck@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        vte.setEmployee(employee);
      //Assign Organization
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'New Organization';
        insert organization;
      //Assign Volunteer Activity
        Volunteer_Activity__c vact = new volunteer_activity__c(
           Volunteer_Organization__c = organization.id
           );
        vte.vact = vact;
        vte.addVolunteerActivity();
    }

/***********************   End Test addVolunteerActivity   ****************************************************************/


/**************************************************************************************************************************
                          Test returnToOrganizationList
 **************************************************************************************************************************/
   @istest
    public static void ReturnToOrganizationListDoesHaveActivities() {
      //Assign
        createNewVactExistingOrg();  //Creating an activity-- this method also creates an employee, which is needed here. 
        string Expected = '/apex/volunteerorganizationlist';
      //Act
        String Actual = vte.ReturnToOrganizationList().getURL();
      //Assert
        system.assertEquals(Expected, actual);        
    }

   @istest
    public static void ReturnToOrganizationListDoesNotHaveActivities() {
      //Assign
        createEmployeeStandalone();  //Creating an employee but no activities-- this method also creates an employee, which is needed here. 
        string Expected = '/apex/volunteerorganizationlist';
      //Act
        String Actual = vte.ReturnToOrganizationList().getURL();
      //Assert
        system.assertEquals(Expected, actual);        
    }

/******************    end test returnToOrganizationList   ******************************************************************/


/*****************************************************************************************************************************
                           Test deleteVolunteerActivity
 *****************************************************************************************************************************/    
   @istest
   public static void DeleteVolunteerActivityHasMoreThanOneExisingOrg() {
    //Assign
      CreateNewVactExistingOrg();
      vte.vact = vact;
      apexpages.currentpage().getparameters().put('VolunteerActivityToDelete', '2^' + vact.id);
    //Act
      vte.DeleteVolunteerActivity();
    //Assert
      System.assertEquals(true, vte.has_Vol_Activities_For_This_Org);      
   }

   @istest
   public static void DeleteVolunteerActivityHasOnlyOne() {
    //Assign
      CreateNewVactExistingOrg();
      vte.vact = vact;
      apexpages.currentpage().getparameters().put('VolunteerActivityToDelete', '1^' + vact.id);
    //Act
      vte.DeleteVolunteerActivity();
    //Assert
      System.assertEquals(false, vte.has_Vol_Activities_For_This_Org);      
   }

   @istest
   public static void DeleteVolunteerActivityHasMoreThanOneNewOrg() {
    //Assign
      CreateNewVactNewOrg();
      vte.vact = vact;
      apexpages.currentpage().getparameters().put('VolunteerActivityToDelete', '2^' + vact.id);
    //Act
      vte.DeleteVolunteerActivity();
    //Assert
      System.assertEquals(true, vte.has_Vol_Activities_For_This_Org);      
   }

/**********************  End test deleteVolunteerActivity   **************************************************************************/


/********************************************************************************************************************************
                         test deleteAllActivitiesForOrganization
 ********************************************************************************************************************************/

   @istest
   public static void deleteAllActivitiesForOrganization_ExistingOrg_HasOnlyOneOrg() {
    //Assign
      CreateNewVactExistingOrg();
      vte.vact = vact;
      apexpages.currentpage().getparameters().put('VolActAndNumActivities', '1^' + vact.id);
    //Act
      vte.deleteAllActivitiesForOrganization();
    //Assert
      System.assertEquals(false, vte.has_prev_vol_activities);      
   }

   @istest
   public static void deleteAllActivitiesForOrganization_NewOrg_HasOnlyOneOrg() {
    //Assign
      CreateNewVactNewOrg();
      vte.vact = vact;
      apexpages.currentpage().getparameters().put('VolActAndNumActivities', '1^' + vact.id);
    //Act
      vte.deleteAllActivitiesForOrganization();
    //Assert
      System.assertEquals(false, vte.has_prev_vol_activities);      
   }

   @istest
   public static void deleteAllActivitiesForOrganization_ExistingOrg_HasMoreThanOneOrg() {
    //Assign
      CreateNewVactExistingOrg();
      vte.vact = vact;
      apexpages.currentpage().getparameters().put('VolActAndNumActivities', '2^' + vact.id);
    //Act
      vte.deleteAllActivitiesForOrganization();
    //Assert
      System.assertEquals(true, vte.has_prev_vol_activities);      
   }

/*********************  end test deleteAllActivitiesForOrganization   ***********************************************************/


/********************************************************************************************************************************
                         test editVolunteerActivity
 ********************************************************************************************************************************/

   @istest
   public static void EditVolunteerActivityExistingOrg() {
    //Assign
      CreateNewVactExistingOrg();
      apexpages.currentpage().getparameters().put('SelectedVolunteerActivity' , vact.id);
    //Act
      String EditVolunteerActivity = vte.EditVolunteerActivity().getURL();
    //Assert
      System.assertEquals('/apex/volunteeractivityedit',EditVolunteerActivity);      
   }

   @istest
   public static void EditVolunteerActivityNewOrg() {
    //Assign
      createNewVactNewOrg();
      apexpages.currentpage().getparameters().put('SelectedVolunteerActivity' , vact.id);
    //Act
      String EditVolunteerActivity = vte.EditVolunteerActivity().getURL();
    //Assert
      System.assertEquals('/apex/volunteeractivityedit',EditVolunteerActivity);      
   }

/**********************  end test editVolunteerActivity   ****************************************************/


/*************************************************************************************************************
                    test cancelEditVolunteerActivity
 *************************************************************************************************************/
 /*
   @istest
   public static void CancelEditVolunteerActivity() {
    //Assign Expected
      string Expected = '/apex/volunteeraddition';
    //Act
      string Actual = vte.CancelEditVolunteerActivity().getURL();
    //Assert
      System.assertEquals(Expected, Actual);      
   }
  */
/**************  end test cancelEditVolunteerActivity  ********************************************************/


/**************************************************************************************************************
                 test editVolunteerOrganization
 **************************************************************************************************************/
   @istest
   public static void EditVolunteerOrganizationExistingOrg() {
    //Assign
      CreateNewVactExistingOrg();
      apexpages.currentpage().getparameters().put('SelectedVolActID' , vact.id);
      string Expected = '/apex/volunteeraddition';
    //Act
      String Actual = vte.EditVolunteerOrganization().getURL();
    //Assert
      System.assertEquals(Expected, Actual);
   }

   @istest
   public static void EditVolunteerOrganizationNewOrg() {
    //Assign
      CreateNewVactNewOrg();
      apexpages.currentpage().getparameters().put('SelectedVolActID' , vact.id);
      string Expected = '/apex/volunteeraddition';
    //Act
      String Actual = vte.EditVolunteerOrganization().getURL();
    //Assert
      System.assertEquals(Expected, Actual);
   }

   @istest
   public static void EditVolunteerOrganizationNewOrgWithParens() {
    //Assign
      CreateNewVactNewOrg();
      apexpages.currentpage().getparameters().put('SelectedVolActID' , vact.id);
      string Expected = '/apex/volunteeraddition';
    //Act
      String Actual = vte.EditVolunteerOrganization().getURL();
    //Assert
      System.assertEquals(Expected, Actual);
   }

   @istest
   public static void EditVolunteerOrganizationBlankID() {
    //Assign
      apexpages.currentpage().getparameters().put('SelectedVolActID' , ' ');
      string Expected = '/apex/volunteeraddition';
      vte.EditVolunteerOrganization();
    //Returns null, so nothing to assert here.
   }

/***********************    end test editVolunteerOrganization   *********************************************/


/***************************************************************************************************************
                     test getEmployeeVolOrgs
 ***************************************************************************************************************/
   @istest    
   public static void getEmployeeVolOrgsHasOrgs() {
   //Assign
     createNewVactExistingOrg();
     createNewVactNewOrg();
     list<volunteer_activity__c> volorglist = [select id, name, date_and_time__c, employee_id__c from volunteer_activity__c]; 
   //Act
     vte.getEmpVolOrgsThisYear();
   //Assert
     System.assertEquals(true, vte.has_prev_vol_activities);      
     
   }

   @istest    
   public static void getEmployeeVolOrgsDoesNotHaveOrgs() {
   //Assign-- just create employee-- no Volunteer Activities
     createEmployeeStandAlone();
   //Act
     vte.getEmpVolOrgsThisYear();
   //Assert
     System.assertEquals(false, vte.has_prev_vol_activities);      
     
   }

   @istest    
   public static void getEmployeeVolOrgsEmployeeHasOneDec31LastYear() {
   //Assign-- create a volunteer activity with Date of Dec 31 of last year.  Make sure this one does NOT show up in list. 
     createNewVactExistingOrg_LastYearDec31();
     list<volunteer_activity__c> volorglist = [select id, name, date_and_time__c, employee_id__c from volunteer_activity__c]; 
   //Act
     vte.getEmpVolOrgsThisYear();
   //Assert
     System.assertEquals(false, vte.has_prev_vol_activities);      
   }
   
/*******************   end test getEmployeeVolOrgs   *************************************************************/


/*****************************************************************************************************************
                         test getEmployeeVolActivitiesForOrganizationThisYear
 *****************************************************************************************************************/

   @istest    
   public static void getEmployeeActvitiesForOneVolOrgExistingOrg() {
   //Assign-- just create employee-- no Volunteer Activities
     createNewVactExistingOrg();
     vte.vact = vact;
   //string selectedorgname = vact.Volunteer_Organization__r.Name;
   //Act
     vte.getEmployeeVolActivitiesForOrganizationThisYear();
   //Assert
     System.assertEquals('Shelf Restocking', vte.employeeVolActivities[0].volActivityName);      
   }

   @istest    
   public static void getEmployeeActvitiesForOneVolOrgNewOrg() {
   //Assign-- just create employee-- no Volunteer Activities
     createNewVactNewOrg();
     vte.vact = vact;
   //string selectedorgname = vact.Organization_Other__c;
   //Act
     vte.getEmployeeVolActivitiesForOrganizationThisYear();
   //Assert
     System.assertEquals('Stutter-A-Thon', vte.employeeVolActivities[0].volActivityName);      
     
   }
/***********************   end test getEmployeeVolActivitiesForOrganizationThisYear *********************************************************/


/********************************************************************************************************************************************
                          test getPrevVolActivities
 ********************************************************************************************************************************************/
 
   @istest    
   public static void NoOrgs() {
      //Assign
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
        vte.setEmployee(employee);
      //Act
        vte.GetPrevVolActivities();
      //Assert
        System.assertEquals(false,vte.has_prev_vol_activities);
    }

   @istest    
   public static void NoOrgs_NewOrgNotSetup() {
      //Assign
        Employee__c employee = new Employee__c();
            employee.Cost_Center__c = '100010'; 
            employee.Last_Name__c = 'Mouse';
            employee.First_Name__c = 'Mickey';
            employee.Email__c = 'mmouse@gmail.com';
            employee.User_Logon_Name__c = emp;
        insert employee;
        vte.setEmployee(employee);
      //Act
        vte.GetPrevVolActivities();
      //Assert-- Nothing to assert, code returns null
              
    }

    @istest
    public static void createVolGetPrev() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Food for Life';
        insert organization;
        Volunteer_Organization__c organization2 = new Volunteer_Organization__c();
        organization2.Name = 'New Organization';
        insert organization2;        
        ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life' limit 1].id;   
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        vte.setEmployee(employee);
 
        vact = new Volunteer_Activity__c();  //DAG_2019_08_22 New Routine for populating new page.
            vact.Volunteer_Organization__c = org_id;
            list<RecordType> Volrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vact.Recordtypeid = volrecordtype[0].id;
            vact.Date_and_Time__c = system.now().addmonths(-14);
            vact.Activity_Date_Intranet__c = date.today().Addmonths(-14);
            vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vact.Employee_Market__c = 'Omaha';
            vact.Volunteer_Events__c ='Business Assistance';
            vact.Duration_hours__c = 12;
            vact.Sessions__c = 2;
            vact.Event_Summary__c = 'Did some of this, and some of that';            
            vact.Employee_ID__c = emp;
        insert vact;

        vte.GetPrevVolActivities();
        System.assertEquals(true,vte.has_prev_vol_activities);        
    }


/*******************  end test getPrevVolActivities    ***********************************************************************/


/*****************************************************************************************************************************
                 test getSelectedOrg
 *****************************************************************************************************************************/

   @istest    
   public static void test_getSelectedOrg() {
   //Assign-- Nothing to assign
   //Act
     vte.getSelectedOrg();
   //Assert-- Nothing To assert
     
   }

/*******************  end test getSelectedOrg    ***********************************************************************/


/*****************************************************************************************************************************
                 test setSelectedOrg
 *****************************************************************************************************************************/

   @istest    
   public static void test_setSelectedOrg() {
   //Assign
     string Test_SelectedOrg = 'Yosemite Sam Politeness School';
   //Act
     vte.setSelectedOrg(Test_SelectedOrg);
   //Assert-- Nothing To assert
     
   }

/*******************  end test setSelectedOrg    ***********************************************************************/


/*****************************************************************************************************************************
                 test setup methods
 *****************************************************************************************************************************/

    @istest
    public static void createEmployeeStandalone() {
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Leghorn',
            First_Name__c = 'FogHorn',
            Email__c = 'fogleg@squid.com',
            User_Logon_Name__c = emp);
        insert employee;
        vte.setEmployee(employee);
    }

    @istest
    public static void createVolGetPrev_NewOrg() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Food for Life';
        insert organization;
        Volunteer_Organization__c organization2 = new Volunteer_Organization__c();
        organization2.Name = 'New Organization';
        insert organization2;        
        ID org_id = [select id from Volunteer_Organization__c where name = 'New Organization' limit 1].id;   
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        vte.setEmployee(employee);
 
        vact = new Volunteer_Activity__c();  //DAG_2019_08_22 New Routine for populating new page.
            vact.Volunteer_Organization__c = org_id;
            list<RecordType> Volrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vact.Recordtypeid = volrecordtype[0].id;
            vact.Date_and_Time__c = system.now().addmonths(-14);
            vact.Activity_Date_Intranet__c = date.today().Addmonths(-14);
            vact.Employee_Email_Intranet__c = 'mmouse@gmail.com';
            vact.Employee_Market__c = 'Omaha';
            vact.Volunteer_Events__c ='Business Assistance';
            vact.Duration_hours__c = 12;
            vact.Sessions__c = 2;
            vact.Event_Summary__c = 'Did some of this, and some of that';            
            vact.Employee_ID__c = emp;
        insert vact;

        vte.GetPrevVolActivities();
        System.assertEquals(true,vte.has_prev_vol_activities);        
    }


    @istest
    public static void createNewVactExistingOrg() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Food for Life';
        insert organization;
        ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life' limit 1].id;   
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        vte.setEmployee(employee);
        vact = new Volunteer_Activity__c();  //DAG_2019_08_22 New Routine for populating new page.
            vact.Volunteer_Organization__c = org_id;
            vact.Name = 'Shelf Restocking';
            list<RecordType> Volrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vact.Recordtypeid = volrecordtype[0].id;
            vact.Date_and_Time__c = system.now();
            vact.Activity_Date_Intranet__c = date.today();
            vact.Number_of_FNB_Employees_Involved__c = 2;
            vact.Employee_Market__c = 'Omaha';
            vact.Activity_Focus_Area__c = 'Athletics – Sports organizations';
            vact.Volunteer_Events__c ='Business Assistance';
            vact.Duration_hours__c = 12;
            vact.Sessions__c = 2;
            vact.Event_Summary__c = 'Did some of this, and some of that';            
            vact.Employee_ID__c = emp;
        insert vact;
            
    }

    @istest
    public static void createNewVactExistingOrg_LastYearDec31() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'Food for Life';
        insert organization;
        ID org_id = [select id from Volunteer_Organization__c where name = 'Food for Life' limit 1].id;   
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        vte.setEmployee(employee);
        vact = new Volunteer_Activity__c();  //DAG_2019_08_22 New Routine for populating new page.
            vact.Volunteer_Organization__c = org_id;
            vact.Name = 'Shelf Restocking';
            list<RecordType> Volrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vact.Recordtypeid = volrecordtype[0].id;
            vact.Date_and_Time__c = CurrYearJan1 - 1;
            vact.Activity_Date_Intranet__c = date.today();
            vact.Number_of_FNB_Employees_Involved__c = 2;
            vact.Employee_Market__c = 'Omaha';
            vact.Activity_Focus_Area__c = 'Athletics – Sports organizations';
            vact.Volunteer_Events__c ='Business Assistance';
            vact.Duration_hours__c = 12;
            vact.Sessions__c = 2;
            vact.Event_Summary__c = 'Did some of this, and some of that';            
            vact.Employee_ID__c = emp;
        insert vact;
            
    }

    @istest
    public static void createNewVactNewOrg() {
        Volunteer_Organization__c organization = new Volunteer_Organization__c();
        organization.Name = 'New Organization';
        insert organization;
        ID org_id = [select id from Volunteer_Organization__c where name = 'New Organization' limit 1].id;   
        Employee__c employee = new Employee__c(
            Cost_Center__c = '100010',
            Last_Name__c = 'Mouse',
            First_Name__c = 'Mickey',
            Email__c = 'mmouse@gmail.com',
            User_Logon_Name__c = emp);
        insert employee;
        vte.setEmployee(employee);
        vact = new Volunteer_Activity__c();  //DAG_2019_08_22 New Routine for populating new page.
            vact.Volunteer_Organization__c = org_id;
            vact.Organization_Other__c = 'Porky Pig Speech School';
            vact.Name = 'Stutter-A-Thon';
            list<RecordType> Volrecordtype = [select id from recordtype where sobjecttype = 'Volunteer_Activity__c' and name = 'Intranet Activity Record' limit 1];
            vact.Recordtypeid = volrecordtype[0].id;
            vact.Date_and_Time__c = system.now();
            vact.Activity_Date_Intranet__c = date.today();
            vact.Number_of_FNB_Employees_Involved__c = 2;
            vact.Number_of_Participants__c = 5;
            vact.Employee_Market__c = 'Omaha';
            vact.Activity_Focus_Area__c = 'Athletics – Sports organizations';
            vact.Volunteer_Events__c ='Business Assistance';
            vact.Duration_hours__c = 12;
            vact.Sessions__c = 2;
            vact.Event_Summary__c = 'Did some of this, and some of that';            
            vact.Employee_ID__c = emp;
        insert vact;
            
    }      
}