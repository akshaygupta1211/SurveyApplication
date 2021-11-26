import { LightningElement, api, wire, track } from 'lwc';
import getRelatedRecords from '@salesforce/apex/LHC_EventLogController.getRelatedRecords';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import RECORDSELECTED from '@salesforce/messageChannel/RecordSelectedChannel__c';

export default class PeopleInEmailComponent extends LightningElement {
    buttonLabel = 'Select All';
    relatedRecordExist = false;
    isButtonDisabled = false;
    @api relatedrecords = [];
    emailAddressesJSON;
    emailAddresses = [];
    @track peopleRecords = [];
    subscription = null;
    emailSelectedList = [];
    @track emailSelectedListJSON;
    errorMessage = 'No records to display';
    
    @wire(MessageContext)
    messageContext;

    @wire(getRelatedRecords, {emailAddrressesJSON : '$emailAddressesJSON'})
    relatedRecordWired({error, data}) {
        if(data) {
            for(let i = 0; i < data.length; i++) {
                this.peopleRecords.push(data[i]);
            }
            if(this.peopleRecords.length == 0) {
                this.relatedRecordExist = false;
            }
        } else if(error) {
            this.errorMessage = error.body.message;
        }
    }    

    connectedCallback() {
        if(this.relatedrecords != undefined) {
            this.relatedRecordExist = true;
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
            if(recordId.startsWith('00Q')) {
                this.peopleRecords.push(
                {
                    'obj' : {
                        'Email' : email,
                        'Id' : recordId,
                        'Name' : name
                    },
                    'objectType' : true
                });
            } else if(recordId.startsWith('003')) {
                this.peopleRecords.push(
                {
                    'obj' : {
                        'Email' : email,
                        'Id' : recordId,
                        'Name' : name
                    },
                    'objectType' : false
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

        if(this.emailSelectedList.length != 0 && this.emailSelectedList.length == this.peopleRecords.length) {
            this.buttonLabel = 'Unselect All';
        }
    }

    handleRecordSelectClick(event) {
        if(this.buttonLabel == 'Select All') {
            this.buttonLabel = 'Unselect All';
            this.template
            .querySelectorAll('[data-element="people-checkbox"]')
            .forEach((element) => {
                element.checked = true;
            });            
            this.emailSelectedList = [];           
            for(let i = 0; i < this.peopleRecords.length; i++) {
                this.emailSelectedList.push({'relatedId': this.peopleRecords[i].obj.Id, 'relatedAddress' : this.peopleRecords[i].obj.Email});
            }
            this.isButtonDisabled = false;
        }

        if(this.buttonLabel == 'Unselect All') {
            this.buttonLabel = 'Select All';
            this.template
            .querySelectorAll('[data-element="people-checkbox"]')
            .forEach((checkBox) => {
                checkBox.checked = false;
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