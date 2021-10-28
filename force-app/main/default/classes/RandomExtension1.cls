public class RandomExtension1 {
    private Account acct;
    
    public RandomExtension1(ApexPages.StandardController controller) {
        this.acct = (Account)controller.getRecord();
    }
    
    public void doSomething() {
        System.debug('Yo!!!!');
    }
}