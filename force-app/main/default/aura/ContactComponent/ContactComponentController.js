({
    doInit : function(component, event, helper) {
        var action = component.get("c.findAll");
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());
            console.log(a.getState());
            component.set("v.ContactsList", a.getReturnValue());
        });
        $A.enqueueAction(action);		
    },
    
    handleLocationChange : function(component, event, helper) {        
        var clickedtag = event.getParam("token");	
        var contactid = clickedtag.substr(clickedtag.indexOf('/')+1);
        var action = component.get("c.findById");
        
        console.log(contactid);
        
        if(clickedtag == 'undefined') {} else {
            
            action.setParams({contactId:contactid});
            action.setCallback(this, function(a) {
                console.log(a.getReturnValue());
                console.log(a.getState());
                component.set("v.ContactById", a.getReturnValue());
            });
            $A.enqueueAction(action);             
        }     
    },
    handleEvent : function(component, event, helper) {        
        var action = component.get("c.findByName");
        action.setParams({name : event.getParam("searchKey") });
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());
            console.log(a.getState());
            component.set("v.ContactByName", a.getReturnValue());
        });
        $A.enqueueAction(action);		    
    }
})