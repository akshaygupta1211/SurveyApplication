import { LightningElement, wire, track, api } from 'lwc';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import RECORDSELECTED from '@salesforce/messageChannel/RecordSelectedChannel__c';
import getRelatedRecords from '@salesforce/apex/EventLogController.getRelatedRecords';

export default class OthersInEmailComponent extends LightningElement {
    value = 'None';
    emailAddressesJSON;
    subscription = null;
    emailAddresses = [];
    @api relatedrecords = [];

    @track otherRecords = [];

    get options() {
        return [
            { label: '', value: 'none' }
        ];
    }

    @wire(MessageContext)
    messageContext;

    @wire(getRelatedRecords, {emailAddrressesJSON : '$emailAddressesJSON', isPeople : false})
    relatedRecordWired({error, data}) {
        if(data) {
            for(let i = 0; i < data.length; i++) {
                if(data[i].booleanOne == false &&  data[i].booleanTwo == false && data[i].booleanThree == false) {
                    let tempObj = {
                        'Id' : data[i].obj.AccountId,
                        'Name' : data[i].obj.Account.Name,
                        'booleanOne' : false,
                        'booleanTwo' : false,
                        'booleanThree' : false
                    }
                    this.otherRecords.push(tempObj);
                }
                if(data[i].booleanOne == true &&  data[i].booleanTwo == true && data[i].booleanThree == false) {
                    let tempObj = {
                        'Id' : data[i].obj.AccountId,
                        'Name' : data[i].obj.Account.Name,
                        'booleanOne' : false,
                        'booleanTwo' : false,
                        'booleanThree' : false
                    }
                    this.otherRecords.push(tempObj);
                }
                if(data[i].booleanOne == true &&  data[i].booleanTwo == false && data[i].booleanThree == true) {
                    let tempObj = {
                        'Id' : data[i].obj.Id,
                        'Name' : data[i].obj.Subject,
                        'booleanOne' : true,
                        'booleanTwo' : false,
                        'booleanThree' : true
                    }
                    this.otherRecords.push(tempObj);
                }                
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
            } else if(recordId.startsWith('500')) {
                this.otherRecords.push(
                {
                    'Id' : recordId,
                    'Name' : name,
                    'booleanOne' : true,
                    'booleanTwo' : false,
                    'booleanThree' : true
                });                
            }
        }
    }  

    handleRecordSelection(event) {
        let recordId = event.target.dataset.id;

        const selectedEvent = new CustomEvent('otherselection', 
        { 
            detail : {
                selectedOther: recordId
            } 
        });

        this.dispatchEvent(selectedEvent); 
    }
}