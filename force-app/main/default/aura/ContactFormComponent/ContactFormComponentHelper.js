({
    fetchOptions: function(component, event, helper) {
        var action = component.get("c.getOptions");
        action.setCallback(this, function(a) {
            // console.log(a.getReturnValue());
            // console.log(a.getState());
            component.set("v.options", a.getReturnValue());
        });
        $A.enqueueAction(action);        
    }
})