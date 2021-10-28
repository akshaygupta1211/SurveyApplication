public class exploreApexClasses {

    public Integer z {set;get;} //this syntax is required when a variable is to be referenced to visualforce page
    
    Integer x = 3;
    Integer y = 2;

    public Integer add() {
        z = x + y;
        return 0;
    }
}