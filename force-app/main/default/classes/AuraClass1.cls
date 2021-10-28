public with sharing class AuraClass1 {
	@auraEnabled
    public static String getContactName(Id contactId) {
        return [SELECT LastName FROM Contact WHERE Id =: contactId].LastName;
    }
    
    @auraEnabled
    public static List<Account> getAccountList() {
        return [SELECT Name FROM Account LIMIT 10];
    }
    
    @auraEnabled
    public static List<Account> getContacts(ID accId) {
        return [SELECT Name, (SELECT LastName FROM Contacts) FROM Account WHERE Id =: accId];
    }

    @auraEnabled
    public static List<Account> getCases(String name) {
        return [SELECT Name, (SELECT CaseNumber FROM Cases) FROM Account WHERE Name =: name];
    }    
    
}