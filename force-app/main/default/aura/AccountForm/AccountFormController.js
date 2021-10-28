({
    resetFlag : function(component, event, helper) {
        component.set("v.flag",false);
    },
    
    doInit : function(component, event, helper) {
        helper.fetchOptions(component, event, helper);
        var action = component.get("c.fetchAccounts");
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());
            console.log(a.getState());
            component.set("v.createdAccounts", a.getReturnValue());
            
        });
        $A.enqueueAction(action); 
    },
    
    saveAccount : function(component, event, helper) {
        var action = component.get("c.addAccount");
        action.setParams({name : component.get('v.account.Name'), type : component.get('v.selectedValue')});
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());
            console.log(a.getState());
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
    },
    
    resetFields : function(component, event, helper) {
        component.set("v.account.Name", "");
        component.set("v.selectedValue", "Prospect");
    }
})