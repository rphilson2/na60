({
	doInit : function(component, event, helper) {
        var today = new Date();        
        var insertDate = $A.localizationService.formatDate(new Date(today.getFullYear(),today.getMonth(),today.getDate()-1), "YYYY-MM-DD");

    	component.set('v.insertDate', insertDate);
        //component.set('v.inputDate', today);
        
        helper.getLoadStats(component);        
	},
    itemsChange: function(component, event, helper) {
        component.set("v.showDetail",false);  
        helper.getLoadStats(component);
    },
    personCustomerClick: function(component, event, helper) {                
        component.set("v.showDetail",true);  
        component.set("v.DataType","PersonCustomer");  
        //helper.getLoadStats(component);
        helper.gErrorLog(component);        
    },
    businessCustomerClick: function(component, event, helper) {                
        component.set("v.showDetail",true);  
        component.set("v.DataType","BusinessCustomer");  
        //helper.getLoadStats(component);
        helper.gErrorLog(component);
    },
    mortgageDetailsClick: function(component, event, helper) {                
        component.set("v.showDetail",true);  
        component.set("v.DataType","MortgageDetails");  
        //helper.getLoadStats(component);
        helper.gErrorLog(component);
    },
    triggerDataClick: function(component, event, helper) {        
        component.set("v.showDetail",true);  
        component.set("v.DataType","TriggerData");  
        //helper.getLoadStats(component);
        helper.gErrorLog(component);
    },
    precisionLenderClick: function(component, event, helper) {        
        component.set("v.showDetail",true);  
        component.set("v.DataType","PrecisionLender");  
        //helper.getLoadStats(component);
        helper.gErrorLog(component);
    },
    businessCIXFClick: function(component, event, helper) {        
        component.set("v.showDetail",true);  
        component.set("v.DataType","BusinessCIXF");  
        //helper.getLoadStats(component);
        helper.gErrorLog(component);
    },
    personCIXFClick: function(component, event, helper) {        
        component.set("v.showDetail",true);  
        component.set("v.DataType","PersonCIXF");  
        //helper.getLoadStats(component);
        helper.gErrorLog(component);
    }
})