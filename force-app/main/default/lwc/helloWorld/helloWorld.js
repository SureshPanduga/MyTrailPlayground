import { LightningElement,track,api } from 'lwc';

export default class HelloWorld extends LightningElement {
    
    @track name='Suresh';
    @track gender;
    @api recordId;

    connectedCallback(){
        console.log('---HEY WHATS UP---');
        this.name='Panduga';
    }

    handlename(event){
        if(event.target.value){
            this.name=event.target.value;
        }
        else{
            this.name='MY CHANGED NAME';
        }
        console.log('---name---', this.name);
    }
}