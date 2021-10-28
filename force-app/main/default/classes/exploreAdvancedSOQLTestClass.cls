@isTest
public class exploreAdvancedSOQLTestClass {
    // Syntax no.1 to write test
    @isTest static void myTest() {
        
        
        Account a = new Account();
        a.Name = 'Test';
        
        insert a;
        
        List<Contact> contactsList = new List<Contact>();
        
        Contact contactOne = new Contact();
        contactOne.LastName = 'Test Contact One';
        contactOne.AccountId = a.Id;
        
        Contact contactTwo = new Contact();
        contactTwo.LastName = 'Test Contact Two';
        contactTwo.AccountId = a.Id;
        
        contactsList.add(contactOne);
        contactsList.add(contactTwo);
        
        insert contactsList;
        
        Test.startTest();
        
        //even before you invoke this, fix all the dependencies
        exploreAdvancedSOQL eas = new exploreAdvancedSOQL();
        eas.implement();
        
        Test.stopTest();
    }
    
    // Syntax no.2 to write test
    static testMethod void testName() {
        
    }
}