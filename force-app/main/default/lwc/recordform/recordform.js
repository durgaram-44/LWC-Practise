import { LightningElement } from 'lwc';

//import ACCOUNT_ID from '@salesforce/account/Id';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import ACCOUNT_TYPE from '@salesforce/schema/Account.Type';
import ACCOUNT_OWNER from '@salesforce/schema/Account.OwnerId';

export default class Recordform extends LightningElement {
    selectedFields = [ACCOUNT_NAME, ACCOUNT_TYPE, ACCOUNT_OWNER];
}