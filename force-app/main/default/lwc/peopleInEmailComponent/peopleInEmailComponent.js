import { LightningElement, api, wire, track } from 'lwc';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import getRelatedRecords from '@salesforce/apex/EventLogController.getRelatedRecords';
import RECORDSELECTED from '@salesforce/messageChannel/RecordSelectedChannel__c';

export default class PeopleInEmailComponent extends LightningElement {
    errorMessage = 'No records to display';
    isButtonDisabled = false;
    emailAddressesJSON;
    subscription = null;
    emailAddresses = [];
    emailSelectedList = [];

    @api relatedrecords = [];
    
    @track checkboxVal = false;
    @track relatedRecordExist = false;
    @track buttonLabel = 'Select All';
    @track peopleRecords = [{
        'obj' : {
            'Email' : '',
            'Id' : '',
            'Name' : ''
        },
        'booleanOne' : true,
        'booleanTwo' : true,
    }];
    @track emailSelectedListJSON;
    
    @wire(MessageContext)
    messageContext;

    @wire(getRelatedRecords, {emailAddrressesJSON : '$emailAddressesJSON', isPeople : true})
    relatedRecordWired({error, data}) {
        if(data) {
            for(let i = 0; i < data.length; i++) {
                this.peopleRecords.push(data[i]);
            }
            if(this.peopleRecords.length > 1) {
                this.relatedRecordExist = true;
            }
        } else if(error) {
            this.errorMessage = error.body.message;
        }
    }    

    connectedCallback() {
        if(this.relatedrecords != undefined) {
            for(let i = 0; i < this.relatedrecords.length; i++) {
                this.emailAddresses.push(this.relatedrecords[i].email);
            }
        }
        this.emailAddressesJSON = JSON.stringify(this.emailAddresses);
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }    

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                RECORDSELECTED,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    // Handler for message received by component
    handleMessage(message) {
        let recordId = message.recordId;
        let email = message.recordAddress;
        let name = message.recordName;
        if(email != undefined) {
            this.relatedRecordExist = true;
            if(recordId.startsWith('00Q')) {
                this.peopleRecords.push(
                {
                    'obj' : {
                        'Email' : email,
                        'Id' : recordId,
                        'Name' : name
                    },
                    'booleanOne' : false,
                    'booleanTwo' : false,
                });
            } else if(recordId.startsWith('003')) {
                this.peopleRecords.push(
                {
                    'obj' : {
                        'Email' : email,
                        'Id' : recordId,
                        'Name' : name
                    },
                    'booleanOne' : false,
                    'booleanTwo' : true,
                });           
            } else if(recordId.startsWith('005')) {
                this.peopleRecords.push(
                {
                    'obj' : {
                        'Email' : email,
                        'Id' : recordId,
                        'Name' : name
                    },
                    'booleanOne' : true,
                    'booleanTwo' : false,
                });                
            }            
        }
    }    

    handleCheckboxSelection(event) {        
        let recordId = event.currentTarget.dataset.id;
        let email = event.currentTarget.dataset.email;

        this.emailSelectedList.push({'relatedId': recordId, 'relatedAddress' : email});

        const selectedEvent = new CustomEvent('peopleselection', 
        { 
            detail : {
                selectedPeople: this.emailSelectedList
            } 
        });

        this.dispatchEvent(selectedEvent); 

        if(this.emailSelectedList.length != 0 && this.emailSelectedList.length == this.peopleRecords.length - 1) {
            this.buttonLabel = 'Unselect All';
        }
    }

    handleRecordSelectClick(event) {
        if(this.buttonLabel == 'Select All') {
            this.buttonLabel = 'Unselect All';
            this.checkboxVal = true;            
            this.emailSelectedList = [];           
            for(let i = 0; i < this.peopleRecords.length; i++) {
                this.emailSelectedList.push({'relatedId': this.peopleRecords[i].obj.Id, 'relatedAddress' : this.peopleRecords[i].obj.Email});
            }
            this.isButtonDisabled = false;
        } else if(this.buttonLabel == 'Unselect All') {
            this.buttonLabel = 'Select All';
            this.checkboxVal = false; 
            this.template
            .querySelectorAll('[data-element="people-checkbox"]')
            .forEach((element) => {
                element.checked = false;
            });             
            this.emailSelectedList = [];
            this.isButtonDisabled = true;
        }

        const selectedEvent = new CustomEvent('peopleselection', 
        { 
            detail : {
                selectedPeople: this.emailSelectedList
            } 
        });

        this.dispatchEvent(selectedEvent);         

    }
}