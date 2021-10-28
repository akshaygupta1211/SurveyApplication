public class ExploreSOQLController {
	
    public List<Account> accounts {set;get;}
    
    public void explore() {
        //accounts = [SELECT Id, Name, Rating, Industry FROM Account WHERE Rating!=NULL ORDER BY Name ASC LIMIT 15];
        accounts = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account ORDER BY Name ASC LIMIT 15];
    }
}