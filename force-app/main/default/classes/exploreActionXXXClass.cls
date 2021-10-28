public class exploreActionXXXClass {
    public String someText {set;get;}
    Public Integer sum {set;get;}
    Public String finalText {set;get;}
    
    Integer count = 0;
			
    public PageReference incrementCounter() {
        count++;
        return null;
    }
			
    public Integer getCount() {
        return count;
    }
    
    public PageReference calculateSum() {
        sum = 5;
        finalText = '(Done)';
        return null;
    }
    
    public void callMe() {
        someText = 'What\'s up man';
    }
    
}