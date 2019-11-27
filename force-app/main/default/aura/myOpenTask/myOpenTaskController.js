({
	doInit : function(component, event, helper) {
        //a. call helper method to get/set the current userId
		helper.getCurrentUserId(component, event, helper);
        //b. call helper method to get/set openTasks
        helper.getOpenTasksForUser(component, event, helper);     
	},
    navToAllTasks : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/o/Task/home"
        });
        urlEvent.fire();
    }
})