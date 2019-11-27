({
    init : function(component, event, helper) {
        //a. call helper method to get/set the current userId
        helper.setFormattedDate(component, event, helper);

        //b. call helper method to get/set baseURL
        helper.setBaseURL(component, event, helper);

        //c. call helper method to get/set hrefs
        helper.setTaskHref(component, event, helper);
    },
    clickHandler : function (component, event, helper) {
        //a. determine source using the id attribute
        var srcId = event.srcElement.id;
        
        //b. set the recId... input parm for navigation event [e.force:navigateToSObject]
        var recId = "";
        switch (srcId) {
            case "taskRecord":  recId = component.get("v.task.Id");
                                break;
            case "whatRecord":  recId = component.get("v.task.WhatId");
                                break;
            case "whoRecord":   recId = component.get("v.task.WhoId");
                                break;
        }

        //c. create the navigation event
        var navEvent = $A.get("e.force:navigateToSObject");
        
        //d. set the runtime parameter
        navEvent.setParams({
            "recordId": recId
        });
        
        //e. fire the navEvent
        navEvent.fire();
    }
})