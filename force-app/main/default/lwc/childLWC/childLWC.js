import { LightningElement } from 'lwc';

export default class ChildLWC extends LightningElement {

    handlechange(event){
        const valuex = event.target.value;
        this.dispatchEvent(new CustomEvent('passvalue',{
            detail : valuex
        }))
    }
}