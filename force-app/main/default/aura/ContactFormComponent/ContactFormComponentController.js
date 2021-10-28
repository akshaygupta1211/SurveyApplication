({  
    resetFlag : function(component, event, helper) {
        component.set("v.flag",false);
    },
    
    doInit : function(component, event, helper) {
        helper.fetchOptions(component, event, helper);
        if(component.get('v.recordId') == 'undefined' || component.get('v.recordId') == '' || component.get('v.recordId') == null) {
            
        } else {
            var action = component.get("c.fetchData");
            action.setParams({recordId : component.get('v.recordId')});
            action.setCallback(this, function(a) {
                // console.log(a.getReturnValue());
                // console.log(a.getState());
                component.set("v.contact", a.getReturnValue());
                component.set("v.selectedValue", a.getReturnValue().LeadSource);
            });
            $A.enqueueAction(action);
        }
    },
    
    saveContact : function(component, event, helper) {
        
        if(component.get('v.recordId') == 'undefined' || component.get('v.recordId') == '' || component.get('v.recordId') == null){
            // console.log(component.get('v.recordId'));
            var action = component.get("c.addContact");
            action.setParams({lastName : component.get('v.contact.LastName'), leadSource : component.get('v.selectedValue')});
            action.setCallback(this, function(a) {
                // console.log(a.getReturnValue());
                // console.log(a.getState());
                component.set("v.errorMessage", a.getReturnValue());
                
                if(component.get("v.errorMessage").includes("Insert failed")) {
                    component.set("v.flag",true);
                }
                
                var event = $A.get('e.force:navigateToSObject');
                event.setParams({
                    "recordId" : a.getReturnValue(),
                    "slideDevName" : "related"
                });
                event.fire();
            });
            $A.enqueueAction(action);
        } else {
            // console.log(component.get('v.recordId'));
            var action = component.get("c.editData");
            action.setParams({lastName : component.get('v.contact.LastName'), 
                              recordId : component.get('v.recordId'), 
                              leadSource : component.get('v.selectedValue')});
            action.setCallback(this, function(a) {
                // console.log(a.getReturnValue());
                // console.log(a.getState());
                component.set("v.errorMessage", a.getReturnValue());
                
                if(component.get("v.errorMessage").includes("Insert failed")) {
                    component.set("v.flag",true);
                }
                
                var event = $A.get('e.force:navigateToSObject');
                event.setParams({
                    "recordId" : a.getReturnValue(),
                    "slideDevName" : "related"
                });
                event.fire();
            });
            
            $A.enqueueAction(action);
        }
        
    },
    
    deleteContact : function(component, event, helper) {
        if(component.get('v.recordId') == 'undefined' || component.get('v.recordId') == '' || component.get('v.recordId') == null) {
            
        } else {        
            var action = component.get("c.deleteData");
            action.setParams({recordId : component.get('v.recordId')});
            action.setCallback(this, function(a) {
                // console.log(a.getReturnValue());
                // console.log(a.getState());
                component.set("v.contact", a.getReturnValue());
                
                var event = $A.get('e.force:navigateToURL');
                event.setParams({"url":"/003"});
                event.fire();                 
            });
            $A.enqueueAction(action);
        }
    }
})