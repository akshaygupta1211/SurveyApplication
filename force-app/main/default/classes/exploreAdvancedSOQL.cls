public class exploreAdvancedSOQL {
    public void implement(){
        
        
        //SOQL in relationships	
        
        //parent →  child
        List<Account>  acc = [SELECT Id,(SELECT Id FROM Contacts) FROM Account];
        //List<Account>  acc1 = [SELECT Id,(SELECT Id FROM Outlets__r) FROM Account];
        
        
        //child → parent (Standard Object)
        List<Contact> c = [SELECT Id, Account.Name, Account.Rating FROM Contact]; // WHERE Id ='XXXXXXX'
        
        if(c.size() == 10){
            System.debug(' 🚀 ');
        }
        //child → parent (Custom Object)			
        //Contact c = [SELECT Id, CustomObject__r.Name FROM Account WHERE Id ='XXXXXXX' ]
    }
}