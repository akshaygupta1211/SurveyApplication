import { LightningElement, wire, track } from 'lwc';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import RECORDSELECTED from '@salesforce/messageChannel/RecordSelectedChannel__c';

export default class OthersInEmailComponent extends LightningElement {
    value = 'None';
    subscription = null;

    @track otherRecords = [];

    get options() {
        return [
            { label: '', value: 'none' }
        ];
    }

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
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
        let name = message.recordName;
        if(recordId != undefined && name != undefined) {
            if(recordId.startsWith('001')) {
                this.otherRecords.push(
                {
                    'Id' : recordId,
                    'Name' : name,
                    'booleanOne' : false,
                    'booleanTwo' : false,
                    'booleanThree' : false
                });
            } else if(recordId.startsWith('500')) {
                this.otherRecords.push(
                {
                    'Id' : recordId,
                    'Name' : name,
                    'booleanOne' : true,
                    'booleanTwo' : false,
                    'booleanThree' : false
                });                
            } else if(recordId.startsWith('800')) {
                this.otherRecords.push(
                {
                    'Id' : recordId,
                    'Name' : name,
                    'booleanOne' : false,
                    'booleanTwo' : true,
                    'booleanThree' : false
                });                
            } else if(recordId.startsWith('006')) {
                this.otherRecords.push(
                {
                    'Id' : recordId,
                    'Name' : name,
                    'booleanOne' : true,
                    'booleanTwo' : true,
                    'booleanThree' : false
                });                
            } else if(recordId.startsWith('aKv')) {
                this.otherRecords.push(
                {
                    'Id' : recordId,
                    'Name' : name,
                    'booleanOne' : false,
                    'booleanTwo' : false,
                    'booleanThree' : true
                });                
            }
        }
    }  

    renderedCallback() {
        this.template
        .querySelectorAll('[data-element="other-radio"]')
        .forEach((element) => {
            element.checked = true;
        });   
    }

    handleRecordSelection(event) {
        let recordId = event.target.dataset.id;
        let value = event.detail.value;  
        if(value == 'None') {
            recordId = null;
        } 

        const selectedEvent = new CustomEvent('otherselection', 
        { 
            detail : {
                selectedOther: recordId
            } 
        });

        this.dispatchEvent(selectedEvent); 
    }
}