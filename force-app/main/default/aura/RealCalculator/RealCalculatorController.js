({
    addition : function(component, event, helper) {
        sessionStorage.setItem("x", component.get("v.Input"));
        sessionStorage.setItem("operator", "sum");
        component.set("v.Input","");
    },
    
    subtraction : function(component, event, helper) {
        sessionStorage.setItem("x", component.get("v.Input"));
        sessionStorage.setItem("operator", "sub");
        component.set("v.Input","");		
    },
    
    multiplication : function(component, event, helper) {
        sessionStorage.setItem("x", component.get("v.Input"));
        sessionStorage.setItem("operator", "mul");
        component.set("v.Input","");		
    },
    
    division : function(component, event, helper) {
        sessionStorage.setItem("x", component.get("v.Input"));
        sessionStorage.setItem("operator", "div");
        component.set("v.Input","");		
    },
    
    getResult : function(component, event, helper) {
        sessionStorage.setItem("y", component.get("v.Input"));
        if(sessionStorage.getItem("operator") == "sum") {
            var z = parseInt(sessionStorage.getItem("x")) + parseInt(sessionStorage.getItem("y"));
        } else if(sessionStorage.getItem("operator") == "sub") {
            var z = parseInt(sessionStorage.getItem("x")) - parseInt(sessionStorage.getItem("y"));
        } else if(sessionStorage.getItem("operator") == "mul") {
            var z = parseInt(sessionStorage.getItem("x")) * parseInt(sessionStorage.getItem("y"));
        } else if(sessionStorage.getItem("operator") == "div") {
            var z = parseInt(sessionStorage.getItem("x")) / parseInt(sessionStorage.getItem("y"));
        }
        component.set("v.Input", z);
    }
})