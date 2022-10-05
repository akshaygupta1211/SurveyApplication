/**
* @description Test class for MyContactListController
* @author Akshay Gupta
*/
@isTest
public class MyContactListControllerTest {

    @testSetup
    public static void prepareData() {
        Account acc = new Account();
        acc.Name = 'Test Account Inc.';
        insert acc;

        Contact cont = new Contact();
        cont.FirstName = 'John';
        cont.LastName = 'Doe';
        cont.AccountId = acc.Id;
        insert cont;

    }

    @isTest
    public static void getContactsTest() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        List<Contact> contList = MyContactListController.getContacts(acc.Id);

        System.assertEquals(1, contList.size());
    }
}