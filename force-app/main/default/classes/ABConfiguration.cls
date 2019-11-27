public without sharing class ABConfiguration implements IABConfiguration {
    
    @testVisible
    private static Map<String,String> ConfigurationProperties;
	@testVisible
	private nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
	
	
    static {
    	
    	ConfigurationProperties = new Map<String,String>();
    	
    	//anything added to the configuration properties that is not listed here will only have the key set in the db utilized
    	//use this to override the keys to a more friendly version
    	//usage = ConfigurationProperties.put([LABEL NAME HERE],'[WHAT YOU WANT IT TO SHOW UP AS IN THE MESSAGE HERE]');
    	ConfigurationProperties.put(System.Label.LOAN_RENEWAL_ONBOARDING_URL,'LOAN_RENEWAL_ONBOARDING_URL');
    	ConfigurationProperties.put(System.Label.LOAN_MODIFICATION_ONBOARDING_URL,'LOAN_MODIFICATION_ONBOARDING_URL');
    	ConfigurationProperties.put(System.Label.LOAN_RESERVATION_ONBOARDING_URL,'LOAN_RESERVATION_ONBOARDING_URL');
    	ConfigurationProperties.put(System.Label.LOAN_ONBOARDING_URL,'LOAN_ONBOARDING_URL');
    	ConfigurationProperties.put(System.Label.CUSTOMER_ONBOARDING_URL,'CUSTOMER_ONBOARDING_URL');
    	ConfigurationProperties.put(System.Label.DEPOSIT_ONBOARDING_URL,'DEPOSIT_ONBOARDING_URL');
    	ConfigurationProperties.put(System.Label.BASIC_AUTH_USERNAME,'BASIC_AUTH_USERNAME');
    	ConfigurationProperties.put(System.Label.BASIC_AUTH_PASSWORD,'BASIC_AUTH_PASSWORD');
    	ConfigurationProperties.put(System.Label.AUTHENTICATION_TYPE,'AUTHENTICATION_TYPE');
    	
    	
    	
    	ConfigurationProperties.put(System.Label.ENABLE_RESERVE_LOAN_BUTTON,'ENABLE_RESERVE_LOAN_BUTTON');
    	ConfigurationProperties.put(System.Label.EXT_APP_ID,'EXT_APP_ID');
    	ConfigurationProperties.put(System.Label.LOAN_PROP_KEY,'LOAN_PROP_KEY');
    	ConfigurationProperties.put(System.Label.USE_ASYNCHRONOUS_REQUESTS,'USE_ASYNCHRONOUS_REQUESTS');
    	
    	
    	ConfigurationProperties.put(System.Label.EXT_CUST_ID,'EXT_CUST_ID');
    	ConfigurationProperties.put(System.Label.EXT_DEP_ID,'EXT_DEP_ID');
    	
    }
    
    public void LoadPluginConfigurations() {
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new List<nFUSE.PluginConfigurationManager.PluginConfiguration> {};
		
		
		//insert your configurations here - be sure to use labels so that multilanguage can be supported
		//usage = configs.add(this.CreateConfig([LABEL NAME HERE], '[DEFAULT VALUE HERE]', '[SUPPORTED DATA TYPE HERE]', [BOOLEAN FOR ENCRYPTED FLAG]));
		configs.add(this.CreateConfig(System.Label.LOAN_MODIFICATION_ONBOARDING_URL, '', 'String', false));
		configs.add(this.CreateConfig(System.Label.LOAN_RENEWAL_ONBOARDING_URL, '', 'String', false));
		
		configs.add(this.CreateConfig(System.Label.LOAN_RESERVATION_ONBOARDING_URL, '', 'String', false));
		configs.add(this.CreateConfig(System.Label.LOAN_ONBOARDING_URL, '', 'String', false));
		configs.add(this.CreateConfig(System.Label.CUSTOMER_ONBOARDING_URL, '', 'String', false));
		configs.add(this.CreateConfig(System.Label.DEPOSIT_ONBOARDING_URL, '', 'String', false));
		configs.add(this.CreateConfig(System.Label.BASIC_AUTH_USERNAME, null, 'String', true));
		configs.add(this.CreateConfig(System.Label.BASIC_AUTH_PASSWORD, null, 'String', true));
		configs.add(this.CreateConfig(System.Label.AUTHENTICATION_TYPE, 'Basic', 'String', false));
		
		
		configs.add(this.CreateConfig(System.Label.ENABLE_RESERVE_LOAN_BUTTON, 'true', 'String', false));
		configs.add(this.CreateConfig(System.Label.USE_ASYNCHRONOUS_REQUESTS, 'true', 'String', false));
		configs.add(this.CreateConfig(System.Label.LOAN_PROP_KEY, 'LoanId', 'String', false));
		configs.add(this.CreateConfig(System.Label.EXT_APP_ID, 'LoanNumber', 'String', false));
		
		
		configs.add(this.CreateConfig(System.Label.EXT_CUST_ID, 'BookedCustomerNumber', 'String', false));
		configs.add(this.CreateConfig(System.Label.EXT_DEP_ID, 'BookedDepositNumber', 'String', false));
		
		
		// for(nFUSE.PluginConfigurationManager.PluginConfiguration item : configs){
  //      	system.debug('item='+item.key+',value='+item.value);
  //      }
		
		new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).softInsertConfigurations(configs);
		
	}

    
    public void TogglePluginConfigurations(Boolean state){
        List<nFORCE__System_Properties__c> props = [
			SELECT
				Id
			FROM
				nFORCE__System_Properties__c
			WHERE
				nFORCE__Category_Name__c = :PLUGIN_CATEGORY_NAME
		];
		if (props.size() > 0) {
			for(nFORCE__System_Properties__c p : props){
				p.nFORCE__Is_Active__c = state;
				nFORCE.DmlUtility.updateObj(p);
			}
		}
		
		
		if(!state){
			//deregister triggers, deregister services, uninstall routes
			deregisterTriggers();
			deregisterServices();
			deleteRoute();
		}else{
			//register triggers, register services, install routes
			registerTriggers();
			registerServices();
			installRoute();
		}
		
		
    }
    
    @testVisible
    private void installRoute() {
		List<nFORCE__Group__c> loanGroup = [
			SELECT
				Id
			FROM
				nFORCE__Group__c
			WHERE
				nFORCE__App__c = 'loan'
		];
		if (!loanGroup.isEmpty()) {
			nFORCE__Route__c route = new nFORCE__Route__c(
				Name = Label.AB_Book_To_Core,
				nFORCE__App__c = 'book-to-core',
				nFORCE__Topbar__c = 'nFORCE__Topbar',
				nFORCE__Body__c = 'c__EnhancedLoanAutomatedBooking',
				nFORCE__Navigation__c = 'nFORCE__Navigation',
				nFORCE__Sub_Navigation__c = 'nFORCE__Sub_Navigation',
				nFORCE__lookupKey__c = ABUtility.GetSimpleGuid()
			);

			nFORCE__Route_Group__c routeGroup = new nFORCE__Route_Group__c(
				nFORCE__Group__c = loanGroup[0].Id,
				nFORCE__Route__r = new nFORCE__Route__c(nFORCE__lookupKey__c = route.nFORCE__lookupKey__c),
				nFORCE__Order__c = 100
			);

			nFORCE.DmlUtility.insertObj(new List<SObject>{(SObject) route, (SObject) routeGroup});
		}
	}

	@testVisible
    private void deleteRoute() {
		List<SObject> toDelete = new List<SObject>();
		List<nFORCE__Route_Group__c> bookToCoreRouteGroup = [
			SELECT
				Id,
				nFORCE__Route__r.Id
			FROM
				nFORCE__Route_Group__c
			WHERE
				nFORCE__Route__r.nFORCE__App__c = 'book-to-core'
		];
		if (!bookToCoreRouteGroup.isEmpty()) {
			toDelete.add((SObject) bookToCoreRouteGroup[0]);
			toDelete.add((SObject) bookToCoreRouteGroup[0].nFORCE__Route__r);
		} else {
			List<nFORCE__Route__c> route = [
				SELECT
					Id
				FROM
					nFORCE__Route__c
				WHERE
					nFORCE__App__c = 'book-to-core'
			];
			if(!route.isEmpty()){
				toDelete.add((SObject) route[0]);
			}
		}
		nFORCE.DmlUtility.deleteObj(toDelete);
	}
	
    @testVisible
    private void registerServices() {
		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		locator.register(request, nFUSE.SendService.class, ABLoanReserveSendService.class, LOANRESERVESENDSERVICENAME);
		locator.register(request, nFUSE.SendService.class, ABLoanSendService.class, LOANSENDSERVICENAME);
		locator.register(request, nFUSE.SendService.class, ABCustomerSendService.class, CUSTOMERSENDSERVICENAME);
		locator.register(request, nFUSE.SendService.class, ABDepositSendService.class, DEPOSITSENDSERVICENAME);
		
		
		locator.register(request, nFUSE.SendService.class, ABLoanRenewalSendService.class, LOANRENEWALSENDSERVICENAME);
		locator.register(request, nFUSE.SendService.class, ABLoanModificationSendService.class, LOANMODIFICATIONSENDSERVICENAME);
	}
	
	@testVisible
    private void deregisterServices() {
		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		locator.deregister(request, nFUSE.SendService.class, LOANRESERVESENDSERVICENAME);
		locator.deregister(request, nFUSE.SendService.class, LOANSENDSERVICENAME);
		locator.deregister(request, nFUSE.SendService.class, CUSTOMERSENDSERVICENAME);
		locator.deregister(request, nFUSE.SendService.class, DEPOSITSENDSERVICENAME);
		
		locator.deregister(request, nFUSE.SendService.class, LOANRENEWALSENDSERVICENAME);
		locator.deregister(request, nFUSE.SendService.class, LOANMODIFICATIONSENDSERVICENAME);
	}

    @testVisible
    private void deregisterTriggers() {
		nFORCE.BeanRegistry.getInstance().deregisterBean(ABTransactionTriggerHandler.BEAN_NAME, true);
		nFORCE.BeanRegistry.getInstance().deregisterBean(TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN, true);
		
		// nFORCE.BeanRegistry.getInstance().deregisterBean(ABTransactionTriggerCustomerHandler.BEAN_NAME, true);
		// nFORCE.BeanRegistry.getInstance().deregisterBean(TRANSACTION_LOG_AFTER_UPDATE_CUST_TRIGGERS_BEAN, true);
		
		// nFORCE.BeanRegistry.getInstance().deregisterBean(ABTransactionTriggerDepositHandler.BEAN_NAME, true);
		// nFORCE.BeanRegistry.getInstance().deregisterBean(TRANSACTION_LOG_AFTER_UPDATE_DEP_TRIGGERS_BEAN, true);
	}
	
    @testVisible
    private void registerTriggers() {
    	
    	//loan
		nFORCE.BeanRegistry.getInstance().registerBean(
			TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN,
			nFORCE.IPipelineContainer.class,
			nFORCE.TriggerPipeline.class,
			new Map<String, Object>{
				nFORCE.PipelineContainer.PIPELINE_BEAN_UNIQUE_NAMES => new String[]{
					ABTransactionTriggerHandler.BEAN_NAME
				}
			},
			true
		);
		
		// //customer
		// nFORCE.BeanRegistry.getInstance().registerBean(
		// 	TRANSACTION_LOG_AFTER_UPDATE_CUST_TRIGGERS_BEAN,
		// 	nFORCE.IPipelineContainer.class,
		// 	nFORCE.TriggerPipeline.class,
		// 	new Map<String, Object>{
		// 		nFORCE.PipelineContainer.PIPELINE_BEAN_UNIQUE_NAMES => new String[]{
		// 			ABTransactionTriggerCustomerHandler.BEAN_NAME
		// 		}
		// 	},
		// 	true
		// );
		
		// //deposit
		// nFORCE.BeanRegistry.getInstance().registerBean(
		// 	TRANSACTION_LOG_AFTER_UPDATE_DEP_TRIGGERS_BEAN,
		// 	nFORCE.IPipelineContainer.class,
		// 	nFORCE.TriggerPipeline.class,
		// 	new Map<String, Object>{
		// 		nFORCE.PipelineContainer.PIPELINE_BEAN_UNIQUE_NAMES => new String[]{
		// 			ABTransactionTriggerDepositHandler.BEAN_NAME
		// 		}
		// 	},
		// 	true
		// );
		
		
	}
    
    @testVisible
	private nFUSE.PluginConfigurationManager.PluginConfiguration CreateConfig(String key, String value, String dataType, Boolean isEncrypted){
		nFUSE.PluginConfigurationManager.PluginConfiguration config = new nFUSE.PluginConfigurationManager.PluginConfiguration();
		config.pluginName = PLUGIN_NAME;
		config.pluginVersion = PLUGIN_VERSION;
		config.category = PLUGIN_CATEGORY_NAME;
		config.key = key;
		config.valueDataType = dataType;
		config.value = value;
		config.isEncrypted = isEncrypted;
		return config;
	}
	
	public String GetTranslatedKey(String key){
		if(ConfigurationProperties.containsKey(key)){
			return ConfigurationProperties.get(key);
		}else{
			return ABUtility.NormalizeKey(key);
		}
	}
    
    public Map<String,String> GetAllProperties(Boolean translateKey){
        Map<String,String> configurationMap = this.retrieveKeyValueMap();
        Map<String,String> properties = new Map<String,String>();
        if(configurationMap.size()>0){
            for(String key : configurationMap.keySet()){
            	
            	if(translateKey){
            		if(ConfigurationProperties.containsKey(key)){
            			properties.put(ConfigurationProperties.get(key),configurationMap.get(key));
            		}else{
            			//convert to CAPS and replace spaces with undersAutomateds
            			properties.put(ABUtility.NormalizeKey(key),configurationMap.get(key));
            		}
            	}else{
            		properties.put(ABUtility.NormalizeKey(key),configurationMap.get(key));
            	}
            	
            }
        }
        return properties;
    }
    
    
    public String GetPropertyByKey(String key){
        Map<String,String> properties = this.GetAllProperties(true); //always try to translate
        if(properties != null && properties.size()>0 && properties.containsKey(ABUtility.NormalizeKey(key))){
        	
        	return properties.get(ABUtility.NormalizeKey(key));
            
        }
        return null;
    }
    
	@testVisible
	private Map<String, String> retrieveKeyValueMap(){
		nFUSE.PluginConfigurationManager configManager = new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION);
		Map<String, String> configurationMap = new Map<String, String>();
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = configManager.getConfigurations();
		for(nFUSE.PluginConfigurationManager.PluginConfiguration config : configs) {
			configurationMap.put(config.key, config.value);
		}
		return configurationMap;
	}
    
    public class ABConfigurationException extends Exception {}
    
    @testVisible
	private static final String NFUSE_CONFIGURATION_KEYWORD = 'Configuration';
	public static final Set<String> KEYS_TO_OMIT_FROM_MESSAGES = new Set<String>{
		'LOAN_RENEWAL_ONBOARDING_URL',
		'LOAN_MODIFICATION_ONBOARDING_URL',
		'LOAN_RESERVATION_ONBOARDING_URL',
		'LOAN_ONBOARDING_URL',
		'CUSTOMER_ONBOARDING_URL',
		'DEPOSIT_ONBOARDING_URL',
		'BASIC_AUTH_USERNAME',
		'BASIC_AUTH_PASSWORD',
		'AUTHENTICATION_TYPE',
		'ENABLE_RESERVE_LOAN_BUTTON',
		//'EXTERNAL_APP_ID_FIELD',
		'USE_ASYNCHRONOUS_REQUESTS',
		'LOAN_PROP_KEY',
		'EXT_APP_ID',
		'EXT_DEP_ID',
		'EXT_CUST_ID'
	};
	//these are intended to be communicated to third party
	public static final Set<String> TRANSACTION_STATUS_COMPLETION_STRINGS = new Set<String>{
		'REQUEST FAILED',
		'COMPLETE',
		'ERROR',
		'DONE',
		'FINISHED',
		'FAILURE'
	};
	//error strings should be a subset of the completion strings that indicate error. these are intended to be communicated to third party
	public static final Set<String> TRANSACTION_STATUS_ERROR_STRINGS = new Set<String>{
		'REQUEST FAILED',
		'ERROR',
		'FAILURE'
	};
	public static final String
            PLUGIN_NAME = 'AutomatedBooking',
            PLUGIN_VERSION = '1.0',
            PLUGIN_CATEGORY_NAME = PLUGIN_NAME + NFUSE_CONFIGURATION_KEYWORD,
            PLUGIN_CONFIG_CATEGORY = 'Generic Automated Booking',
            LOANRESERVESENDSERVICENAME = 'LoanReserveSendService',
            LOANSENDSERVICENAME = 'LoanSendService',
            CUSTOMERSENDSERVICENAME = 'CustomerSendService',
            DEPOSITSENDSERVICENAME = 'DepositSendService',
            
            LOANMODIFICATIONACTION = 'modify_loan',
            LOANRENEWALACTION = 'renew_loan',
            
            
            LOANRESERVATIONACTION = 'reserve_loan',
            LOANBOOKACTION = 'book_loan',
            CUSTOMERBOOKACTION = 'book_customer',
            DEPOSITBOOKACTION = 'book_deposit',
            NFUSE_LOAN_XPKG_SERVICE = 'nFUSE.LoanGetXPkg',
            NFUSE_RELATIONSHIP_XPKG_SERVICE = 'nFUSE.RelationshipGetXPkg',
            NFUSE_DEPOSIT_XPKG_SERVICE = 'nFUSE.DepositGetXPkg',
            IN_PROGRESS_STATUS = 'In Progress',
            TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN = 'transaction-log-gab-bean',
            // TRANSACTION_LOG_AFTER_UPDATE_CUST_TRIGGERS_BEAN = 'transaction-log-gab-cust-bean',
            // TRANSACTION_LOG_AFTER_UPDATE_DEP_TRIGGERS_BEAN = 'transaction-log-gab-dep-bean',
            //EXT_APP_ID = 'ExternalApplicationId',
            //EXT_APP_ID = 'Reserved Loan Id Field From Core System',
            LOAN_COMPLETE = 'LoanBooked',
            LOAN_COMPLETE_STATUS = 'Done',
            DEPOSIT_COMPLETE = 'DepositBooked',
            DEPOSIT_COMPLETE_STATUS = 'Done',
            CUSTOMER_COMPLETE = 'CustomerBooked',
            CUSTOMER_COMPLETE_STATUS = 'Done',
            LOAN_RESERVED_COMPLETE = 'LoanNumberReserved',
            LOAN_RESERVED_COMPLETE_STATUS = 'Done',
            
            
            LOANRENEWALSENDSERVICENAME = 'LoanRenewalSendService',
            LOAN_RENEWAL_COMPLETE = 'LoanRenewed',
            LOAN_RENEWAL_COMPLETE_STATUS = 'Done',
            LOANMODIFICATIONSENDSERVICENAME = 'LoanModificationSendService',
            LOAN_MODIFICATION_COMPLETE = 'LoanModified',
            LOAN_MODIFICATION_COMPLETE_STATUS = 'Done',
            
            
            
            
            
            //LOAN_PROP_KEY = 'Core System Loan Property Key',
            //ENABLE_RESERVE_LOAN_BUTTON = 'Enable Reserve Loan Button',
			EXTERNAL_APP_ID_FIELD = 'LLC_BI__lookupKey__c',
			// ACTION_BOOK = 'BookCommLoan',
			// ACTION_RESERVE = 'ReserveCommLoanNumber',
			PROP_LOAN_KEY = 'loan',
			PROP_RELATIONSHIP_KEY = 'relationship',
			PROP_DEPOSIT_KEY = 'deposit',
			//USE_ASYNCHRONOUS_REQUESTS = 'Perform Requests Asynchronously',
			LOANRESERVATIONLOOKUPKEY = PLUGIN_NAME + '-loannumres'
		;
}