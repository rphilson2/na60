/**
 * @author nCino
 * Implements the IPlugin Activator Interface and creates SystemProperties,
 * SystemConfiguration, and registers a bean for the CreditAppFacade on Activate.
 * Then does nothing on deactivate.
 **/
global with sharing class ABActivator implements nFUSE.IPluginActivator {
	
	@testVisible
	private ABConfiguration config = new ABConfiguration();
	
	public void onActivate() {
		system.debug('will activate');
		config.LoadPluginConfigurations();
        config.TogglePluginConfigurations(true);
        
	}
	public void onDeactivate() {
		system.debug('will deactivate');
		config.TogglePluginConfigurations(false);
	}
}