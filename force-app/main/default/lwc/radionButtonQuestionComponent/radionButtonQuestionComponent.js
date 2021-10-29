import { LightningElement, api } from 'lwc';

export default class RadionButtonQuestionComponent extends LightningElement {
    @api question;
    @api value;
    @api key;
    options = [];
    selectedOption;

    connectedCallback() {
        for(let i = 0; i < this.question.answers.length; i++) {
            let nameOriginal = JSON.stringify(this.question.answers[i].Name);
            let nameModified = nameOriginal.replaceAll('"', '');
            this.options.push( {label: nameModified, value: nameModified });
        }
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