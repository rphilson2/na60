@isTest()
private class TestABActivator{
    
    @isTest
	private static void testActivation_onActivate_addsConfigs() {
		new ABActivator().onActivate();
		
		ABConfiguration config = new ABConfiguration();
		
		Map<String,String> props = config.GetAllProperties(true);
		
		// for(String key : props.keySet()){
  //      	system.debug('key='+key+',value='+props.get(key));
  //      }
		
		System.assertEquals(15, props.size());
	}
	
	@isTest
	private static void testActivation_onDeactivate_setsConfigsInactive() {
		new ABActivator().onDeactivate();
		
		ABConfiguration config = new ABConfiguration();
		System.assertEquals(0, config.GetAllProperties(true).size()); //should be zero since they are disabled
	}
	
	@isTest
	private static void testActivation_onDeactivate_setsConfigsInactive_Then_Reactive() {
		new ABActivator().onDeactivate();
		
		ABConfiguration config = new ABConfiguration();
		System.assertEquals(0, config.GetAllProperties(true).size()); //should be zero since they are disabled
		
		new ABActivator().onActivate();
		
		System.assertEquals(15, config.GetAllProperties(true).size());
	}

}