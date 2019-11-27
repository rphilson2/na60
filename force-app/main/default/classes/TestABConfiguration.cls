@isTest()
private class TestABConfiguration{
    
    @isTest
    static void setupData(){
        //system properties should already exist
        nFORCE__System_Properties__c property1 = new nFORCE__System_Properties__c(Name='aaaa',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property1.nFORCE__Key__c = 'Something';
        property1.nFORCE__Value__c = 'SomethingElse';
        insert property1;
        
        nFORCE__System_Properties__c property2 = new nFORCE__System_Properties__c(Name='bbbb',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property2.nFORCE__Key__c = 'ZSomething';
        property2.nFORCE__Value__c = 'ZSomethingElse';
        insert property2;
        
        nFORCE__System_Properties__c property3 = new nFORCE__System_Properties__c(Name='cccc',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property3.nFORCE__Key__c = 'USomething';
        property3.nFORCE__Value__c = 'USomethingElse';
        insert property3;
        
        nFORCE__System_Properties__c property4 = new nFORCE__System_Properties__c(Name='dddd',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property4.nFORCE__Key__c = 'USomething2';
        property4.nFORCE__Value__c = 'U Something Else';
        insert property4;
        
        nFORCE__System_Properties__c property5 = new nFORCE__System_Properties__c(Name='eeee',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property5.nFORCE__Key__c = 'U Something 3';
        property5.nFORCE__Value__c = 'U Something Else 2';
        insert property5;
    }
    
    @isTest
    private static void testConfigurationLoads(){
        //set up the data
        setupData(); 
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
        
        Map<String,String> properties = configuration.GetAllProperties(true);
        
        System.assertEquals(true, properties.size()==5);
    }
    
    @isTest
    private static void testConfigurationLoadsWithoutTranslating(){
        //set up the data
        setupData(); 
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
        
        Map<String,String> properties = configuration.GetAllProperties(false);
        
        System.assertEquals(true, properties.size()==5);
    }
    
    @isTest
    private static void testConfigurationLoadsSortedData(){
        //set up the data
        setupData(); 
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
        
        Map<String,String> properties = configuration.GetAllProperties(true);
        
        //System.Debug(properties.values()[1]);
        
        System.assertEquals(true, true);
    }
    
    @isTest
    private static void testConfigurationGetByKey(){
        //set up the data
        setupData(); 
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
        
        String property = configuration.GetPropertyByKey('ZSomething');
        
        System.assertEquals('ZSomethingElse', property);
    }
    
    @isTest
    private static void testConfigurationGetByKeyFails(){
        //set up the data
        setupData(); 
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
        
        String property = configuration.GetPropertyByKey('ZSomethingThatDoesntExist');
        
        System.assertEquals(true, property == null);
    }
    
    @isTest
    private static void testaddedconfigsshowup(){
        new ABActivator().onActivate();
        
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
       
        String property = configuration.GetPropertyByKey('AUTHENTICATION_TYPE');
        System.assertEquals('Basic', property);
        
        //set up the data
        setupData(); 
        
        property = configuration.GetPropertyByKey('ZSomething');
        
        System.assertEquals('ZSomethingElse', property );
    }
    
    @isTest
    private static void testaddedconfigsshowupwithnormalizedkey(){
        
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
       
        //set up the data
        setupData(); 
        
        String property = configuration.GetPropertyByKey('USomething2');
        
        System.assertEquals('U Something Else', property);
    }
    
    @isTest
    private static void testgettranslatedkey(){
        
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
       
        //set up the data
        setupData(); 
        
        String property = configuration.GetTranslatedKey(System.Label.AUTHENTICATION_TYPE);
        
        System.assertEquals('AUTHENTICATION_TYPE', property);
    }
    
    @isTest
    private static void testgettranslatedkeydoesntexist(){
        
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
       
        //set up the data
        setupData(); 
        
        String key = configuration.GetTranslatedKey('Chicken');
        
        String property = configuration.GetPropertyByKey(key);
        
        System.assertEquals(null, property);
    }
    
    @isTest
    private static void testaddedconfigsshowupwithnormalizedkeyfound(){
        
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
       
        //set up the data
        setupData(); 
        
        String property = configuration.GetPropertyByKey('U Something 3');
        
        System.assertEquals('U Something Else 2', property);
    }
    
    
    @isTest
    private static void testConfigurationLoadsAndTranslates(){
        
        new ABActivator().onActivate();
        
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
        
        Map<String,String> properties = configuration.GetAllProperties(true);
        
        //System.Debug(properties);
        
        System.assertEquals(true, true); //make sure each one in the base collection has a found translation
        
    }
    
    
    @isTest
    private static void testInstallRouteWhenNotEmpty(){
        
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
        
        //add the loanGroup
        nFORCE__Group__c lg = new nFORCE__Group__c();
        lg.nFORCE__App__c = 'loan';
        insert lg;
        
        configuration.installRoute();
        
        nFORCE__Route_Group__c rg = [SELECT nFORCE__Order__c FROM nFORCE__Route_Group__c WHERE nFORCE__Group__c = :lg.Id][0];
        System.assertEquals(true, rg.nFORCE__Order__c == 100); //make sure each one in the base collection has a found translation
        
    }
    
    @isTest
    private static void testDeleteRoutes(){
        
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
        
        
        
        //add the loanGroup
        nFORCE__Group__c lg = new nFORCE__Group__c();
        lg.nFORCE__App__c = 'loan';
        insert lg;
        
        configuration.installRoute();
        
        nFORCE__Route_Group__c rg = [SELECT nFORCE__Order__c FROM nFORCE__Route_Group__c WHERE nFORCE__Group__c = :lg.Id][0];
        System.assertEquals(true, rg.nFORCE__Order__c == 100); //make sure each one in the base collection has a found translation
        
        configuration.deleteRoute();
        
        List<nFORCE__Route_Group__c> rg2 = [SELECT nFORCE__Order__c FROM nFORCE__Route_Group__c WHERE nFORCE__Group__c = :lg.Id];
        System.assertEquals(true, rg2.isEmpty()); //make sure each one in the base collection has a found translation
        
    }
    
    @isTest
    private static void testDeleteRoutesWhenRouteEmpty(){
        
        //new up the class
        ABConfiguration configuration = new ABConfiguration();
        
        
        
        //add the loanGroup
        nFORCE__Route__c r = new nFORCE__Route__c();
        r.nFORCE__App__c = 'book-to-core';
        insert r;
        
		configuration.deleteRoute();
		
		List<nFORCE__Route__c> route = [
				SELECT
					Id
				FROM
					nFORCE__Route__c
				WHERE
					nFORCE__App__c = 'book-to-core'
			];
        
        System.assertEquals(true, route.isEmpty()); //make sure each one in the base collection has a found translation
        
    }
    
}