import { LightningElement, track} from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import Type_FIELD from '@salesforce/schema/Account.Type';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import AnnualRevenue_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import Website_FIELD from '@salesforce/schema/Account.Website';
import Rating_FIELD from '@salesforce/schema/Account.Rating';
import createAccount from '@salesforce/apex/createAcc.createAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class tabsdisplay extends LightningElement {

    @track name = NAME_FIELD;
    @track type = Type_FIELD;
    @track phone = PHONE_FIELD;
    @track annualRevenue = AnnualRevenue_FIELD;
    @track website = Website_FIELD;
    @track rating = Rating_FIELD;
    rec = {
        Name : this.name, //Name  : name__c
        Type : this.type,
        Phone : this.phone,
        AnnualRevenue: this.annualRevenue,
        Website: this.website,
        Rating : this.rating
    }

    handleNameChange(event) {
        this.rec.Name = event.target.value;
        console.log("name1", this.rec.Name);
    }
    handletypChange(event) {
        this.rec.Type = event.target.value;
         console.log("Type", this.rec.Type);
    }
    handlephonChange(event) {
        this.rec.Phone = event.target.value;
         console.log("Phone", this.rec.Phone);
    }
    handlerevenueChange(event) {
        this.rec.AnnualRevenue = event.target.value;
        console.log("AnnualRevenue", this.rec.AnnualRevenue);
    }
    handlewebChange(event) {
        this.rec.Website = event.target.value;
        console.log("Website", this.rec.Website);
    }
    handlerateChange(event) {
        this.rec.Rating = event.target.value;
        console.log("Rating", this.rec.Rating);
    }

    handleClick() {
        createAccount({ acc : this.rec })
            .then(result => {
                this.message = result;
                this.error = undefined;
                if(this.message !== undefined) { 
                    this.rec.Name = '';
                    this.rec.Type = '';
                    this.rec.Phone = '';
                    this.rec.AnnualRevenue='';
                    this.rec.Website ='';
                    this.rec.Rating='';
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Account created',
                            variant: 'success',
                        }),
                    );
                }
                this.template.querySelectorAll('lightning-input[data-id="reset"]').forEach(result => {
                    result.value = null;
                  });
                console.log(JSON.stringify(result));
                console.log("result", this.message);
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.log("error", JSON.stringify(this.error));
            });
    }
    resetFormAction(event) {
        this.template.querySelectorAll('lightning-input[data-id="reset"]').forEach(element => {
            element.value = null;
          });
     }
}