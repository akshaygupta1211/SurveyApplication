({
    doInit : function(component, event, helper) {
        var action = component.get("c.findAllAccount");
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());
            console.log(a.getState());
            component.set("v.AccountsList", a.getReturnValue());
        });
        $A.enqueueAction(action);		
    },
    
    handleLocationChange : function(component, event, helper) {        
        var clickedtag = event.getParam("token");	
        var accountid = clickedtag.substr(clickedtag.indexOf('/')+1);
        var action = component.get("c.findCasesById");
        
        console.log(accountid);
        
        if(clickedtag == 'undefined') {} else {
            
            action.setParams({accountId:accountid});
            action.setCallback(this, function(a) {
                // console.log(a.getReturnValue());
                // console.log(a.getState());
                component.set("v.CasesList", a.getReturnValue());
            });
            $A.enqueueAction(action);             
        }     
    },
    
    handleEvent : function(component, event, helper) {
		component.set("v.contactattr",event.getParam("msg"));
        // console.log(component.get("v.contactattr"));
	}
})