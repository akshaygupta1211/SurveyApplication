import { LightningElement, wire, track } from 'lwc';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import RECORDSELECTED from '@salesforce/messageChannel/RecordSelectedChannel__c';

export default class OthersInEmailComponent extends LightningElement {
    value = '';
    booleanOne = false;
    booleanTwo = false;
    booleanThree = false;
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
        console.log(message);
        if(recordId != undefined && name != undefined) {
            if(recordId.startsWith('001')) {
                this.otherRecords.push(
                {
                    'obj' : {
                        'Id' : recordId,
                        'Name' : name
                    },
                    'booleanOne' : false,
                    'booleanTwo' : false,
                    'booleanThree' : false
                });
            } else if(recordId.startsWith('500')) {
                this.otherRecords.push(
                {
                    'obj' : {
                        'Id' : recordId,
                        'Name' : name
                    },
                    'booleanOne' : true,
                    'booleanTwo' : false,
                    'booleanThree' : false
                });                
            } else if(recordId.startsWith('800')) {
                this.otherRecords.push(
                {
                    'obj' : {
                        'Id' : recordId,
                        'Name' : name
                    },
                    'booleanOne' : false,
                    'booleanTwo' : true,
                    'booleanThree' : false
                });                
            } else if(recordId.startsWith('006')) {
                this.otherRecords.push(
                {
                    'obj' : {
                        'Id' : recordId,
                        'Name' : name
                    },
                    'booleanOne' : true,
                    'booleanTwo' : true,
                    'booleanThree' : false
                });                
            } else if(recordId.startsWith('aKv')) {
                this.otherRecords.push(
                {
                    'obj' : {
                        'Id' : recordId,
                        'Name' : name
                    },
                    'booleanOne' : false,
                    'booleanTwo' : false,
                    'booleanThree' : true
                });                
            }
            console.log(this.otherRecords[0].obj); 
        }
    }  

    renderedCallback() {
        this.template
        .querySelectorAll('[data-element="other-radio"]')
        .forEach((element) => {
            element.checked = true;
        });   
    }
}