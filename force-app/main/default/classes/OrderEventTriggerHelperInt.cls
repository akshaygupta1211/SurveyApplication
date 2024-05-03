public with sharing class OrderEventTriggerHelperInt {
    
    @TestVisible
    private class OrderEventTriggerHelperIntException extends Exception{}
    
    @TestVisible
    private static final String ORDER_STATUS_ACTIVATED = 'Activated';
    
    public static void updateOrderStatus(List<Order_Event__e> orderEventList, Map<Id, SObject> sObjectsToUpdate) {
        
        try {
            for(Order_Event__e orderEvent : orderEventList) {
                if(orderEvent.Status__c == ORDER_STATUS_ACTIVATED && orderEvent.Record_Id__c != null) {
                    Order orderToUpdate = sObjectsToUpdate.containsKey(orderEvent.Record_Id__c) ? (Order)sObjectsToUpdate.get(orderEvent.Record_Id__c) : new Order(Id = orderEvent.Record_Id__c);
                    orderToUpdate.Status = ORDER_STATUS_ACTIVATED;
                    sObjectsToUpdate.put(orderToUpdate.Id, orderToUpdate);
                }
            }    
        } catch (Exception ex) {
            throw new OrderEventTriggerHelperIntException(ex.getMessage());
        }
        
    }
}