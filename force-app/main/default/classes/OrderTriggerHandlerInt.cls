public with sharing class OrderTriggerHandlerInt extends TriggerHandlerBaseInt {
    
    private class OrderTriggerHandlerIntException extends Exception{}
    
    private static Set<Id> processedIDs;
    
    public OrderTriggerHandlerInt(){
        if (processedIDs == null) {
            processedIDs = new Set<Id>();
        }
    }
    
    public override void bulkAfter() {
        if(Trigger.isInsert) {
            OrderTriggerHelperInt.sendOrderToProcess(Trigger.new);
        }
    }
    
}