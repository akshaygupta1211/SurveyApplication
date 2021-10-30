import { LightningElement, wire } from 'lwc';
import submitResponses from '@salesforce/apex/SurveyController.submitResponses';
import getDetails from '@salesforce/apex/SurveyController.getDetails';

export default class SurveyComponent extends LightningElement {

    surveyWrapper;
    errorMessage;
    questions = [];
    responseWrapper = [];
    selectedValue;
    showSurvey = true;
    showError = false;
    showSuccess = false;
    successMessage = 'Your responses have been submitted.'
    noOfResponses = this.responseWrapper.length;

    @wire(getDetails) 
    wiredSurvey({data, error}) {
        if(data) {
            this.surveyWrapper = data;
            this.questions = data.questions;                                                
        } else if(error) {
            if(error.body.message == 'List index out of bounds: 0') {
                this.errorMessage = 'Currently no survey is assigned to you.';
            } else {
                this.errorMessage = error.body.message;
            }
            this.showSurvey = false;
            this.showError = true;
        }
    };

    handleSelection(event) {
        var answer = {
            response : event.detail.response,
            questionId : event.detail.questionId,
            surveyId : this.surveyWrapper.surveyId
        }
        if(this.noOfResponses > 0) {
            for(let i = 0; i < noOfResponses; i++) {
                if(this.responseWrapper[i].questionId == answer.questionId && this.responseWrapper[i].response != answer.response) {
                    this.responseWrapper[i].response = answer.response;
                } else if(this.responseWrapper[i].questionId != answer.questionId && this.responseWrapper[i].response != answer.response) {
                    this.responseWrapper.push(answer);
                } 
            }
        } else {
            this.responseWrapper.push(answer);
        }
    }

    handleSave(event) {
        submitResponses({responseWrapper : JSON.stringify(this.responseWrapper)})
        .then(() => {        
            this.showSurvey = false;
            this.showSuccess = true;
        })
        .catch(error => {
            this.showError = true;
            this.errorMessage = error.body.message;
        });
    }

    handleReset(event) {
        window.location.reload();
    }    

}