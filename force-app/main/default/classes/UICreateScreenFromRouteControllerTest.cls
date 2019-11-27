@isTest
private class UICreateScreenFromRouteControllerTest
{  
    @isTest
    static void insertScreensSuccess1()
    {
        nFORCE__Route__c testRoute = createRoute(); 
          
        UICreateScreenFromRouteController cs = new UICreateScreenFromRouteController();
        
        //Inserting Related List Screen Sections
        Test.startTest();
        cs.RecordId = testRoute.Id;
        cs.starting_route = testRoute;          
        cs.screenNameGS  = 'TestScreen1';
        cs.screenDisablePrintGS = FALSE;
        cs.screenShowContextObjectNameGS = FALSE;
        cs.addDataGridScreenSectionsGS = TRUE;
        cs.numberOfDataGridScreenSectionsGS = '2';        
        cs.addRelatedListScreenSectionsGS = TRUE;
        cs.numberOfRelatedListScreenSectionsGS = '2';
        cs.routeRedirect();        
        Test.stopTest();
    }
    
    @isTest
    static void insertScreensSuccess2()
    {
        nFORCE__Route__c testRoute = createRoute(); 
          
        UICreateScreenFromRouteController cs = new UICreateScreenFromRouteController();
        
        //Inserting all Screen Sections without specifying how many
        Test.startTest();
        cs.RecordId = testRoute.Id;
        cs.starting_route = testRoute;        
        cs.screenNameGS  = 'TestScreen1';
        cs.screenDisablePrintGS = FALSE;
        cs.screenShowContextObjectNameGS = FALSE;        
        cs.addDataGridScreenSectionsGS = TRUE;
        cs.numberOfDataGridScreenSectionsGS = '';        
        cs.addRelatedListScreenSectionsGS = TRUE;
        cs.numberOfRelatedListScreenSectionsGS = '';
        cs.insertScreens();
        Test.stopTest();
    }
    
    @isTest
    static void insertScreensSuccess3()
    {
        nFORCE__Route__c testRoute = createRoute(); 
          
        UICreateScreenFromRouteController cs = new UICreateScreenFromRouteController();
        
        //Not supplying the Screen nNme
        Test.startTest();
        cs.RecordId = testRoute.Id;
        cs.starting_route = testRoute;
        cs.screenNameGS  = '';
        cs.screenDisablePrintGS = FALSE;
        cs.screenShowContextObjectNameGS = FALSE; 
        cs.addDataGridScreenSectionsGS = TRUE;
        cs.numberOfDataGridScreenSectionsGS = '';        
        cs.addRelatedListScreenSectionsGS = TRUE;
        cs.numberOfRelatedListScreenSectionsGS = '';               
        cs.insertScreens();
        Test.stopTest();
    }
    
    @isTest
    static void routeRedirectError1()
    {
        nFORCE__Route__c testRoute = createRoute(); 
          
        UICreateScreenFromRouteController cs = new UICreateScreenFromRouteController();
        
        Test.startTest();
        cs.RecordId = testRoute.Id;
        cs.starting_route = testRoute;
        cs.screenNameGS  = '';
        cs.screenDisablePrintGS = FALSE;
        cs.screenShowContextObjectNameGS = FALSE;        
        cs.routeRedirect();
        Test.stopTest();
    }
    
    @isTest
    static void routeRedirectError2()
    {
        nFORCE__Route__c testRoute = createRoute(); 
          
        UICreateScreenFromRouteController cs = new UICreateScreenFromRouteController();
        
        Test.startTest();
        cs.RecordId = testRoute.Id;
        cs.starting_route = testRoute;
        cs.screenNameGS  = 'TestScreen';  
        cs.addDataGridScreenSectionsGS = TRUE;
        cs.numberOfDataGridScreenSectionsGS = '';
        cs.routeRedirect();
        Test.stopTest();
    }
    
    @isTest
    static void routeRedirectError3()
    {
        nFORCE__Route__c testRoute = createRoute(); 
          
        UICreateScreenFromRouteController cs = new UICreateScreenFromRouteController();
        
        Test.startTest();
        cs.RecordId = testRoute.Id;
        cs.starting_route = testRoute;
        cs.screenNameGS  = 'TestScreen';  
        cs.addRelatedListScreenSectionsGS = TRUE;
        cs.numberOfRelatedListScreenSectionsGS = '';
        cs.routeRedirect();
        Test.stopTest();
    }
    
    @isTest
    static void stdControllerCvg()
    {
        nFORCE__Route__c testRoute = createRoute();
        ApexPages.StandardController sc = new ApexPages.StandardController(testRoute);  
          
        UICreateScreenFromRouteController cs = new UICreateScreenFromRouteController(sc);
        
        //Inserting Related List Screen Sections
        Test.startTest();
        //cs.RecordId = testRoute.Id;
        //cs.starting_route = testRoute;          
        cs.screenNameGS  = 'TestScreen1';
        cs.screenDisablePrintGS = FALSE;
        cs.screenShowContextObjectNameGS = FALSE;
        cs.addDataGridScreenSectionsGS = TRUE;
        cs.numberOfDataGridScreenSectionsGS = '2';        
        cs.addRelatedListScreenSectionsGS = TRUE;
        cs.numberOfRelatedListScreenSectionsGS = '2';
        cs.routeRedirect();        
        Test.stopTest();
    }                 

    private static nFORCE__Route__c createRoute()
    {
        nFORCE__Route__c newRoute = new nFORCE__Route__c(Name = 'GenRoute1');
        insert newRoute;
        return newRoute;
    }
}