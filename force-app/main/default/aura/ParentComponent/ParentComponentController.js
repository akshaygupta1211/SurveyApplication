({
	handleClick : function(component, event, helper) {
		component.find("childComp").childMethod();
	},
    
    handleEvent : function(component, event, helper) {
		component.set("v.parentattr",event.getParam("msg"));
        console.log(component.get("v.parentattr"));
	} 
})