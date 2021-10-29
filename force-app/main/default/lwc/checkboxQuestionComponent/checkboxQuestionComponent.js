import { LightningElement, api } from 'lwc';

export default class CheckboxQuestionComponent extends LightningElement {
    @api question;
    value;
    @api key;    
}