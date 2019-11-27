@isTest
public class AcctExpNotifPolicyConditionTest  {
    @TestSetup
    private static void setup(){
        
        // Set max_Export value here so that the following test method can access it.  (Custom setting items cannot be accessed in a test method unless
        //   we setup in this @TestSetup section.)
        List<Transaction_Security_Code__c> Transaction_Security_Code = new List<Transaction_Security_Code__c>();
        Transaction_Security_Code__c max_Export = new Transaction_Security_Code__c();
        max_Export.Name = 'maxExport';
        max_Export.Max_Export__c = 250000;
        
        Transaction_Security_Code.add(max_Export);
        
        insert Transaction_Security_Code;
    }
    
    @istest
    public static void testAccountExportPolicyNonAdminMaxRec() {        
        System.test.startTest();
        
        /* Create a map for the event we’re going to build. */
        Map<String, String> eventData = new Map<String, String>();
        
        Integer maxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue()  + 20000;
        String sMaxExport = String.valueOf(maxExport);
        
        eventData.put('NumberOfRecords', sMaxExport);
        
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '00530000004XuCr',                 /* userId Non Admin */
                                                    'Account',                            /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0010n00000g0Lat',                    /* entityId */
                                                    'Report',                             /* resourceType */
                                                    Datetime.newInstance(2018, 8, 22),    /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        AccountExportNotificationPolicyCondition condition = new AccountExportNotificationPolicyCondition();
        //condition.evaluate(e);
        
        System.assertEquals(true, condition.evaluate(e));
        System.Test.stopTest();          
    
    }
    
    @istest
    public static void testAccountExportPolicyNonAdminLessMaxRec() {        
        System.test.startTest();
        
        /* Create a map for the event we’re going to build. */
        Map<String, String> eventData = new Map<String, String>();
        
        Integer lessThanMaxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() - 100;
        String sLessThanMaxExport = String.valueOf(lessThanMaxExport);
        
        eventData.put('NumberOfRecords', sLessThanMaxExport);
        
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '00530000004XuCr',                 /* userId Non Admin */
                                                    'Account',                            /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0010n00000g0Lat',                    /* entityId */
                                                    'Report',                             /* resourceType */
                                                    Datetime.newInstance(2018, 8, 22),    /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        AccountExportNotificationPolicyCondition condition = new AccountExportNotificationPolicyCondition();
        //condition.evaluate(e);
        
        System.assertEquals(false, condition.evaluate(e));
        System.Test.stopTest();          
    
    }  
  
    
    @istest
    public static void testAccountExportPolicyCustomSystemAdmin() {        
        System.test.startTest();
        
        /* Create a map for the event we’re going to build. */
        Map<String, String> eventData = new Map<String, String>();
        
        Integer moreThanMaxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() + 20000;
        String sMoreThanMaxExport = String.valueOf(moreThanMaxExport);
        
        eventData.put('NumberOfRecords', sMoreThanMaxExport);        
        
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '005a000000BPHHy',                 /* userId Custom Admin  */
                                                    'Account',                            /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0010n00000g0Lat',                    /* entityId */
                                                    'Report',                             /* resourceType */
                                                    Datetime.newInstance(2018, 8, 22),    /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        AccountExportNotificationPolicyCondition condition = new AccountExportNotificationPolicyCondition();
        //condition.evaluate(e);
        
        System.assertEquals(false, condition.evaluate(e));
        System.Test.stopTest();          
    
    }
    
    @istest
    public static void testAccountExportPolicyEnterpriseBusinessIntelligence() {        
        System.test.startTest();
        
        /* Create a map for the event we’re going to build. */
        Map<String, String> eventData = new Map<String, String>();
        
        Integer moreThanMaxExport = Transaction_Security_Code__c.getInstance('maxExport').Max_Export__c.intValue() + 20000;
        String sMoreThanMaxExport = String.valueOf(moreThanMaxExport);
        
        eventData.put('NumberOfRecords', sMoreThanMaxExport);        
        
        TxnSecurity.Event e = new TxnSecurity.Event(UserInfo.getOrganizationId(),         /* organizationId */
                                                    '0050c00000DbpewAAB',                 /* userId Enterprise Business Intelligence  */
                                                    'Account',                            /* entityName */
                                                    'DataExport',                         /* action */
                                                    '0010n00000g0Lat',                    /* entityId */
                                                    'Report',                             /* resourceType */
                                                    Datetime.newInstance(2018, 8, 22),    /* timeStamp */
                                                    eventData                             /* data - Map with info about this event. */
                                                    );
        AccountExportNotificationPolicyCondition condition = new AccountExportNotificationPolicyCondition();
        //condition.evaluate(e);
        
        System.assertEquals(false, condition.evaluate(e));
        System.Test.stopTest();          
    
    }
}