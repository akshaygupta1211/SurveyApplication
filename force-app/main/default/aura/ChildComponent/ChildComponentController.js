({
	handleClick : function(component, event, helper) {
        var x = component.getEvent('cmpevent');
        console.log(x);
        x.setParams({"msg":"You get out of here"});
        x.fire();
		console.log('This is child component speaking,');
        console.log('Parameters passed from parent component ' + component.get("v.childattr"))
	}
})