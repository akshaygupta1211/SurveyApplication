({
	getLastName : function(component, event, helper) {
        var x = $A.get('e.c:AppEvent');
        console.log(x);
        x.setParams({"msg":"What's up man ?"});
        x.fire();        
		var action = component.get("c.getContactName");
        action.setParams({contactId:component.get("v.id")});
        action.setCallback(this, function(a) {
            // console.log(a.getReturnValue());
            // console.log(a.getState());
        });
        $A.enqueueAction(action);
	},
    
    fetchAccounts : function(component, event, helper) {
		var action = component.get("c.getAccountList");
        action.setCallback(this, function(a) {
            // console.log(a.getReturnValue());
            // console.log(a.getState());
            component.set("v.AccountList", a.getReturnValue());
        });
        $A.enqueueAction(action);
	},
    
    fetchContacts : function(component, event, helper) {
		var action = component.get("c.getContacts");
        action.setParams({accId:component.get("v.id")});
        action.setCallback(this, function(a) {
            // console.log(a.getReturnValue());
            // console.log(a.getState());
            component.set("v.AssociatedContactList", a.getReturnValue());
        });
        $A.enqueueAction(action);
	},

    fetchCases : function(component, event, helper) {
		var action = component.get("c.getCases");
        action.setParams({name:component.get("v.accountName")});
        action.setCallback(this, function(a) {
            // console.log(a.getReturnValue());
            // console.log(a.getState());
            component.set("v.AssociatedCasesList", a.getReturnValue());
        });
        $A.enqueueAction(action);
	}    
})