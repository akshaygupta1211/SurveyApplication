public with sharing class DynamicSQLClass {
    public List<Account> accountList{set;get;}
    public List<Contact> contactList{set;get;}
    public List<Opportunity> opportunityList{set;get;}
    public String searchParameter{set; get;}
    public Boolean isAccount{set;get;}
    public Boolean isContact{set;get;}
    public Boolean isOpportunity{set;get;}
    String objectName;
    
    public void search(){
        if(isAccount) {
            objectName = 'Account';
        } else if(isContact) {
            objectName = 'Contact';
        } else if(isOpportunity) {
            objectName = 'Opportunity';
        }
        
        String query = 'SELECT Id, Name FROM ' + String.escapeSingleQuotes(objectName) + ' WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchParameter) + '%\'';
        
        if(isAccount) {
            accountList = Database.query(query);
        } else if(isContact) {
            contactList = Database.query(query);
        } else if(isOpportunity) {
            opportunityList = Database.query(query);
        }
    }
}