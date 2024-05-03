@isTest
public class OrderEventTriggerHandlerIntTest {
    
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

        Product2 penProduct = new Product2();
        penProduct.Name = 'Pen';
        penProduct.ProductCode = 'PN720';
        penProduct.IsActive = true;
        insert penProduct;

        PricebookEntry penPriceBook = new PricebookEntry();
        penPriceBook.Product2Id = penProduct.Id;
        penPriceBook.IsActive = true;
        penPriceBook.UnitPrice = 90;
        penPriceBook.Pricebook2Id = Test.getStandardPricebookId();
        penPriceBook.UseStandardPrice = false;
        insert penPriceBook;

        Order newOrder = new Order();
        newOrder.AccountId = testAccount.Id;
        newOrder.CustomerAuthorizedById = testContact.Id;
        newOrder.CompanyAuthorizedById = UserInfo.getUserId();
        newOrder.Status = OrderTriggerHelperInt.ORDER_STATUS_DRAFT;
        newOrder.EffectiveDate = Date.today();
        newOrder.Category__c = 'Office-Supplies';
        newOrder.Value__c = 899.99;
        newOrder.Location__c = 'Heaven';
        newOrder.Pricebook2Id = Test.getStandardPricebookId();
        insert newOrder;

        OrderItem newOrderItem = new OrderItem();
        newOrderItem.OrderId = newOrder.Id;
        newOrderItem.PricebookEntryId = penPriceBook.Id;
        newOrderItem.Quantity = 10;
        newOrderItem.UnitPrice = penPriceBook.UnitPrice;
        insert newOrderItem;

        Order_Event__e orderEvent = new Order_Event__e();
        orderEvent.Record_Id__c = newOrder.Id;
        orderEvent.Location__c = newOrder.Location__c;
        orderEvent.Category__c = newOrder.Category__c;
        orderEvent.Status__c = OrderEventTriggerHelperInt.ORDER_STATUS_ACTIVATED;
        orderEvent.Value__c = newOrder.Value__c;

        EventBus.publish(orderEvent);

        Test.getEventBus().deliver();

        Test.stopTest();

        Assert.areEqual(OrderEventTriggerHelperInt.ORDER_STATUS_ACTIVATED, [SELECT Status FROM Order WHERE Id =: newOrder.Id].Status, 'Order should be activated.');
    }

    /**
    *@description test method for simulating exception in application
    *
    */
    @isTest
    public static void testGenerateException() {
        try {
            OrderEventTriggerHelperInt.updateOrderStatus(null, null);
        } catch(Exception ex) {
            Assert.areEqual('OrderEventTriggerHelperInt.OrderEventTriggerHelperIntException', ex.getTypeName(), 'Exception should be thrown.');
        }
    }     
}