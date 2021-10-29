public with sharing class SurveyResponseController {

    public static void updateSurveyScore(Map<Id, Survey_Response__c> responseMap) {
        Set<Id> surveyIdSet = new Set<Id>();
        try {
            for(Survey_Response__c response : responseMap.values()) {
                surveyIdSet.add(response.Survey__c);
            }
            List<Survey__c> surveyList = [SELECT Id, Score__c, (SELECT Value__c FROM Survey_Responses__r) FROM Survey__c WHERE Id IN :surveyIdSet];
            List<Survey__c> surveyListToUpdate = new List<Survey__c>();
    
            for(Survey__c survey : surveyList) {
                Integer sumOfScore = 0;
                Decimal finalScore = 0;
                for(Survey_Response__c response : survey.Survey_Responses__r) {
                    sumOfScore = sumOfScore + Integer.valueOf(response.Value__c);
                }
                finalScore = sumOfScore / survey.Survey_Responses__r.size();
                Survey__c surveyToUpdate = new Survey__c();
                surveyToUpdate.Id = survey.Id;
                surveyToUpdate.Score__c = String.valueOf(finalScore);
                surveyListToUpdate.add(surveyToUpdate);
            }
    
            if(surveyListToUpdate.size() > 0) {
                update surveyListToUpdate;
            }
        } catch(Exception ex) {
            System.debug(ex);
        }
    }

}