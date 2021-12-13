import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPicklistValues from '@salesforce/apex/EventLogController.getPicklistValues';
import saveActivity from '@salesforce/apex/EventLogController.saveActivity';

export default class LogActivityComponent extends LightningElement {
    whoTypeValue;
    whatTypeValue;
    buttonLabel;
    heading;
    errorMessage;
    startDateTimeValue;
    endDateTimeValue;
    showForm = false;
    isEvent = false;
    showField = false;
    isLoaded = false;
    isButtonDisabled = false;
    disableSubPurpose = true;    
    purposeOptions = []; 
    subPurposeOptions = [];
    eventTypeOptions = [];
    relatedRecords = [];
    selectedPeopleRecords = [];
    objectNameIconList = [
        {'Name' : 'Account', 'IconName' : 'standard:account', 'Value' : 'Account'},
        {'Name' : 'Contact', 'IconName' : 'standard:contact', 'Value' : 'Contact'},
        {'Name' : 'Contract', 'IconName' : 'standard:contract', 'Value' : 'Contract'},
        {'Name' : 'Lead', 'IconName' : 'standard:lead', 'Value' : 'Lead'},
        {'Name' : 'Opportunity', 'IconName' : 'standard:opportunity', 'Value' : 'Opportunity'},
        {'Name' : 'User', 'IconName' : 'standard:user', 'Value' : 'User'}, 
        {'Name' : 'Application', 'IconName' : 'custom:custom72', 'Value' : 'Application__c'},                                                
    ];

    @api flexipageRegionWidth;
    @api messageBody;
    @api subject;
    @api people;
    @api source;
    @api location;
    @api dates;
    @api emails;

    @track whatMenuIcon = 'standard:account';         
    @track purposeValue;
    @track subPurposeValue;
    @track selectedWhatObject = 'Account';
    @track whatPlaceholder = 'Search Accounts...';

    @wire(getPicklistValues, { fieldApiNameList: ['Purpose__c', 'Type'] })
    picklistOptionsWired({error, data}) {
        if(data) {
            if(data.Purpose__c != undefined) {
                for(let i = 0; i < data.Purpose__c.length; i++) {
                    this.purposeOptions.push({ label : data.Purpose__c[i], value : data.Purpose__c[i]});
                }
            }
            if(data.Type != undefined) {
                for(let i = 0; i < data.Type.length; i++) {
                    this.eventTypeOptions.push({ label : data.Type[i], value : data.Type[i]});
                }
            }
            this.isLoaded = true;
        } else if(error) {
            this.isLoaded = true;
            this.showToast(error.body.message, "error", "sticky");
        }
    }  

    connectedCallback() {
        if(this.source != undefined && this.source == 'email') {
            this.buttonLabel = 'Log Email';
            this.heading = 'Log Email';
            this.isEvent = false;
            this.showField = false;
        }
        if(this.source != undefined && this.source == 'event') {
            this.buttonLabel = 'Log Event';
            this.heading = 'Log Event';
            this.isEvent = true;
            this.showField = true;
        }        
    }

    renderedCallback() {
        if(this.people != undefined) {
            if(this.isEvent) {
                if(this.people.organizer != undefined) {                   
                    this.relatedRecords.push(this.people.organizer);
                }
                if(this.people.requiredAttendees != undefined) {
                    for(let i = 0; i< this.people.requiredAttendees.length; i ++) {
                        this.relatedRecords.push(this.people.requiredAttendees[i]);
                    }
                }
                if(this.people.optionalAttendees != undefined) {
                    for(let i = 0; i< this.people.optionalAttendees.length; i ++) {
                        this.relatedRecords.push(this.people.optionalAttendees[i]);
                    }
                } 
            } else {
                if(this.people.from != undefined) {
                    this.relatedRecords.push(this.people.from);
                }
                if(this.people.to != undefined) {
                    for(let i = 0; i< this.people.to.length; i ++) {
                        this.relatedRecords.push(this.people.to[i]);
                    }
                }
                if(this.people.cc != undefined) {
                    for(let i = 0; i< this.people.cc.length; i ++) {
                        this.relatedRecords.push(this.people.cc[i]);
                    }
                } 
                if(this.people.bcc != undefined) {
                    for(let i = 0; i< this.people.bcc.length; i ++) {
                        this.relatedRecords.push(this.people.cc[i]);
                    }
                }                  
            }                                 
        }
    }

    handleButtonClick(event) {
        this.showForm = true;
    }

    handleCancel(event) {
        this.showForm = false;
    }

    handleWhatMenuSelect(event) {
        // retrieve the selected item's value
        const selectedItemValue = event.detail.value;

        if(selectedItemValue == 'Account') {
            this.whatPlaceHolder = 'Search Accounts...';
            this.selectedWhatObject = 'Account';
            this.whatMenuIcon = 'standard:account';
        } else if(selectedItemValue == 'Contact') {
            this.whatPlaceHolder = 'Search Contacts...';
            this.selectedWhatObject = 'Contact';
            this.whatMenuIcon = 'standard:contact';
        } else if(selectedItemValue == 'Contract') {
            this.whatPlaceHolder = 'Search Contracts...';
            this.selectedWhatObject = 'Contract';
            this.whatMenuIcon = 'standard:contract';
        } else if(selectedItemValue == 'Lead') {
            this.whatPlaceHolder = 'Search Leads...';
            this.selectedWhatObject = 'Lead';
            this.whatMenuIcon = 'standard:lead';
        } else if(selectedItemValue == 'Opportunity') {
            this.whatPlaceHolder = 'Search Opportunities...';
            this.selectedWhatObject = 'Opportunity';
            this.whatMenuIcon = 'standard:opportunity';
        } else if(selectedItemValue == 'User') {
            this.whatPlaceHolder = 'Search Users...';
            this.selectedWhatObject = 'User';
            this.whatMenuIcon = 'standard:user';
        } else if(selectedItemValue == 'Application__c') {
            this.whatPlaceHolder = 'Search Applications...';
            this.selectedWhatObject = 'Application__c';
            this.whatMenuIcon = 'custom:custom72';
        } else if(selectedItemValue == 'Case') {
            this.whatPlaceHolder = 'Search Cases...';
            this.selectedWhatObject = 'Case';
            this.whatMenuIcon = 'standard:case';
        }              
    }  
    
    handleWhatSelection(event) {
        if(event.detail.startsWith('003') || event.detail.startsWith('00Q') || event.detail.startsWith('005')) {
            this.whoTypeValue = event.detail;
        } else {
            if(event.detail != 'null') {
                this.whatTypeValue = event.detail;
            }
        }
    }
    
    handleSubPurposeChange(event) {
        this.subPurposeValue = event.detail.value;
    }

    handlePurposeChange(event) {
        this.purposeValue = event.detail.value;

        if(this.purposeValue == 'Commercial Interaction') {
            this.disableSubPurpose = false;
            this.subPurposeOptions = [
                { label : 'Advisory', value : 'Advisory' },
                { label : 'CP', value : 'CP' },
                { label : 'NEXUS', value : 'NEXUS' },
                { label : 'OP/Teams/Portfolio Review', value : 'OP/Teams/Portfolio Review' },
            ];
        } else if(this.purposeValue == 'Operational') {
            this.disableSubPurpose = false;
            this.subPurposeOptions = [
                { label : 'Contracting', value : 'Contracting' },
                { label : 'Invoicing', value : 'Invoicing' },
                { label : 'LMS Integration', value : 'LMS Integration' },
                { label : 'Program delivery related', value : 'Program delivery related' },
            ];            
        } else if(this.purposeValue == 'Relationship Building') {
            this.disableSubPurpose = false;
            this.subPurposeOptions = [
                { label : 'Account Planning/Review', value : 'Account Planning/Review' },
                { label : 'Check-in Discussion', value : 'Check-in Discussion' },
                { label : 'Event/Program Invitation', value : 'Event/Program Invitation' },
                { label : 'Strategic Contact Engagement', value : 'Strategic Contact Engagement' },
            ];            
        } else if(this.purposeValue == 'Faculty Touchpoint') {
            this.disableSubPurpose = true;
            this.subPurposeOptions = [];
        }        
    }
    
    handlePeopleSelection(event) {
        this.selectedPeopleRecords = event.detail.selectedPeople;
        if(this.selectedPeopleRecords != undefined && this.selectedPeopleRecords.length > 0) {
            this.whoTypeValue = this.selectedPeopleRecords[0].relatedId;
            this.isButtonDisabled = false;
        } 
    }    

    handleOtherSelection(event) {
        if(event.detail.selectedOther != 'null') {
            this.whatTypeValue = event.detail.selectedOther;
        }
    }    
    
    handleSave(event) {
        this.isLoaded = false;
        this.isButtonDisabled = true;
        if(this.source != undefined && this.source == 'event') {
            this.record = {
                'Subject' : this.subject,
                'Description' : this.messageBody,                
                'WhoId' : this.whoTypeValue,
                'Location' : this.location,
                'WhatId' : this.whatTypeValue,
                'StartDateTime' : this.dates.start,
                'EndDateTime' : this.dates.end,
                'Purpose__c' : this.purposeValue,
                'Sub_Purpose__c' : this.subPurposeValue        
            };
        } else if(this.source != undefined && this.source == 'email') {
            let from = {
                'name' : this.people.from.name, 
                'email' : this.people.from.email
            };
            let toList = [];
            if(this.people != undefined && this.people.to != undefined) {
                for(let i = 0; i < this.people.to.length; i++) {
                    toList.push({'name' : this.people.to[i].name, 'email' : this.people.to[i].email});
                }
            }
            let ccList = [];
            if(this.people != undefined && this.people.cc != undefined) {
                for(let i = 0; i < this.people.cc.length; i++) {
                    ccList.push({'name' : this.people.cc[i].name, 'email' : this.people.cc[i].email});
                }
            }
            let bccList = [];
            if(this.people != undefined && this.people.bcc != undefined) {
                for(let i = 0; i < this.people.bcc.length; i++) {
                    bccList.push({'name' : this.people.bcc[i].name, 'email' : this.people.bcc[i].email});
                }
            }                                    
            this.record = {
                'fromAddress' : from,
                'toAddressList' : toList,
                'ccAddressList' : ccList,
                'bccAddressList' : bccList,
                'subject' : this.subject,
                'messageBody' : this.messageBody,
                'relatedRecordList' : this.selectedPeopleRecords,
                'relatedToId' : this.whatTypeValue   
            };
        }
        saveActivity({recordJSON : JSON.stringify(this.record), isEvent : this.isEvent})
        .then(() => {
            this.isLoaded = true;
            this.showForm = false;
            if(this.source != undefined && this.source == 'email') {
                this.showToast('Email related!', "success", "dismissable");
            } else if(this.source != undefined && this.source == 'event') {
                this.showToast('Event related!', "success", "dismissable");
            }
        })
        .catch(error => {
            this.isLoaded = true;
            this.isButtonDisabled = false;
            this.showToast(error.body.message, "error", "sticky");
        });
    }

    showToast(message, variant, mode) {
        const event = new ShowToastEvent({
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }      
}