import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import submitSurvey from '@salesforce/apex/SurveyController.submitSurvey';
import getDetails from '@salesforce/apex/SurveyController.getDetails';

export default class SurveyComponent extends LightningElement {

    surveyWrapper;
    errorMessage;
    questions = [];
    noOfQuestions = 0;

    @wire(getDetails) 
    wiredSurvey({data, error}) {
        if(data) {
            this.surveyWrapper = data;
            this.questions = data.questions;
            this.noOfQuestions = this.questions.length;                
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