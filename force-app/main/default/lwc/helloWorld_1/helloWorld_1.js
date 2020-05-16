import { LightningElement } from 'lwc';

export default class HelloWorld_1 extends LightningElement {
    firstName = 'Suresh';
    changeHandler(event) {
        this.firstName = event.target.value;
    }
}