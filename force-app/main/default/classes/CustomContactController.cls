public with sharing class CustomContactController {

    @AuraEnabled 
    public static String checkViewAccess() {
        return '';
    }

    @AuraEnabled
    public static string setDataQualityCheckRequired(Id recordId){
        try {
            /** TO-DO **/
            return '';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Contact> findAll() {
        return [SELECT Id, Name, Email, Phone, Title FROM Contact];
    }
    
    @AuraEnabled
    public static List<Account> findAllAccount() {
        return [SELECT Name, Phone FROM Account LIMIT 10];
    }    
    
    @AuraEnabled
    public static Contact findByName(String name) {
        String query = 'SELECT Name, Phone, Email FROM Contact WHERE Name LIKE \'%' + name + '%\'';
        return Database.query(query);
    }

    @AuraEnabled
    public static Contact findById(Id contactId) {
        return [SELECT Name, Phone, Email, Title FROM Contact WHERE Id =: contactId];
    }

	@AuraEnabled
    public static List<Case> findCasesById(Id accountId) {
        return [SELECT CaseNumber, Origin, Priority, Status FROM Case WHERE AccountId =: accountId];
    }	    
    
}