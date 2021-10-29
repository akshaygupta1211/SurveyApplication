import { LightningElement, api } from 'lwc';

export default class RadionButtonQuestionComponent extends LightningElement {
    @api question;
    value;
    key;
}