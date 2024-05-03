trigger OrderEventTrigger on Order_Event__e (after insert) {
    TriggerFactoryInt.createHandler(OrderEventTriggerHandlerInt.class, Order_Event__e.getSObjectType());
}