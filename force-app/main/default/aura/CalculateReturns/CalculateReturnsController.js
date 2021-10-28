({
	calculateReturn : function(component, event, helper) {
        console.log(component);
        
        var x = component.get("v.Amount");
        var y = component.get("v.ROI");
        var z = component.get("v.Duration");
        
        if(z > 10) {
            var result = x * y * 4.5 / 100;    
        } else {
            var result = x * y * 2 / 100;
        }
        
        console.log('Result = ' + result);
        component.set("v.Returns", result);	
	},
    
    validator: function(component, event, helper) {
        // debugger;
        component.get("v.ROI") > 10 ? component.set("v.errMessage", "Value of ROI cannot be more than 10") : component.set("v.errMessage", "");
        var err = component.find("div1");
        // var z = component.find("roi");
        if(component.get("v.ROI") > 10) {
            // component.set("v.errMessage", "Value of ROI cannot be more than 10");
            // z.set("v.flag", true);
            $A.util.removeClass(err,"hide");
            $A.util.addClass(err,"show");
        } else {
            // component.set("v.errMessage", "");
            // z.set("v.flag", false);
            $A.util.removeClass(err,"show");            
            $A.util.addClass(err,"hide");            
        }      
	}
})