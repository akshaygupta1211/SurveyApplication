public with sharing class SurveyController {
    
    @AuraEnabled(cacheable=true)
    public static SurveyWrapper getDetails() {
        Set<Id> questionIdSet = new Set<Id>();
        SurveyWrapper surveyWrapper = new SurveyWrapper();
        List<QuestionWrapper> questionWrapperList = new List<QuestionWrapper>();
        try {
            Id assigneeUserId = UserInfo.getUserId();

            Survey__c survey = [SELECT Name, (SELECT Id FROM Survey_Questions__r) FROM Survey__c WHERE Assign_To__c =: assigneeUserId].get(0);

            for(Survey_Question__c question : survey.Survey_Questions__r) {
                questionIdSet.add(question.Id);
            }

            List<Survey_Question__c> questionList = [SELECT Id, Name, Response_Type__c, (SELECT Id, Name FROM Survey_Answers__r) FROM Survey_Question__c WHERE Id IN :questionIdSet];

            for(Survey_Question__c question : questionList) {
                QuestionWrapper wrapper = new QuestionWrapper();
                wrapper.name = question.Name;
                wrapper.responseType = question.Response_Type__c;
                wrapper.answers = question.Survey_Answers__r;
                questionWrapperList.add(wrapper);
            }

            surveyWrapper.title = survey.Name;
            surveyWrapper.questions = questionWrapperList;
            return surveyWrapper;
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    } 

    @AuraEnabled
    public static void submitSurvey(String surveyWrapper) {
        try {

        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    } 

    public class SurveyWrapper {
        @AuraEnabled public String title;
        @AuraEnabled public List<QuestionWrapper> questions;
    }

    public class QuestionWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String responseType;
        @AuraEnabled public List<Survey_Answer__c> answers;        
    }    

}