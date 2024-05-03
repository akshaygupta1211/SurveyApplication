/**
* Abstract class of the Trigger Interface so can implement only the required methods
*/
public abstract class TriggerHandlerBaseInt implements ITriggerInt {
    private static Boolean triggerDisabled = false;
    protected Map<Id, SObject> sObjectsToUpdate = new Map<Id, SObject>();
    
    public virtual void bulkBefore() {}
    public virtual void bulkAfter() {}
    
    public virtual void beforeDelete(SObject so) {}
    public virtual void beforeInsert(SObject so) {}
    public virtual void beforeUpdate(SObject oldSo, SObject so) {}
    
    public virtual void afterDelete(SObject so) {}
    public virtual void afterInsert(SObject so) {}
    public virtual void afterUpdate(SObject oldSo, SObject so) {}
    
    public virtual void andFinally() {}
    
    public static void disableTrigger() {
        triggerDisabled = true;
    }
    public static void enableTrigger() {
        triggerDisabled = false;
    }
    public virtual Boolean isDisabled() {
        return TriggerHandlerBaseInt.triggerDisabled == true;
    }
}