import { LightningElement } from 'lwc';

export default class Controls extends LightningElement {
    handleClearCard() {
        this.dispatchEvent(new CustomEvent('clearselectedcard'));
    }
}