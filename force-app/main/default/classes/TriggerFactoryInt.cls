/**
* Class TriggerFactory
*
* Used to instantiate and execute Trigger Handlers associated with sObjects.
*/
public with sharing class TriggerFactoryInt {
    /**
* Public static method to create and execute a trigger handler
*
* Arguments:   System.Type classType - Class type to process
*              Schema.SObjectType soType - Object type to process
*
* Throws a TriggerIntException if no handler has been coded.
*/
    public class TriggerIntException extends Exception {}
    
    public static void createHandler(System.Type classType, SObjectType obType) {
        // Get a handler of the object being processed
        TriggerHandlerBaseInt handler = getHandler(classType);
        
        // Make sure we have a handler registered, new handlers must be registered in the getHandler method.
        if (handler == null) {
            throw new TriggerIntException('No Trigger Handler registered for Object Type: ' + obType);
        }
        
        // if trigger disabled, exit
        if (isTriggerHandlerDisabled(handler, obType)) {
            return;
        }
        
        // Execute the handler to fulfil the trigger
        execute(handler);
    }
    
    /**
* private static method to check if trigger is disabled
*
* Arguments:   TriggerHandlerBaseInt handler - instance of TriggerHandler
*              SObjectType obType - A Trigger Handler to execute
*/ 
    private static Boolean isTriggerHandlerDisabled(TriggerHandlerBaseInt handler, SObjectType obType) {
        // Check to see if the trigger has been disabled. If it has, return
        // Check from Trigger Settings (custom setting): All Trigger Disabled option or object-specific option
        return false;
    }
    
    /**
* private static method to control the execution of the handler
*
* Arguments:   TriggerHandlerBaseInt handler - A Trigger Handler to execute
*/ 
    private static void execute(TriggerHandlerBaseInt handler) {
        
        // Before trigger logic
        if (Trigger.IsBefore) {
            
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore();
            
            // Iterate through the records to be deleted passing them to the handler.
            if (Trigger.IsDelete) {
                for (SObject so : Trigger.old) {
                    handler.beforeDelete(so);
                }
            }
            
            // Iterate through the records to be inserted passing them to the handler.
            if (Trigger.IsInsert) {
                for (SObject so : Trigger.new) {
                    handler.beforeInsert(so);
                }
            }
            
            // Iterate through the records to be updated passing them to the handler.
            if (Trigger.IsUpdate) {
                for (SObject so : Trigger.old) {
                    handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
            
        }
        
        // After trigger logic
        if (Trigger.IsAfter)
        {
            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter();
            
            // Iterate through the records to be deleted passing them to the handler.
            if (Trigger.IsDelete) {
                for (SObject so : Trigger.old) {
                    handler.afterDelete(so);
                }
            }
            
            // Iterate through the records to be inserted passing them to the handler.
            if (Trigger.IsInsert) {
                for (SObject so : Trigger.new) {
                    handler.afterInsert(so);
                }
            }
            
            // Iterate through the records to be updated passing them to the handler.
            if (Trigger.IsUpdate) {
                for (SObject so : Trigger.old) {
                    handler.afterUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
            
        }
        
        // Perform any post processing
        handler.andFinally();
    }
    
    /**
    * private static method to get the appropriate handler for the object type.
    * Modify this method to add any additional handlers.
    *
    * Arguments:   System.Type obType - Class to locate
    *
    * Returns:     TriggerHandlerBaseInt - A trigger handler if one exists or null.
    */
    private static TriggerHandlerBaseInt getHandler(System.Type obType) {
        TriggerHandlerBaseInt handler = (obType == null) ? null : (TriggerHandlerBaseInt)obType.newInstance();
        return handler;
    }
    
}