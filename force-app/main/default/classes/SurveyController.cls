/**
* @description Controller class for SurveyComponent
* @author Akshay Gupta
*/
public with sharing class SurveyController {
    
    /**
    * @description Method for getting the details for survey assigned to the running user.
    * 
    */
    @AuraEnabled(cacheable=true)
    public static SurveyWrapper getDetails() {
        Set<Id> questionIdSet = new Set<Id>();
        SurveyWrapper surveyWrapper = new SurveyWrapper();
        List<QuestionWrapper> questionWrapperList = new List<QuestionWrapper>();
        List<Survey_Question__c> questionList = new List<Survey_Question__c>();
        try {

            Id assigneeUserId = UserInfo.getUserId();

            Survey__c survey = [SELECT Id, Name, (SELECT Id FROM Survey_Questions__r) FROM Survey__c WHERE Assign_To__c =: assigneeUserId AND Status__c = 'Assigned' WITH SECURITY_ENFORCED].get(0);

            for(Survey_Question__c question : survey.Survey_Questions__r) {
                questionIdSet.add(question.Id);
            }

            if(questionIdSet.size() > 0) {
                questionList = [SELECT Id, Name, Response_Type__c, (SELECT Id, Name FROM Survey_Answers__r ORDER BY Name ASC) FROM Survey_Question__c WHERE Id IN :questionIdSet];                
            }

            if(questionList.size() > 0) {
                for(Survey_Question__c question : questionList) {
                    QuestionWrapper wrapper = new QuestionWrapper();
                    wrapper.questionId = question.Id;
                    wrapper.name = question.Name;
                    wrapper.responseType = question.Response_Type__c == 'Checkbox' ? false : true;
                    wrapper.answers = question.Survey_Answers__r;
                    questionWrapperList.add(wrapper);
                }
            }

            surveyWrapper.surveyId = survey.Id;
            surveyWrapper.title = survey.Name;
            surveyWrapper.questions = questionWrapperList;

            return surveyWrapper;

        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    } 

    /**
    * @description Method for handling the submission of response(s)
    * 
    */    
    @AuraEnabled
    public static void submitResponses(String responseWrapper) {
        List<Survey_Response__c> responseList = new List<Survey_Response__c>();       
        try {
            List<ResponseWrapper> responseWrapperList = (List<ResponseWrapper>)JSON.deserialize(responseWrapper, List<ResponseWrapper>.class);

            for(ResponseWrapper wrapper : responseWrapperList) {
                Survey_Response__c response = new Survey_Response__c();
                response.Value__c = wrapper.response;
                response.Survey_Question__c = wrapper.questionId;
                response.Survey__c = wrapper.surveyId;
                responseList.add(response);
            }

            if(responseList.size() > 0) {
                insert responseList;
            }

            Survey__c survey = new Survey__c();
            survey.Id = responseWrapperList[0].surveyId;
            survey.Status__c = 'Closed';
            update survey;

        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    } 

    /**
    * @description Wrapper class containing survey details and QuestionWrapper.
    * 
    */        
    public class SurveyWrapper {
        @AuraEnabled public String surveyId;
        @AuraEnabled public String title;
        @AuraEnabled public List<QuestionWrapper> questions;
    }

    /**
    * @description Wrapper class containing the question and answers' details.
    * 
    */        
    public class QuestionWrapper {
        @AuraEnabled public String questionId;
        @AuraEnabled public String name;
        @AuraEnabled public Boolean responseType;
        @AuraEnabled public List<Survey_Answer__c> answers;        
    }    

    /**
    * @description Wrapper class containing survey, question and responses
    * 
    */        
    public class ResponseWrapper {
        @AuraEnabled public String questionId;
        @AuraEnabled public String surveyId;
        @AuraEnabled public String response;
    }

}