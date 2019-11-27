@isTest
public class OpprtyExportNotifyPolicyCondition_Tests {
    @TestSetup
    private static void setup(){
        
        // Set max_Export value here so that the following test method can access it. 
        List<Transaction_Security_Code__c> Transaction_Security_Code = new List<Transaction_Security_Code__c>();
        Transaction_Security_Code__c max_Export = new Transaction_Security_Code__c();
        max_Export.Name = 'maxExport';
        max_Export.Max_Export__c = 250000;
        
        Transaction_Security_Code.add(max_Export);
        
        insert Transaction_Security_Code;
    }
    
    @istest
    public static void testLeadExportPolicy_NonAdminUser_LessThanMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() - 1;
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '00530000004XuCr',                    /* userId... any Non-Admin user will work just fine */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //User has exported fewer records than maxExport value; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();          
    }
    
    @istest
    public static void testLeadExportPolicy_NonAdminUser_EqualToMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue();
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '00530000004XuCr',                    /* userId... any Non-Admin user will work just fine */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //User has exported records equal to the maxExport value; return condition should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();          
    }

    @istest
    public static void testLeadExportPolicy_NonAdminUser_MoreThanMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() + 1;
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '00530000004XuCr',                    /* userId... any Non-Admin user will work just fine */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //User has exported more records than maxExport value; return condition should be true
        System.assertEquals(true, condition.evaluate(e));   
        System.Test.stopTest();          
    }
    
    @istest
    public static void testLeadExportPolicy_IntegrationUser_LessThanMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() - 1;
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '005a000000COYqX',                    /* userId... Integration User */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //Service Account (aka Integration User) is exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();          
    }
    
    @istest
    public static void testLeadExportPolicy_IntegrationUser_EqualToMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue();
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '005a000000COYqX',                    /* userId... Integration User */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //Service Account (aka Integration User) is exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();          
    }

    @istest
    public static void testLeadExportPolicy_IntegrationUser_MoreThanMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() + 1;
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '005a000000COYqX',                    /* userId... Integration User */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //Service Account (aka Integration User) is exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();           
    }

    @istest
    public static void testLeadExportPolicy_CustomSysAdmin_LessThanMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() - 1;
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '005a000000DDEz1',                    /* userId... Custom Sys Admin */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //Custom Sys Admins are exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();          
    }
    
    @istest
    public static void testLeadExportPolicy_CustomSysAdmin_EqualToMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue();
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '005a000000DDEz1',                    /* userId... Custom Sys Admin */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //Custom Sys Admins are exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();          
    }

    @istest
    public static void testLeadExportPolicy_CustomSysAdmin_MoreThanMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() + 1;
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '005a000000DDEz1',                    /* userId... Custom Sys Admin */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //Custom Sys Admins are exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();           
    }

    @istest
    public static void testLeadExportPolicy_EBISvcAcct_LessThanMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() - 1;
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '0050c00000Dbpew',                    /* userId... Enterprise Business Intelligence */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //EBI Service Account is exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();          
    }
    
    @istest
    public static void testLeadExportPolicy_EBISvcAcct_EqualToMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue();
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '0050c00000Dbpew',                    /* userId... Enterprise Business Intelligence */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //EBI Service Account is exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();          
    }

    @istest
    public static void testLeadExportPolicy_EBISvcAcct_MoreThanMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() + 1;
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '0050c00000Dbpew',                    /* userId... Enterprise Business Intelligence */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //EBI Service Account is exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();           
    }

    @istest
    public static void testLeadExportPolicy_SystemAdmin_LessThanMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() - 1;
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '0050c00000Dc04H',                    /* userId... OktaSvcAct (System Administrator) */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //System Admins are exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();          
    }
    
    @istest
    public static void testLeadExportPolicy_SystemAdmin_EqualToMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue();
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '0050c00000Dc04H',                    /* userId... OktaSvcAct (System Administrator) */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //System Admins are exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();          
    }

    @istest
    public static void testLeadExportPolicy_SystemAdmin_MoreThanMaxRecords() {        
        System.test.startTest();
        
        //a. Create a map for the event data we’re going to build.
        Map<String, String> eventData = new Map<String, String>();
        
        //b. build eventData... number of exported records = maxExport - 1; fewer records than we wish to monitor
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() + 1;
        String sMaxExport = String.valueOf(maxExport);
        eventData.put('NumberOfRecords', sMaxExport);
       
        //c. build the transaction security event
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '0050c00000Dc04H',                    /* userId... OktaSvcAct (System Administrator) */
                                                    'Opportunity',                        /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0060c00001TFWfl',                    /* entityId any Opportunity will suffice */
                                                    'Report',                             /* resourceType */
                                                    System.today(),                       /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        OpportunityExportNotificaPolicyCondition condition = new OpportunityExportNotificaPolicyCondition();
                
        //System Admins are exempt from reporting; return value should be false
        System.assertEquals(false, condition.evaluate(e));  
        System.Test.stopTest();           
    }
}