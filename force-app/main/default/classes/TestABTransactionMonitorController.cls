@isTest()
public with sharing class TestABTransactionMonitorController {
    
    @isTest
    private static void test_controller(){
    	
    	ABTransactionMonitorController.nFUSE_Class = 'Transaction_Log';
    	
        ABTransactionMonitorController c = new ABTransactionMonitorController();
        system.assertEquals(true,!String.isBlank(c.callback));
        system.assertEquals(true,String.isBlank(c.namespace));
    	
    }
    
}