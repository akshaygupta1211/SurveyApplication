import { LightningElement, api } from 'lwc';
import checkViewAccess from '@salesforce/apex/HND_ContactHandler.checkViewAccess';

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