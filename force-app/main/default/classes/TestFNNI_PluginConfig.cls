@IsTest
public class TestFNNI_PluginConfig {

    @TestSetup
    private static Void setup(){
        nFUSE.PluginConfigurationManager.PluginConfiguration config = new nFUSE.PluginConfigurationManager.PluginConfiguration();
		config.identifier = null;
		config.key = 'config.key';
		config.displayLabel = 'config.displayLabel';
		config.value = 'config.value';
		config.valueDataType = null;
		config.category = 'config.category';
		config.pluginName = 'config.pluginName';
		config.pluginVersion = 'config.pluginVersion';
		config.isEncrypted = null;
		config.description = 'config.description';
        //nFORCE__System_Properties__c prop = nFUSE.SystemPropertyDataStore.toSystemProperty(config, 'ACME_CREDIT_NAME', 'ACME_PLUGIN_VERSION');
        
        
    }
    
    @isTest
    private static void test(){
        
        Test.startTest();

        Test.stopTest();
    }
}