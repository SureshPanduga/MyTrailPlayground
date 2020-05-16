import { LightningElement,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener,unregisterAllListeners } from 'c/pubsub';

export default class Parentdemo extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    @track valueinp;

    connectedCallback(){
        //subscribe to inputChangeEvent event
        registerListener('passvalue', this.callmethod,this);
    }

    disconnectedCallback(){
        //unsubscribe from inputChangeEvent event
        unregisterAllListeners(this);
    }

    callmethod(val){
        this.valueinp = val;
    }
}