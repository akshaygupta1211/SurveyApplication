global class IvysaurBatchApex implements Database.Batchable<sObject>, Database.stateful {
   global Integer number_batches = 0;

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT Id FROM Account WITH SECURITY_ENFORCED');
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
	   number_batches += 1;
       DebbugerBatchApexClass bugger = new DebbugerBatchApexClass();
       bugger.debugThis();
   }

   global void finish(Database.BatchableContext BC){
       JigglyPuffBatchApex puff = new JigglyPuffBatchApex();
       Database.executeBatch(puff, 2);
   }
}