@isTest
private class TestActivityCancelController {

	public testmethod static void test(){
		
		VolActivityCancelControllerExt controller = new VolActivityCancelControllerExt( new ApexPages.StandardController( new Volunteer_Activity__c() ) );
		String aux = controller.msg;
		controller.sendCancellationToAll();
		controller.incrementCounter();
		
		Integer count = controller.getCount();
		
		System.assert( count == 1 );
		
		aux = controller.getVolunteerforceImageUrl;
	}
}