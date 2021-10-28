public class RandomExtension2 {
    private Account acct;
    
    public RandomExtension2(ApexPages.StandardController controller) {
        this.acct = (Account)controller.getRecord();
    }
    
    public void doSomething() {
        System.debug('Yup!!!');
    }
}