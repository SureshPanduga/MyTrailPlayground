import { LightningElement,wire,track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub';

export default class Childdemo extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    @track textval;

    handlechange(event){
        fireEvent(this.pageRef,'passvalue',event.target.value);
    }
}