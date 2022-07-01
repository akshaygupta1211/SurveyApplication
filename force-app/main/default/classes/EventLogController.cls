public with sharing class EventLogController {
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject) {
        String myQuery = null;
        if(searchTerm == null || searchTerm == ''){
            if(myObject == 'Contact' || myObject == 'Lead' || myObject == 'User') {
                myQuery = 'SELECT Id, Name, Email FROM ' + myObject + ' WHERE LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
            } else {
                myQuery = 'SELECT Id, Name FROM ' + myObject + ' WHERE LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
            }

        }
        else {
            if(myObject == 'Contact' || myObject == 'Lead' || myObject == 'User') {
                myQuery = 'SELECT Id, Name, Email FROM ' + myObject + ' WHERE Name Like  \'%' + searchTerm + '%\' LIMIT  5';
            } else {
                myQuery = 'SELECT Id, Name FROM ' + myObject + ' WHERE Name Like  \'%' + searchTerm + '%\' LIMIT  5';
            }

        }
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getPicklistValues(List<String> fieldApiNameList) {
        Map<String, List<String>> fieldNameOptionsListMap = new Map<String, List<String>>();
                
        try{

            SObjectType oType = Schema.getGlobalDescribe().get('Event');
        
            Map<String, Schema.SObjectField> fieldMap = oType.getDescribe().fields.getMap();

            for(String fieldApiName : fieldApiNameList) {
                List<String> options = new List<String>();

                List<Schema.PicklistEntry> ple = fieldMap.get(fieldApiName).getDescribe().getPicklistValues();
            
                for (Schema.PicklistEntry f : ple) {
                   
                    options.add(f.getValue());
                }
                fieldNameOptionsListMap.put(fieldApiName, options);
            }
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return fieldNameOptionsListMap;
    }

    @AuraEnabled
    public static void saveActivity(String recordJSON, Boolean isEvent) {
        try {
            if(isEvent) {
                Event evt = (Event) JSON.deserialize(recordJSON, Event.class);
                //evt.RecordTypeId = GEN_Utility.recordTypeId('Event', 'B2B');
                insert evt;
            } else {
                String toAddresses = '';
                String ccAddresses = '';
                String bccAddresses = '';

                EmailDetailWrapperClass wrapper = (EmailDetailWrapperClass) JSON.deserialize(recordJSON, EmailDetailWrapperClass.class);

                EmailMessage emailMessage = new EmailMessage();
                emailMessage.Status = '1';
                emailMessage.Subject = wrapper.subject;
                emailMessage.TextBody = wrapper.messageBody;
                emailMessage.FromAddress = wrapper.fromAddress.email;
                emailMessage.FromName =  wrapper.fromAddress.name;
                emailMessage.RelatedToId = wrapper.relatedToId;

                if(wrapper.toAddressList.size() > 0) {
                    for(EmailNameWrapperClass wrap : wrapper.toAddressList) {
                        toAddresses = wrap.email + ';' + toAddresses; 
                    }
                    emailMessage.ToAddress = toAddresses;
                }
                if(wrapper.ccAddressList.size() > 0) {
                    for(EmailNameWrapperClass wrap : wrapper.ccAddressList) {
                        ccAddresses = wrap.email + ';' + ccAddresses; 
                    }
                    emailMessage.CcAddress = ccAddresses;
                }
                if(wrapper.bccAddressList.size() > 0) {
                    for(EmailNameWrapperClass wrap : wrapper.bccAddressList) {
                        bccAddresses = wrap.email + ';' + bccAddresses; 
                    }
                    emailMessage.BccAddress = bccAddresses;  
                }                              
                insert emailMessage;

                List<EmailMessageRelation> emrList = new List<EmailMessageRelation>();

                if(wrapper.relatedRecordList.size() > 0) {
                    for(RelatedRecordWrapperClass related : wrapper.relatedRecordList) {
                        EmailMessageRelation emr = new EmailMessageRelation();
                        emr.EmailMessageId = emailMessage.Id;
                        emr.RelationId = related.relatedId;
                        emr.RelationAddress = related.relatedAddress;
                        if(toAddresses.contains(related.relatedAddress)) {
                            emr.RelationType = 'ToAddress';
                        } else if(ccAddresses.contains(related.relatedAddress)) {
                            emr.RelationType = 'CcAddress';
                        } else if(bccAddresses.contains(related.relatedAddress)) {
                            emr.RelationType = 'BccAddress';
                        } else {
                            emr.RelationType = 'ToAddress';
                        } 
                        emrList.add(emr);
                    }
                } 
                if(emrList.size() > 0) {
                    insert emrList; 
                }              
            }

        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }

    } 
    
    @AuraEnabled(cacheable=true)
    public static List<WrapperClass> getRelatedRecords(List<String> emailAddrressesJSON, Boolean isPeople) {
        List<SObject> recordsList = new List<SObject>();
        List<WrapperClass> wrapperList = new List<WrapperClass>();
        try {
            if(isPeople) {
                List<Lead> leadList = [SELECT Id, Name, Email FROM Lead WHERE Email IN: emailAddrressesJSON];

                if(leadList.size() > 0) {
                    recordsList.addAll(leadList);
                } 

                List<Contact> contactList = [SELECT Id, Name, Email FROM Contact WHERE Email IN: emailAddrressesJSON];

                if(contactList.size() > 0) {
                    recordsList.addAll(contactList);
                }   

                List<User> userList = [SELECT Id, Name, Email FROM User WHERE Email IN: emailAddrressesJSON];

                if(userList.size() > 0) {
                    recordsList.addAll(userList);
                }   
            } else {

                List<OpportunityContactRole> oppContactRoleList = [SELECT OpportunityId, Opportunity.Name FROM OpportunityContactRole WHERE Contact.Email IN: emailAddrressesJSON];
    
                if(oppContactRoleList.size() > 0) {
                    recordsList.addAll(oppContactRoleList);
                }    

            }                        
    
            for(Sobject obj : recordsList) {
                WrapperClass wrapper = new WrapperClass();
                if(isPeople) {
                    wrapper.obj = obj;
                    if(String.valueOf(obj.getSObjectType()) == 'Lead') {
                        wrapper.booleanOne = false;
                        wrapper.booleanTwo = false;
                    } else if(String.valueOf(obj.getSObjectType()) == 'Contact') {
                        wrapper.booleanOne = false;
                        wrapper.booleanTwo = true;
                    } else if(String.valueOf(obj.getSObjectType()) == 'User') {
                        wrapper.booleanOne = true;
                        wrapper.booleanTwo = false;
                    }
                } else {
                    if(String.valueOf(obj.getSObjectType()) == 'AccountContactRelation') {
                        wrapper.obj = obj;
                        wrapper.booleanOne = false;
                        wrapper.booleanTwo = false;
                        wrapper.booleanThree = false;
                    } else if(String.valueOf(obj.getSObjectType()) == 'OpportunityContactRole') {
                        wrapper.obj = obj;
                        wrapper.booleanOne = true;
                        wrapper.booleanTwo = true;
                        wrapper.booleanThree = false;
                    } else if(String.valueOf(obj.getSObjectType()) == 'Application__c') {
                        wrapper.obj = obj;
                        wrapper.booleanOne = false;
                        wrapper.booleanTwo = false;
                        wrapper.booleanThree = true;
                    }                    
                }
                wrapperList.add(wrapper);
            }
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return wrapperList;
    }    

    public class WrapperClass {
        @AuraEnabled public SObject obj {get;set;}
        @AuraEnabled public Boolean booleanOne {get;set;}
        @AuraEnabled public Boolean booleanTwo {get;set;}
        @AuraEnabled public Boolean booleanThree {get;set;}
    }

    public class EmailNameWrapperClass {
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String email {get;set;}
    }

    public class RelatedRecordWrapperClass {
        @AuraEnabled public String relatedId {get;set;}
        @AuraEnabled public String relatedAddress {get;set;}        
    }

    public class EmailDetailWrapperClass {
        @AuraEnabled public String subject {get;set;}
        @AuraEnabled public String relatedToId {get;set;}
        @AuraEnabled public String messageBody {get;set;}
        @AuraEnabled public List<RelatedRecordWrapperClass> relatedRecordList {get;set;}
        @AuraEnabled public EmailNameWrapperClass fromAddress {get;set;}
        @AuraEnabled public List<EmailNameWrapperClass> toAddressList {get;set;}
        @AuraEnabled public List<EmailNameWrapperClass> ccAddressList {get;set;}
        @AuraEnabled public List<EmailNameWrapperClass> bccAddressList {get;set;}
    }
}
