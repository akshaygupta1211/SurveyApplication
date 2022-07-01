import { LightningElement, api } from 'lwc';
import checkViewAccess from '@salesforce/apex/CustomContactController.checkViewAccess';

export default class LinkedInCRMSyncInfoSection extends LightningElement {
    @api recordId;
    @api objectApiName;

    connectedCallback() {
        checkViewAccess()
        .then(() => {
        })
        .catch(error => {
            console.log('error: ' + error.body.message);
        });        
    }
}