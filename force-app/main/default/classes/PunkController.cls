public class PunkController {
    
    public List<String> locations {set;get;}    
    public List<Account> accounts {set;get;}    
    public String name {set;get;}
    public String location {set;get;}
    
    public PunkController() {
        name = apexpages.currentPage().getparameters().get('name');
        location = apexpages.currentPage().getparameters().get('location');
    }
    
    public void loopOver() {
        /*
        locations = new List<String>();
        locations.add('Hyderabad');
        locations.add('Bangalore');
        locations.add('Pune');
        locations.add('Delhi');
        */
        //accounts = [SELECT Name, Industry, Phone FROM Account];
    }
}