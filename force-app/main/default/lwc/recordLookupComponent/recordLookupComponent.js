import { api, LightningElement, track, wire } from 'lwc';
import { publish, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import RECORDSELECTED from '@salesforce/messageChannel/RecordSelectedChannel__c';
import lookUp from '@salesforce/apex/EventLogController.search';

export default class RecordLookupComponent extends LightningElement {
    searchTerm;

    @api objName;
    @api iconName;
    @api searchPlaceholder;

    @track selectedName;
    @track records;
    @track isValueSelected;
    @track blurTimeout;

    @wire(MessageContext)
    messageContext;

    //css
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';
    @wire(lookUp, {searchTerm : '$searchTerm', myObject : '$objName'})
    wiredRecords({ error, data }) {
        if (data) {
            this.error = undefined;
            this.records = data;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }

    handleClick() {
        this.searchTerm = '';
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }

    onBlur() {
        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);
    }

    onSelect(event) {
        let selectedId = event.currentTarget.dataset.id;
        let selectedName = event.currentTarget.dataset.name;
        let selectedEmail;
        if(this.objName == 'Contact' || this.objName == 'Lead' || this.objName == 'User') {
            selectedEmail = event.currentTarget.dataset.email
        }
        this.sendMessageService(selectedId, selectedName, selectedEmail);
        const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  selectedId });
        this.dispatchEvent(valueSelectedEvent);
        this.selectedName = selectedName;
        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }

    handleRemovePill() {
        this.isValueSelected = false;
    }

    onChange(event) {
        this.searchTerm = event.target.value;
    }

    sendMessageService(recordId, recordName, recordAddress) {
        var payLoad = {};
        if(this.objName == 'Contact' || this.objName == 'Lead' || this.objName == 'User') {
            payLoad = {
                recordId : recordId,
                recordName : recordName,
                recordAddress : recordAddress
            }
        } else {
            payLoad = {
                recordId : recordId,
                recordName : recordName
            }            
        }
        publish(this.messageContext, RECORDSELECTED, payLoad, {scope : APPLICATION_SCOPE});
    }    
}