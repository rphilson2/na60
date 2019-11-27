({
	getCurrentUserId : function(component, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId", userId);
        console.log("getCurrentUserId() -- userId set to " + userId);
	},
    getOpenTasksForUser : function(component, event, helper) {
        //a. define the AuraEnabled Apex class/method we need to call
        //    ==> myOpenTasksController.getOpenTasks()
        var action = component.get("c.getOpenTasks");
        
        //b. myOpenTasksController.getOpenTasks() requires one input parms...set it
        action.setParams({
            userId: component.get("v.userId")
        });
        
        //c. set the Async response... what to do AFTER the action is completed
        //    note: the second parameter is an embedded function
        action.setCallback(this, function(response) {
            var openTasks = response.getReturnValue();
            component.set("v.openTasks", openTasks);
        });
        
    	//d. queue up the action to run when the thread is available
    	$A.enqueueAction(action);
    }    
})