/**
* @description Custom controller class used by lwc(s) and aura components
* to return records, update and check access of the running user. 
* @author Akshay Gupta
*/
public with sharing class CustomContactController {

    /**
    * @description Method checking if the current user have access to view the details
    * @return String
    */
    @AuraEnabled 
    public static String checkViewAccess() {
        return '';
    }

    /**
    * @description Method for updating the contact record
    * @return String
    */    
    @AuraEnabled
    public static string setDataQualityCheckRequired(Id recordId){
        try {
            /***TO-DO***/
            return '';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description Method for returning all the contacts
    * @return List<Contact>
    */    
    @AuraEnabled
    public static List<Contact> findAll() {
        return [SELECT Id, Name, Email, Phone, Title FROM Contact WITH SECURITY_ENFORCED];
    }
    
    /**
    * @description Method for returning all the accounts
    * @return List<Account>
    */    
    @AuraEnabled
    public static List<Account> findAllAccount() {
        return [SELECT Name, Phone FROM Account WITH SECURITY_ENFORCED LIMIT 10];
    }    
    
    /**
    * @description Method for returning contact by name
    * @return Contact
    */    
    @AuraEnabled
    public static Contact findByName(String name) {
        String query = 'SELECT Name, Phone, Email FROM Contact WHERE Name LIKE \'%' + String.escapeSingleQuotes(name) + '%\'';
        return Database.query(query);
    }

    /**
    * @description Method for returning contact by contactId
    * @return Contact
    */    
    @AuraEnabled
    public static Contact findById(Id contactId) {
        return [SELECT Name, Phone, Email, Title FROM Contact WHERE Id =: contactId WITH SECURITY_ENFORCED];
    }

    /**
    * @description Method for returning Case(s) and its details by accountId
    * @return List<Case>
    */    
	@AuraEnabled
    public static List<Case> findCasesById(Id accountId) {
        return [SELECT CaseNumber, Origin, Priority, Status FROM Case WHERE AccountId =: accountId WITH SECURITY_ENFORCED];
    }	    
    
}