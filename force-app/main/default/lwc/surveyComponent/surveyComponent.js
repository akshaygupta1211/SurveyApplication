import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import submitResponses from '@salesforce/apex/SurveyController.submitResponses';
import getDetails from '@salesforce/apex/SurveyController.getDetails';

export default class SurveyComponent extends LightningElement {

    surveyWrapper;
    errorMessage;
    questions = [];
    responseWrapper = [];
    noOfResponses = this.responseWrapper.length;

    @wire(getDetails) 
    wiredSurvey({data, error}) {
        if(data) {
            this.surveyWrapper = data;
            this.questions = data.questions;                                                         
        } else if(error) {
            this.errorMessage = error.body.message;
        }
    };

    handleSelection(event) {
        var answer = {
            response : event.detail.response,
            questionId : event.detail.questionId,
            surveyId : this.surveyWrapper.surveyId
        }
        console.log(answer);
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
        console.log(this.responseWrapper);
    }

    handleSave(event) {
        submitResponses({responseWrapper : JSON.stringify(this.responseWrapper)})
        .then(() => {
            this.showToast("Survey Record Inserted", "success", "dismissable");
        })
        .catch(error => {
            this.showToast(JSON.stringify(error.body.message), "error", "sticky");
        });
    }

    handleReset(event) {

    }    

    showToast(message, variant, mode) {
        const event = new ShowToastEvent({
            message : message,
            variant : variant,
            mode : mode
        });
        this.dispatchEvent(event);
    }

}