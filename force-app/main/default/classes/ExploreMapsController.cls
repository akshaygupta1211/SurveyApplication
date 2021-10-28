public class ExploreMapsController {
	
    public List<Account> accountsOwned {set;get;}
    
    public List<String> accountsOwnedList = new List<String>();
    
    public List<Contact> contacts;
    
    public Map<Id, List<Contact>> accountToContactMap = new Map<Id, List<Contact>>();
    
    public void process() {
        
        accountsOwned = [SELECT Id, Name FROM Account WHERE CreatedById=:UserInfo.getUserId()];
        
        for(Integer i = 0; i < accountsOwned.size(); i++) {
            accountsOwnedList.add(accountsOwned[i].Name);
        }
        
        contacts = [SELECT Id, Name FROM Contact WHERE Id IN :accountsOwnedList];
        
        //accountsOwned = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE CreatedById=:UserInfo.getUserId()];
    }
}