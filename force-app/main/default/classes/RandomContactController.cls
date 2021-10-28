public with sharing class RandomContactController {
    
    @AuraEnabled
    public static List<String> getOptions() {
        Schema.DescribeFieldResult fieldResult = Contact.LeadSource.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<String> options = new List<String>();
        for(Schema.PicklistEntry f: ple) {
            options.add(f.getValue());
        }
        
        return options;
    }    
    
    @AuraEnabled
    public static String deleteData(String recordId) {
        
        try {
            delete [SELECT LastName FROM Contact WHERE Id =: recordId];
        } catch(Exception e) {
            return e.getMessage();
        }
        
        return null;
    }    
    
    @AuraEnabled
    public static Contact fetchData(String recordId) {
        return [SELECT LastName, LeadSource FROM Contact WHERE Id =: recordId];
    }
    
    @AuraEnabled
    public static String addContact(String lastName, String leadSource) {
        Contact c = new Contact();
        try {
            c.LastName = lastName;
            c.LeadSource = leadSource;
            insert c;            
        } catch(Exception e) {
            return e.getMessage();
        }
        return c.Id;
    }
    
    @AuraEnabled
    public static String editData(String lastName, String recordId, String leadSource) {
        Contact c = new Contact();
        try {
            c = [SELECT LastName FROM Contact WHERE Id =: recordId];
            c.LastName = lastName;
            c.LeadSource = leadSource;
            update c;            
        } catch(Exception e) {
            return e.getMessage();
        }
        return c.Id;       
    }
}