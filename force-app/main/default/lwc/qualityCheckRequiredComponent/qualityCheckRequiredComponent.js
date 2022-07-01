import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import setDataQualityCheckRequired from '@salesforce/apex/CustomContactController.setDataQualityCheckRequired';

export default class QualityCheckRequiredComponent extends LightningElement {
    @api recordId;
    @api invoke() {
        setDataQualityCheckRequired({recordId: this.recordId})
        .then(() => {
            this.showToast("Success!", "Record updated & message posted successfully", "success", "dismissable");
        })
        .catch(error => {
            this.showToast("Error!", error.body.message, "error", "sticky");
        });
    }
    showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }    
}