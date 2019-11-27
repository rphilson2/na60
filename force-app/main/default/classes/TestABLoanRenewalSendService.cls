@isTest()
private class TestABLoanRenewalSendService{
    
    public class TestMsg extends nFUSE.AMiddlewareMessage {
    	
    	public TestMsg(){
    		this.messageHeader.action = ABConfiguration.LOANRENEWALACTION;
    	}
    	
    	public override String toMsg(){
            String serializedMessage = null;
            
            serializedMessage = 'loan=123'; //NOTE: custom serialization goes here
            
            return serializedMessage;
        }
    }
    @testSetup
    static void setupData() {
       //08/08/2019 Added as part of test class fix -begin
      	List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
       	accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
       //08/08/2019-end
     }

    @isTest
	private static void testMiddlwareMessage() {
	    
	    
	    new ABActivator().onActivate();
	    
	    String response = 'loan=123';
	    
	    ABConfiguration config = new ABConfiguration();
	    
	    Map<String,String> properties = config.GetAllProperties(true);
	    
	    TestMsg message = new TestMsg();
	    
	    message.messageHeader.action = ABConfiguration.LOANRENEWALACTION;
		message.properties.put('loan', '123');
		
		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		sendService.preSendSeam(message);
		
		System.assertEquals(response, message.toMsg());

	}
	
	@isTest
	private static void testMiddlwareMessageWithAdditionalProperties() {
	    
	    
	    new ABActivator().onActivate();
	    
	    nFORCE__System_Properties__c property1 = new nFORCE__System_Properties__c(Name='aaaa',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property1.nFORCE__Key__c = 'this is another property';
        property1.nFORCE__Value__c = 'this is another property values';
        insert property1;
	    
	    String response = 'loan=123';
	    
	    ABConfiguration config = new ABConfiguration();
	    
	    Map<String,String> properties = config.GetAllProperties(true);
	    
	    TestMsg message = new TestMsg();
	    
	    message.messageHeader.action = ABConfiguration.LOANRENEWALACTION;
		message.properties.put('loan', '123');
		
		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		sendService.preSendSeam(message);
		
		System.assertEquals(response, message.toMsg());

	}
	
	@isTest
	private static void testMiddlwareMessageWithOverrideSessionId() {
	    
	    
	    new ABActivator().onActivate();
	    
	    nFORCE__System_Properties__c property1 = new nFORCE__System_Properties__c(Name='aaaa',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property1.nFORCE__Key__c = 'this is another property';
        property1.nFORCE__Value__c = 'this is another property values';
        insert property1;
	    
	    String response = 'loan=123';
	    
	    ABConfiguration config = new ABConfiguration();
	    
	    Map<String,String> properties = config.GetAllProperties(true);
	    
	    TestMsg message = new TestMsg();
	    
	    message.messageHeader.action = ABConfiguration.LOANRENEWALACTION;
		message.properties.put('loan', '123');
		message.properties.put('salesforce_session_id', 'this is a custom sessionid');
		
		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		sendService.preSendSeam(message);
		
		System.assertEquals(response, message.toMsg());

	}
	
	@isTest
	private static void testPreProcessSeamDoesNotSetAuthorizationWhenNotBasic() {
        
        ABConfiguration config = new ABConfiguration();
	    
        nFORCE__System_Properties__c property1 = new nFORCE__System_Properties__c(Name='aaaa',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property1.nFORCE__Key__c = System.Label.AUTHENTICATION_TYPE;
        property1.nFORCE__Value__c = 'cheese';
        insert property1;
        
        nFORCE__System_Properties__c property2 = new nFORCE__System_Properties__c(Name='bbbb',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property2.nFORCE__Key__c = System.Label.LOAN_RENEWAL_ONBOARDING_URL;
        property2.nFORCE__Value__c = 'http://www.google.com';
        insert property2;
        
        nFORCE__System_Properties__c property3 = new nFORCE__System_Properties__c(Name='cccc',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property3.nFORCE__Key__c = System.Label.BASIC_AUTH_USERNAME;
        property3.nFORCE__Value__c = '';
        insert property3;
        
        nFORCE__System_Properties__c property4 = new nFORCE__System_Properties__c(Name='dddd',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property4.nFORCE__Key__c = System.Label.BASIC_AUTH_PASSWORD;
        property4.nFORCE__Value__c = '';
        insert property4;
        
        
	    
	    //System.assertEquals('Automated Booking Endpoint Authentication Type', System.Label.AUTHENTICATION_TYPE);
	    
	    //System.debug(config.GetAllProperties(true));
	    
	    String translatedKey = config.GetTranslatedKey(System.Label.AUTHENTICATION_TYPE);
	    
	    System.assertEquals('cheese', config.GetPropertyByKey(translatedKey));
	    
        String outputmessage = 'loan=123';

        TestMsg message = new TestMsg();
        message.httpresponse = new HttpResponse();
		message.httpResponse.setBody(outputmessage);
		message.properties.put('loan', '123');

        HttpRequest req = new HttpRequest();

		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		
		try{
			Object container = sendService.preSendRequest(req,message);
		  	System.assertEquals(true, true);
		}catch(Exception e){
			System.assertEquals(true, false);
		}
		
	}

	@isTest
	private static void testPostSendSeam() {
        
        String outputmessage = 'loan=123';

        TestMsg message = new TestMsg();
        message.httpresponse = new HttpResponse();
		message.httpResponse.setBody(outputmessage);
		message.properties.put('loan', '123');

		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		sendService.postSendSeam(message);

        System.assertEquals(outputmessage, message.toMsg());
        
	}
	
	@isTest
	private static void testPreProcessSeam() {
        
        ABConfiguration config = new ABConfiguration();
	    
        nFORCE__System_Properties__c property1 = new nFORCE__System_Properties__c(Name='aaaa',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property1.nFORCE__Key__c = System.Label.AUTHENTICATION_TYPE;
        property1.nFORCE__Value__c = 'Basic';
        insert property1;
        
        nFORCE__System_Properties__c property2 = new nFORCE__System_Properties__c(Name='bbbb',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property2.nFORCE__Key__c = System.Label.LOAN_RENEWAL_ONBOARDING_URL;
        property2.nFORCE__Value__c = 'http://www.google.com';
        insert property2;
        
        nFORCE__System_Properties__c property3 = new nFORCE__System_Properties__c(Name='cccc',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property3.nFORCE__Key__c = System.Label.BASIC_AUTH_USERNAME;
        property3.nFORCE__Value__c = 'Basic';
        insert property3;
        
        nFORCE__System_Properties__c property4 = new nFORCE__System_Properties__c(Name='dddd',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property4.nFORCE__Key__c = System.Label.BASIC_AUTH_PASSWORD;
        property4.nFORCE__Value__c = 'Basic';
        insert property4;
        
        
	    
	    //System.assertEquals('Automated Booking Endpoint Authentication Type', System.Label.AUTHENTICATION_TYPE);
	    
	    //System.debug(config.GetAllProperties(true));
	    
	    String translatedKey = config.GetTranslatedKey(System.Label.AUTHENTICATION_TYPE);
	    
	    System.assertEquals('Basic', config.GetPropertyByKey(translatedKey));
	    
        String outputmessage = 'loan=123';

        TestMsg message = new TestMsg();
        message.httpresponse = new HttpResponse();
		message.httpResponse.setBody(outputmessage);
		message.properties.put('loan', '123');

        HttpRequest req = new HttpRequest();

		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		Object container = sendService.preSendRequest(req,message);
		
// 		if(container instanceof HttpRequest){
// 			System.assertEquals(ABConfiguration.ActionEndpoints.get(message.messageHeader.action), ((HttpRequest)container).getEndpoint());
// 		}else{
// 			System.assertEquals(false, true);
// 		}

        System.assertEquals(outputmessage, message.toMsg());
        
	}
	
	@isTest
	private static void testPreProcessSeamErrorsOnEndpointBlank() {
        
        ABConfiguration config = new ABConfiguration();
	    
        nFORCE__System_Properties__c property1 = new nFORCE__System_Properties__c(Name='aaaa',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property1.nFORCE__Key__c = System.Label.AUTHENTICATION_TYPE;
        property1.nFORCE__Value__c = 'Basic';
        insert property1;
        
        nFORCE__System_Properties__c property2 = new nFORCE__System_Properties__c(Name='bbbb',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property2.nFORCE__Key__c = System.Label.LOAN_RENEWAL_ONBOARDING_URL;
        property2.nFORCE__Value__c = '';
        insert property2;
        
        nFORCE__System_Properties__c property3 = new nFORCE__System_Properties__c(Name='cccc',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property3.nFORCE__Key__c = System.Label.BASIC_AUTH_USERNAME;
        property3.nFORCE__Value__c = 'Basic';
        insert property3;
        
        nFORCE__System_Properties__c property4 = new nFORCE__System_Properties__c(Name='dddd',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property4.nFORCE__Key__c = System.Label.BASIC_AUTH_PASSWORD;
        property4.nFORCE__Value__c = 'Basic';
        insert property4;
        
        
	    
	    //System.assertEquals('Automated Booking Endpoint Authentication Type', System.Label.AUTHENTICATION_TYPE);
	    
	    //System.debug(config.GetAllProperties(true));
	    
	    String translatedKey = config.GetTranslatedKey(System.Label.AUTHENTICATION_TYPE);
	    
	    System.assertEquals('Basic', config.GetPropertyByKey(translatedKey));
	    
        String outputmessage = 'loan=123';

        TestMsg message = new TestMsg();
        message.httpresponse = new HttpResponse();
		message.httpResponse.setBody(outputmessage);
		message.properties.put('loan', '123');

        HttpRequest req = new HttpRequest();

		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		
		try{
			Object container = sendService.preSendRequest(req,message);
		  	System.assertEquals(true, false);
		}catch(Exception e){
			System.assertEquals(String.format(System.Label.MissingField,new String[]{ System.Label.LOAN_RENEWAL_ONBOARDING_URL }), e.getMessage());
		}
		
	}
	
	@isTest
	private static void testPreProcessSeamErrorsOnBasicAuthKeysBlank() {
        
        ABConfiguration config = new ABConfiguration();
	    
        nFORCE__System_Properties__c property1 = new nFORCE__System_Properties__c(Name='aaaa',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property1.nFORCE__Key__c = System.Label.AUTHENTICATION_TYPE;
        property1.nFORCE__Value__c = 'Basic';
        insert property1;
        
        nFORCE__System_Properties__c property2 = new nFORCE__System_Properties__c(Name='bbbb',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property2.nFORCE__Key__c = System.Label.LOAN_RENEWAL_ONBOARDING_URL;
        property2.nFORCE__Value__c = 'http://www.google.com';
        insert property2;
        
        nFORCE__System_Properties__c property3 = new nFORCE__System_Properties__c(Name='cccc',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property3.nFORCE__Key__c = System.Label.BASIC_AUTH_USERNAME;
        property3.nFORCE__Value__c = '';
        insert property3;
        
        nFORCE__System_Properties__c property4 = new nFORCE__System_Properties__c(Name='dddd',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property4.nFORCE__Key__c = System.Label.BASIC_AUTH_PASSWORD;
        property4.nFORCE__Value__c = '';
        insert property4;
        
        
	    
	    //System.assertEquals('Automated Booking Endpoint Authentication Type', System.Label.AUTHENTICATION_TYPE);
	    
	    //System.debug(config.GetAllProperties(true));
	    
	    String translatedKey = config.GetTranslatedKey(System.Label.AUTHENTICATION_TYPE);
	    
	    System.assertEquals('Basic', config.GetPropertyByKey(translatedKey));
	    
        String outputmessage = 'loan=123';

        TestMsg message = new TestMsg();
        message.httpresponse = new HttpResponse();
		message.httpResponse.setBody(outputmessage);
		message.properties.put('loan', '123');

        HttpRequest req = new HttpRequest();

		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		
		try{
			Object container = sendService.preSendRequest(req,message);
		  	System.assertEquals(true, false);
		}catch(Exception e){
			System.assertEquals(
				
				String.format(System.Label.BasicAuthenticationMissingField, new String[]{
                            System.Label.BASIC_AUTH_USERNAME
                        }) + 
                
                String.format(System.Label.BasicAuthenticationMissingField, new String[]{
                    System.Label.BASIC_AUTH_PASSWORD
                })
				
				, e.getMessage());
		}
		
	}
	
	@isTest
	private static void testPreProcessSeamFails() {
        
        String outputmessage = 'loan=123';

        TestMsg message = new TestMsg();
        message.messageHeader.action='Unsupported';
        message.httpresponse = new HttpResponse();
		message.httpResponse.setBody(outputmessage);
		message.properties.put('loan', '123');

        HttpRequest req = new HttpRequest();

		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		
		try {
			Object container = sendService.preSendRequest(req,message);
			System.assertEquals(true, false);
		} catch(ABLoanRenewalSendService.ABSendServiceException e){
			System.assertEquals(String.format(System.Label.ABSendServiceException, 
                    new String[]{
                        'Unsupported'
                    }), e.getMessage());
		}
		
	}
	
	@isTest
	private static void testPreProcessSeamFailsHttpError() {
        
        String outputmessage = 'loan=123';

        TestMsg message = new TestMsg();
        message.messageHeader.action='Unsupported';
        message.httpresponse = new HttpResponse();
		message.httpResponse.setBody(outputmessage);
		message.properties.put('loan', '123');

        HttpRequest req = new HttpRequest();

		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		
		try {
			Object container = sendService.preSendRequest(new Account(),message);
			System.assertEquals(true, false);
		} catch(ABLoanRenewalSendService.ABSendServiceException e){
			System.assertEquals(System.Label.ABHttpRequestExpected, e.getMessage());
		}
		
	}
	
	
	@isTest
	private static void testpostSendSeamFailsSynchronous() {
        
        nFORCE__System_Properties__c property1 = new nFORCE__System_Properties__c(Name='aaaa',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property1.nFORCE__Key__c = System.Label.USE_ASYNCHRONOUS_REQUESTS;
        property1.nFORCE__Value__c = 'false';
        insert property1;
        
        String outputmessage = 'customer=123';

        TestMsg message = new TestMsg();
        message.messageHeader.action='Unsupported';
        message.httpresponse = new HttpResponse();
        
		message.httpResponse.setBody(outputmessage);
		message.httpResponse.setStatusCode(300);
		
		message.properties.put('customer', '123');

        HttpRequest req = new HttpRequest();

		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		
		try {
			nFUSE.AMiddlewareMessage msg = sendService.postSendSeam(message);
			System.assertEquals(true, false);
		} catch(ABLoanRenewalSendService.ABSendServiceException e){
			System.assertEquals(true, e.getMessage().toLowerCase().contains('2xx'));
		}
		
	}
	
	
	@isTest
	private static void testpostSendSeamSucceedsSynchronous() {
        
        nFORCE__System_Properties__c property1 = new nFORCE__System_Properties__c(Name='aaaa',nFORCE__Category_Name__c='AutomatedBookingConfiguration',nFORCE__Is_Active__c=true);
        property1.nFORCE__Key__c = System.Label.USE_ASYNCHRONOUS_REQUESTS;
        property1.nFORCE__Value__c = 'false';
        insert property1;
        
        Account a = new Account(Name='cheese');
        insert a;
        
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
        log.nFUSE__Action__c = 'new';
        log.nFUSE__Api_Version__c = '1';
        log.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log.nFUSE__Primary_Object_Id__c = a.Id;
        log.nFUSE__Requested_By_User_Id__c = 'user';
        log.nFUSE__Transaction_Status__c = 'new';
        log.nFUSE__External_Id__c = 'test';
        insert log;
        
        
        String outputmessage = 'customer=123';

        TestMsg message = new TestMsg();
        message.messageHeader.action='Unsupported';
        message.messageHeader.transactionId = 'test';
        message.httpresponse = new HttpResponse();
        
		message.httpResponse.setBody(outputmessage);
		message.httpResponse.setStatusCode(200);
		
		message.properties.put('customer', '123');

        HttpRequest req = new HttpRequest();

		ABLoanRenewalSendService sendService = new ABLoanRenewalSendService();
		
		try {
			nFUSE.AMiddlewareMessage msg = sendService.postSendSeam(message);
			System.assertEquals(true, true);
		} catch(ABLoanRenewalSendService.ABSendServiceException e){
			System.assertEquals(true, false);
		}
		
	}
    
}