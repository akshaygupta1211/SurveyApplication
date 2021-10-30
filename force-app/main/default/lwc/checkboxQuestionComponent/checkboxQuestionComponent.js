import { LightningElement, api } from 'lwc';

export default class CheckboxQuestionComponent extends LightningElement {
    @api question;
    @api value;
    @api key;
    selectedOption;

    connectedCallback() {

    }
    
    handleChange(event) {     
        this.selectedOption = event.detail.value;
        const selectedEvent = new CustomEvent('selected', 
        { 
            detail : {
                response: this.selectedOption, 
                questionId : this.question.questionId
            } 
        });

        this.dispatchEvent(selectedEvent);        
    }

}