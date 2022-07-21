/**
* @description Controller class for Survey_Response__c object
* @author Akshay Gupta
*/
public with sharing class SurveyResponseController {

    public static void updateSurveyScore(Map<Id, Survey_Response__c> responseMap) {
        Set<Id> surveyIdSet = new Set<Id>();
        try {
            for(Survey_Response__c response : responseMap.values()) {
                surveyIdSet.add(response.Survey__c);
            }
            List<Survey__c> surveyList = [SELECT Id, Score__c, (SELECT Value__c, Survey_Question__r.Response_Type__c FROM Survey_Responses__r) FROM Survey__c WHERE Id IN :surveyIdSet WITH SECURITY_ENFORCED];
            List<Survey__c> surveyListToUpdate = new List<Survey__c>();

            for(Survey__c survey : surveyList) {
                Decimal sumOfScore = 0.0;
                Decimal finalScore = 0.0;
                Integer noOfRatingResponses = 0;

                for(Survey_Response__c response : survey.Survey_Responses__r) {
                    noOfRatingResponses = survey.Survey_Responses__r.size();
                    if(response.Survey_Question__r.Response_Type__c == 'Radio-button') {
                        sumOfScore = sumOfScore + Decimal.valueOf(response.Value__c);
                    } else if (response.Survey_Question__r.Response_Type__c == 'Checkbox') {
                        noOfRatingResponses = noOfRatingResponses - 1;
                    }
                }

                if(noOfRatingResponses != 0) {
                    finalScore = (Decimal) (sumOfScore / noOfRatingResponses);
                }

                Survey__c surveyToUpdate = new Survey__c();
                surveyToUpdate.Id = survey.Id;
                surveyToUpdate.Score__c = String.valueOf(finalScore);
                surveyListToUpdate.add(surveyToUpdate);
            }
    
            if(surveyListToUpdate.size() > 0 && Schema.sObjectType.Survey__c.fields.Score__c.isUpdateable()) {
                update surveyListToUpdate;
            }
        } catch(Exception ex) {
            //System.debug(ex);
        }
    }

}