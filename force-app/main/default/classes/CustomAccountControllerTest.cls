/**
* @description Test class for CustomAccountController class
* @author Akshay Gupta
*/
@isTest
public class CustomAccountControllerTest {

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

        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Type = 'Customer - Direct';
        insert acc; 
    }
    
    @isTest
    static void addAccountTest(){
        List<User> userList = [SELECT Id FROM User LIMIT 1];

        System.runAs(userList[0]) {

            Id accountId = CustomAccountController.addAccount('Test Account 2', 'Customer - Direct');

            String name = 'Test Account 2';

            System.assertEquals([SELECT Id FROM Account WHERE Name =: name].get(0).Id, accountId, 'Account should be created.');

        }
    }

    @isTest
    static void fetchAccountsTest(){
        List<User> userList = [SELECT Id FROM User LIMIT 1];

        System.runAs(userList[0]) {

            List<Account> accList = CustomAccountController.fetchAccounts();

            System.assertEquals(1, accList.size(), 'One account should be returned');

        }
    }

    @isTest
    static void getOptionsTest(){
        List<User> userList = [SELECT Id FROM User LIMIT 1];

        System.runAs(userList[0]) {

            List<String> optionList = CustomAccountController.getOptions();

            System.assertEquals(7, optionList.size(), 'All 7 options should be returned.');

        }
    }    
}
