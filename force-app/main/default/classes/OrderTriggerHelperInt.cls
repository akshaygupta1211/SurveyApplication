public class OrderTriggerHelperInt {
    @TestVisible
    private class OrderTriggerHelperIntException extends Exception{}
    
    @TestVisible
    private static final String ORDER_STATUS_DRAFT = 'Draft';
    
    public static void sendOrderToProcess(List<Order> orderList) {
        
        List<Order_Event__e> orderEventToInsertList = new List<Order_Event__e>();
            
        try {
            for(Order order : orderList) {
                if(order.Status == ORDER_STATUS_DRAFT) {
                    Order_Event__e orderEventToInsert = new Order_Event__e();
                    orderEventToInsert.Record_Id__c = order.Id;
                    orderEventToInsert.Location__c = order.Location__c;
                    orderEventToInsert.Category__c = order.Category__c;
                    orderEventToInsert.Status__c = order.Status;
                    orderEventToInsert.Value__c = order.Value__c;
                    orderEventToInsertList.add(orderEventToInsert);
                }
                
            }
            
            if(orderEventToInsertList.size() > 0) {
                Eventbus.publish(orderEventToInsertList);
            }
            
        } catch (Exception ex) {
            throw new OrderTriggerHelperIntException(ex.getMessage());
        }
        
    }
}