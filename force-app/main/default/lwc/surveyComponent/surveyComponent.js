import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import submitSurvey from '@salesforce/apex/SurveyController.submitSurvey';

export default class SurveyComponent extends LightningElement {

    connectedCallback() {
        
    }

    handleClick(event) {

    }

    showToast(title, variant, message) {
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }

}