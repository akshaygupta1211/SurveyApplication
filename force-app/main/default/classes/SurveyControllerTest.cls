/**
* @description Test class for SurveyController class
* @author Akshay Gupta
*/
@isTest
public class SurveyControllerTest {

    /**
    *@description method for preparing test data
    *
    */
    @TestSetup
    static void prepareData(){
        User testUser = new User(Alias = 'standt', Email='standarduser@testorgmail.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgmail.com');
        insert testUser;    

        Survey__c survey = new Survey__c();
        survey.Name = 'New Product and Service Survey';
        survey.Status__c = 'Assigned';
        survey.Assign_To__c = testUser.Id;
        insert survey;
        
        List<Survey_Question__c> questionList = new List<Survey_Question__c>();
        questionList.add(new Survey_Question__c(Name = 'How much you would rate our product(s)?', Survey__c = survey.Id, Response_Type__c = 'Radio-button'));
        questionList.add(new Survey_Question__c(Name = 'How much you would rate our service(s)?', Survey__c = survey.Id, Response_Type__c = 'Radio-button'));
        questionList.add(new Survey_Question__c(Name = 'Would you recommend our service(s) to your colleague(s) and friend(s)?', Survey__c = survey.Id, Response_Type__c = 'Checkbox'));
        insert questionList;

        List<Survey_Answer__c> answerList = new List<Survey_Answer__c>();
        answerList.add(new Survey_Answer__c(Name = '1', Survey_Question__c = questionList[0].Id));
        answerList.add(new Survey_Answer__c(Name = '2', Survey_Question__c = questionList[0].Id));
        answerList.add(new Survey_Answer__c(Name = '3', Survey_Question__c = questionList[0].Id));
        answerList.add(new Survey_Answer__c(Name = '4', Survey_Question__c = questionList[0].Id));
        answerList.add(new Survey_Answer__c(Name = '5', Survey_Question__c = questionList[0].Id));                                
        answerList.add(new Survey_Answer__c(Name = '1', Survey_Question__c = questionList[1].Id));
        answerList.add(new Survey_Answer__c(Name = '2', Survey_Question__c = questionList[1].Id));
        answerList.add(new Survey_Answer__c(Name = '3', Survey_Question__c = questionList[1].Id));
        answerList.add(new Survey_Answer__c(Name = '4', Survey_Question__c = questionList[1].Id));
        answerList.add(new Survey_Answer__c(Name = '5', Survey_Question__c = questionList[1].Id));
        answerList.add(new Survey_Answer__c(Name = 'Yes', Survey_Question__c = questionList[2].Id));
        answerList.add(new Survey_Answer__c(Name = 'No', Survey_Question__c = questionList[2].Id));
        insert answerList;   

    }

    /**
    *@description test method for checking if the survey is assigned to user
    *
    */
    @isTest
    public static void testGetDetails() {
        List<User> userList = [SELECT Id FROM User WHERE UserName='standarduser@testorgmail.com' LIMIT 1];

        Test.startTest();

        System.runAs(userList[0]) {
            SurveyController.SurveyWrapper wrapper = SurveyController.getDetails();

            System.assertEquals(wrapper.title, [SELECT Name FROM Survey__c][0].Name, 'Survey should be assigned to the user.');
        }
        
        Test.stopTest();
    }

    /**
    *@description test method for simulating response submission and checking if status is updated to Closed or not.
    *
    */
    @isTest
    public static void testSubmitResponses() {
        List<User> userList = [SELECT Id FROM User WHERE UserName='standarduser@testorgmail.com' LIMIT 1];
        List<Survey_Question__c> questionList = [SELECT Id, Survey__c FROM Survey_Question__c LIMIT 3];

        Test.startTest();

        System.runAs(userList[0]) {
            List<SurveyController.ResponseWrapper> wrapperList = new List<SurveyController.ResponseWrapper>();
            
            SurveyController.ResponseWrapper wrapper1 = new SurveyController.ResponseWrapper();
            wrapper1.questionId = questionList[0].Id;
            wrapper1.surveyId = questionList[0].Survey__c;
            wrapper1.response = '4';

            SurveyController.ResponseWrapper wrapper2 = new SurveyController.ResponseWrapper();
            wrapper2.questionId = questionList[1].Id;
            wrapper2.surveyId = questionList[1].Survey__c;
            wrapper2.response = '3';

            SurveyController.ResponseWrapper wrapper3 = new SurveyController.ResponseWrapper();
            wrapper3.questionId = questionList[2].Id;
            wrapper3.surveyId = questionList[2].Survey__c;
            wrapper3.response = 'Yes';

            wrapperList.add(wrapper1);  
            wrapperList.add(wrapper2);
            wrapperList.add(wrapper3);  
            
            SurveyController.submitResponses(JSON.serialize(wrapperList));

            System.assertEquals([SELECT Status__c FROM Survey__c][0].Status__c, 'Closed', 'Survey status should be updated to Closed.');
        }
        
        Test.stopTest();
    }

    /**
    *@description test method for simulating exception in application
    *
    */
    @isTest
    public static void testGenerateException() {
        try {
            SurveyController.submitResponses(null);
        } catch(Exception ex) {
            System.assertEquals('System.AuraHandledException', ex.getTypeName(), 'Exception should be thrown.');
        }
    }    

}