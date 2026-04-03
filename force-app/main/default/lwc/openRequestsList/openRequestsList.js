import { LightningElement, wire } from 'lwc';
import getOpenRequests from '@salesforce/apex/OpenRequestsController.getOpenRequests';

export default class OpenRequestsList extends LightningElement {
    requests;
    error;

    @wire(getOpenRequests, { limitSize: 20 })
    wiredRequests({ error, data }) {
        if (data) {
            this.requests = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.requests = undefined;
        }
    }
}