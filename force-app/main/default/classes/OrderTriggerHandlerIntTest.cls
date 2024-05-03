@isTest
public class OrderTriggerHandlerIntTest {
    
    /**
    *@description method for preparing test data
    *
    */
    @TestSetup
    static void prepareData(){
        Account testAccount = new Account();
        testAccount.Name = 'Test account LLP';
        insert testAccount;

        Contact testContact = new Contact();
        testContact.LastName = 'Guster';
        testContact.FirstName = 'Burton';
        testContact.Salutation = '';
        testContact.AccountId = testAccount.Id;
        insert testContact;

        Contract testContract = new Contract();
        testContract.AccountId = testAccount.Id;
        testContract.CustomerSignedId = testContact.Id;
        testContract.Status = 'Draft';
        testContract.StartDate = Date.today().addDays(-30);
        testContract.ContractTerm = 12;
        testContract.CustomerSignedDate = Date.today().addDays(-35);
        testContract.CompanySignedId = UserInfo.getUserId();
        testContract.CompanySignedDate = Date.today().addDays(-30);
        insert testContract;

        testContract.Status = 'Activated';
        update testContract;
    }

    @isTest
    public static void createOrder() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        Test.startTest();

        Order newOrder = new Order();
        newOrder.AccountId = testAccount.Id;
        newOrder.CustomerAuthorizedById = testContact.Id;
        newOrder.CompanyAuthorizedById = UserInfo.getUserId();
        newOrder.Status = OrderTriggerHelperInt.ORDER_STATUS_DRAFT;
        newOrder.EffectiveDate = Date.today();
        newOrder.Category__c = 'Office-Supplies';
        newOrder.Value__c = 899.99;
        newOrder.Location__c = 'Heaven';
        insert newOrder;

        Test.getEventBus().deliver();

        Test.stopTest();

    }

    /**
    *@description test method for simulating exception in application
    *
    */
    @isTest
    public static void testGenerateException() {
        try {
            OrderTriggerHelperInt.sendOrderToProcess(null);
        } catch(Exception ex) {
            System.assertEquals('OrderTriggerHelperInt.OrderTriggerHelperIntException', ex.getTypeName(), 'Exception should be thrown.');
        }
    }     
}