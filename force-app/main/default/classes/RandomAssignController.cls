public class RandomAssignController {
	
    public List<Account> accountRecordsList {set;get;}
    public List<Account> associatedAccounts {set;get;}
    public Map<Id, List<Contact>> associatedContacts {set;get;}
    public Map<Id, List<Opportunity>> associatedOpportunities {set;get;}
    public Map<Id, List<Case>> associatedCases {set;get;}
    public Integer count {set;get;}
    
    public void useSOQLQuery() {
        String accountId = '0012v00002STbXj';
        
        // accountRecordsList = [SELECT Id, Name, Rating, Industry FROM Account WHERE Id =: accountId];
        // accountRecordsList = [SELECT Id, Name, Rating, Industry FROM Account LIMIT 10];
        // accountRecordsList = [SELECT Id, Name, Rating, Industry FROM Account ORDER BY NAME ASC];
        accountRecordsList = [SELECT Id, Name, Rating, Industry FROM Account OFFSET 5];
        
        System.debug(accountRecordsList);
    }
    
    public void insertRecords() {
        List<Account> newAccountRecords = new List<Account>();
        
        for(Integer i = 0; i < 5; i++) {
            Account a = new Account();
            
            a.Name = 'Testing' + i;
            
            newAccountRecords.add(a);
        }
        
        insert newAccountRecords;
    }
    
    public void countRecords() {
        count =  [SELECT count() FROM Account];
    }
    
    public void updateRecord() {
        String accountId = '0012v00002Vcbnn';
        
        Account accountRecord = [SELECT Id, Rating FROM Account WHERE Id =: accountId];
        
        accountRecord.Rating='Hot';
        
        update accountRecord;
    }
    
    public void retreiveChild() {
        associatedAccounts = [SELECT Name, (SELECT Name FROM Contacts), (SELECT Name FROM Opportunities), (SELECT CaseNumber FROM Cases) FROM Account];
 		
       /** 
        for(Account a : associatedAccounts) {
            associatedContacts.put(a.Id, a.Contacts);
        }       
        
        for(Account a : associatedAccounts) {
            associatedOpportunities.put(a.Id, a.Opportunities);
        }

        for(Account a : associatedAccounts) {
            associatedCases.put(a.Id, a.Cases);
        }
		*/        
    }
    
}