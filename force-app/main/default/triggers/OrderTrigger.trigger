trigger OrderTrigger on Order (before insert, after insert) {
    TriggerFactoryInt.createHandler(OrderTriggerHandlerInt.class, Order.getSObjectType());
}