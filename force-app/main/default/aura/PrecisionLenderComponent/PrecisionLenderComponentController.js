({
	doInit : function(component, event, helper) {
		var action = component.get('c.getFieldValues'); 	
        
        action.setParams({
            "acctId" : component.get('v.recordId')
        });
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                component.set('v.plRec', a.getReturnValue());
                helper.pLSetup(component);
            }
        });
        $A.enqueueAction(action);
	}
})