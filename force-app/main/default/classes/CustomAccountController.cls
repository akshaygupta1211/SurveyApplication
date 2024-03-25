/**
 * @description Custom controller class used by lwc(s) and aura components
 * to return records, insert and get account's metadata.
 * @author Akshay Gupta
 */
public with sharing class CustomAccountController {
  /**
   * @description Method for inserting account record and returning recordId
   * @param String name, String type
   * @return String
   */
  @AuraEnabled
  public static String addAccount(String name, String type) {
    Account a = new Account();
    try {
      a.Name = name;
      a.Type = type;
      if (Schema.sObjectType.Account.isCreateable()) {
        insert a;
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return a.Id;
  }

  /**
   * @description Method for options in Type picklist
   * @return List<String>
   */
  @AuraEnabled
  public static List<String> getOptions() {
    Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    List<String> options = new List<String>();
    for (Schema.PicklistEntry f : ple) {
      options.add(f.getValue());
    }

    return options;
  }

  /**
   * @description Method for returning all accounts created today
   * @return List<Contact>
   */
  @AuraEnabled
  public static List<Account> fetchAccounts() {
    return [SELECT Name, Type FROM Account WHERE CreatedDate=TODAY WITH SECURITY_ENFORCED];
  }
}
