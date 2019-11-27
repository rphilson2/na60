({
	pLSetup : function(cmp) {
		var action = cmp.get('c.getPLSetup'); 	
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                cmp.set('v.plSetup', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	}
})