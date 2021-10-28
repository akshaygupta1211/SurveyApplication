import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import submitSurvey from '@salesforce/apex/SurveyController.submitSurvey';
import getDetails from '@salesforce/apex/SurveyController.getDetails';

export default class SurveyComponent extends LightningElement {

    surveyWrapper;
    errorMessage;
    isCheckbox = true;
    isRadioButton = false;
    questions = [];

    @wire(getDetails) 
    wiredSurvey({data, error}) {
        if(data) {
            this.surveyWrapper = data;
            this.questions = data.questions;        
        } else if(error) {
            this.errorMessage = error.body.message;
            console.log('error: ' + this.errorMessage)
        }
    };

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