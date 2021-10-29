trigger SurveyResponseTrigger on Survey_Response__c (before insert, after insert, before update, after update) {
    if(Trigger.isInsert && Trigger.isAfter) {
        SurveyResponseController.updateSurveyScore(Trigger.newMap);
    }
}