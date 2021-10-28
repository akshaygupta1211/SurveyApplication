({
    doInit : function(component, event, helper) {
        component.find("contactRecordCreator").getNewRecord(
            "Contact", // objectApiName
            null, // recordTypeId
            false, // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newContact");
                var error = component.get("v.newContactError");
                // console.log(rec.id);
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                }
                else {
                    console.log(rec);
                    console.log("Record template initialized: " + JSON.stringify(rec));
                }
            }));
        //////////////////////////////////////////////
    },
    savedata:function(component,event,helper){
        ////////////////////////
        component.find("contactRecordCreator").saveRecord($A.getCallback(function(saveResult) {
            // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful
            // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
            console.log(saveResult);
            console.log(JSON.stringify(saveResult));
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                
            }
        }));
    }
    
})