import { LightningElement,track } from 'lwc';

export default class ParentLWC extends LightningElement {
    @track finalValue;

    callmethodparent(event){
        this.finalValue = event.detail;
    }
}