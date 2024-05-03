public with sharing class OrderEventTriggerHandlerInt extends TriggerHandlerBaseInt {
    
    private class OrderEventTriggerHandlerIntException extends Exception{}
    
    private static Set<Id> processedIDs;
    
    public OrderEventTriggerHandlerInt(){
        if (processedIDs == null) {
            processedIDs = new Set<Id>();
        }
    }
    
    public override void bulkAfter() {
        if(Trigger.isInsert) {
            OrderEventTriggerHelperInt.updateOrderStatus(Trigger.new, sObjectsToUpdate);
        }
    }
    
    public override void andFinally() {
        try{
            // remove processed IDs from sObjectsToUpdate
            for (Id pId : processedIDs) {
                sObjectsToUpdate.remove(pId);
            }
            if (!sObjectsToUpdate.isEmpty()) {
                List<SObject> sortedSObjectsToUpdate = sObjectsToUpdate.values();
                sortedSObjectsToUpdate.sort();
                update(sortedSObjectsToUpdate);
                processedIDs.addAll(sObjectsToUpdate.keySet());
            }
        }
        catch (Exception ex) {
            throw new OrderEventTriggerHandlerIntException(ex.getMessage());
        }        
    }    
}