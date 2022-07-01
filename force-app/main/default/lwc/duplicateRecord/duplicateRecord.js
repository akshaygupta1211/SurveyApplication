import { LightningElement, wire, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getDuplicateRecordListByIds from '@salesforce/apex/CustomContactController.findById';

export default class DuplicateRecordComponent extends NavigationMixin(LightningElement) {
    contacts = [];
    @api contIds = [];
    err;
    @api showModal; 
    @track noOfContacts = 0;  

    @wire(getDuplicateRecordListByIds, {contIds: '$contIds'})
    wiredContacts({error, data}) { 
        if (data) {
            this.contacts = data;
            this.noOfContacts = this.contacts.length;
        } else if (error) {
            this.err = error.body.message;
        }      
    }

    handleDialogClose() {
        this.showModal = false;
    }

    navigateToContactRecordViewPage(event) {
        let contactId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: contactId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }   
    
    navigateToAccountRecordViewPage(event) {
        let accountId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }       
}