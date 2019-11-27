({
	onClickHandler : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "foundation:https://firstfoundation.fnni.com/hhp/servlet/com.fnni.fnd.servlet.FNNILogin"
        });
        urlEvent.fire();
	}
})