import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import submitSurvey from '@salesforce/apex/SurveyController.submitSurvey';
import getDetails from '@salesforce/apex/SurveyController.getDetails';

export default class SurveyComponent extends LightningElement {

    surveyWrapper;
    errorMessage;
    questions = [];

    @wire(getDetails) 
    wiredSurvey({data, error}) {
        if(data) {
            this.surveyWrapper = data;
            this.questions = data.questions;
            console.log('responseType1: ' + this.questions[0].responseType);
            console.log('responseType2: ' + this.questions[1].responseType);   
            console.log('name1: ' + this.questions[0].name);
            console.log('name2: ' + this.questions[1].name);                                                           
        } else if(error) {
            this.errorMessage = error.body.message;
            console.log('error: ' + this.errorMessage)
        }
    };

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