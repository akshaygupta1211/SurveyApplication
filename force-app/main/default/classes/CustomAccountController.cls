public with sharing class CustomAccountController {
    
    @AuraEnabled
    public static String addAccount(String name, String type) {
        Account a = new Account();
        try {
            a.Name = name;
            a.Type = type;
            insert a;            
        } catch(Exception e) {
            return e.getMessage();
        }
        return a.Id;
    }
    
    @AuraEnabled
    public static List<String> getOptions() {
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<String> options = new List<String>();
        for(Schema.PicklistEntry f: ple) {
            options.add(f.getValue());
        }
        
        return options;
    }    
    
    @AuraEnabled
    public static List<Contact> fetchAccounts() {
        return Database.query('SELECT Name, Type FROM Account WHERE CreatedDate=TODAY');
    }
    
}