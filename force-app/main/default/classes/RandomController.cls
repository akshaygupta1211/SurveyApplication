public class RandomController {
    
    public String name {set;get;}
	public String location {set;get;}
    
    public PageReference getText() {
        name = 'John';
        location = 'Los Angeles';
        return new PageReference('/apex/PunkPage?name='+name+'&location='+location);
    }
    
}