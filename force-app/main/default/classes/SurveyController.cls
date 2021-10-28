public with sharing class SurveyController {
    
    @AuraEnabled
    public static void getDetails(Id assigneeUserId) {
        try {

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

    class SurveyWrapper {
        
    }

}