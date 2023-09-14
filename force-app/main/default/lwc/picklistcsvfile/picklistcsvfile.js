import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import csvFileRead from '@salesforce/apex/PicklistCaseCsv.csvFileRead';

const columnsAccount = [
    { label: 'Category', fieldName: 'Category__c' }, 
    { label: 'Sub Category', fieldName: 'Sub_Category__c' }  
];

export default class Picklistcasecsv extends LightningElement {
    @api recordId;
    @track error;
    @track columnsAccount = columnsAccount;
    @track data;
    @api Category = 'Category__c';
    @api SubCategory = 'Sub_Category__c';


    // accepted parameters
    get acceptedCSVFormats() {
        return ['.csv'];
    }
    
    uploadFileHandler(event) {
        // Get the list of records from the uploaded files
        const uploadedFiles = event.detail.files;

        // calling apex class csvFileread method
        csvFileRead({contentDocumentId : uploadedFiles[0].documentId})
        .then(result => {
            window.console.log('result ===> '+result);
            this.data = result;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Accounts are created according to the CSV file upload!!!',
                    variant: 'Success',
                }),
            );
        })
        .catch(error => {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: JSON.stringify(error),
                    variant: 'error',
                }),
            );     
        })

    }
}