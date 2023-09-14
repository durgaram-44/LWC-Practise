import { LightningElement, track} from 'lwc';

export default class Verticalalignment extends LightningElement {
@track currentContent = 'SalesforceAdminstration';
@track tutorialValue = false;    
@track integrationValue = false;
@track visualforceValue = false;
@track triggerValue = false;
@track AuraComponentsValue = false;
@track salesforceLwcValue = false;


changeHandleAction(event) {
    const selected = event.detail.name;        

    this.currentContent = selected;

    if (selected == 'SalesforceAdminstration'){
        this.tutorialValue = true;
    }else{
        this.tutorialValue = false;
    }

    if (selected == 'integration'){
        this.integrationValue = true;
    }else{
        this.integrationValue = false;
    }

    if (selected == 'visualforce'){
        this.visualforceValue = true;
    }else{
        this.visualforceValue = false;
    }

    if (selected == 'trigger'){
        this.triggerValue = true;
    }else{
        this.triggerValue = false;
    }

    if (selected == 'AuraComponents'){
        this.AuraComponentsValue = true;
    }else{
        this.AuraComponentsValue = false;
    }

    if (selected == 'salesforceLwc'){
        this.salesforceLwcValue = true;
    }else{
        this.salesforceLwcValue = false;
    }

}
}