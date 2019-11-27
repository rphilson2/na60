@isTest
private class TestActivityQuickCreateController {

	public testmethod static void test(){
		
		VolActivityQuickCreateSecurityController controller = new VolActivityQuickCreateSecurityController();
		PageReference page = controller.next();
		
		System.assert( page != null );	
	}
}