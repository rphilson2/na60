public with sharing class ABTransactionMonitorController extends nFORCE.LifeCycleAppController {
	public String callback { get; private set; }
	public String namespace { get; private set; }

	@testVisible
	private static String nFUSE_Class = String.valueOf(nFUSE.IntegrationClassTypeProvider.class);

	public ABTransactionMonitorController() {
		this.callback = 'processLog_' + this.guid;
		String ns = ABUtility.getNameSpacePrefix(nFUSE_Class,'__');
		this.namespace = ns;
		this.nameSpace = ns;
	}

}