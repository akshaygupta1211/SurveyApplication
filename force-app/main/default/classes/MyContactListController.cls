* @description Controller class for MyContactList Component
* @author Akshay Gupta
*/
public with sharing class MyContactListController {
    /**
    * @description Method for getting the details for survey assigned to the running user.
    * @param Id
    * @return List<Contact>
    */    
    @AuraEnabled
    public static List<Contact> getContacts(Id recordId) {
       return [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE AccountId = :recordId WITH SECURITY_ENFORCED];
    }
}