public with sharing class ExploreSOQLController {
	
    public List<Account> accounts {set;get;}
    
    public void explore() {
        accounts = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WITH SECURITY_ENFORCED ORDER BY Name ASC LIMIT 15];
    }
}