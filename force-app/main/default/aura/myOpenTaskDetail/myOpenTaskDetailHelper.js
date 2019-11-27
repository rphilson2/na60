({
    setFormattedDate : function(component, event, helper) {
        var activityDateString = component.get("v.task.ActivityDate");
            //activityDateString = "yyyy-MM-dd"
        
        var today = new Date();
        today.setHours(0,0,0,0);
        var todayDateString = today.toISOString().split('T')[0];
            //todayDateString = "yyyy-MM-dd"

        var tomorrow = new Date(new Date().setDate(new Date().getDate()+1));
        tomorrow.setHours(0,0,0,0);
        var tomorrowDateString = today.toISOString().split('T')[0];
		
        //now compare strings
        var outDate = "Something";
        if (activityDateString === todayDateString) {
            outDate = "Today";
        } else if (activityDateString === tomorrowDateString) {
            outDate = "Tomorrow";
        } else if (activityDateString < todayDateString) {
            outDate = "Past Due"
        } else {
            outDate = activityDateString;
        }
            
        component.set('v.formattedDate', outDate);
	},
    setBaseURL : function(component, event, helper) {
        //a. get current href
        var windowLocation = window.location.href;
            //window.location.href = "https://fnni--ncino.lightning.force.com/lightning/page/home"
        
        //b. reduce window location to baseURL
        var baseURL = windowLocation.substring(0, windowLocation.indexOf("lightning/"));
        
        //c. set the baseURL on the components
        component.set("v.baseURL", baseURL);
    },
    setTaskHref : function(component, event, helper)  {
        //a. get baseURL
        var baseUrl = component.get("v.baseURL");
        
        //b. set href to task
        var taskId = component.get("v.task.Id");
        var href = baseUrl + taskId;
        component.set('v.taskHref', href);
        
        //c. set href to what
        var whatId = component.get("v.task.WhatId");
        href = baseUrl + whatId;
        component.set('v.whatHref', href);
        
        //d. set href to who
        var whoId = component.get("v.task.WhoId")
        href = baseUrl + whoId;
        component.set('v.whoHref', href);
    }
})