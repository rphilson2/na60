({	
    getLoadStats : function(cmp) {
        var action = cmp.get('c.fetchDailyStats');
        
        action.setParams({ 
            "insertDate" : cmp.get('v.insertDate') 
        });
        
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state == 'SUCCESS') {
                cmp.set('v.statsList', a.getReturnValue());
                // console.log('currency data is:' + JSON.stringify(a.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },
    gErrorLog : function(cmp) {
		var action = cmp.get('c.getErrorLog'); 	
        
        action.setParams({            
            "insertDate" : cmp.get('v.insertDate'),
            "objType" : cmp.get('v.DataType')
        });        
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                cmp.set('v.errorLog', a.getReturnValue());                
            }
        });
        $A.enqueueAction(action);
	}
})