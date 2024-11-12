import { LightningElement, api, wire } from 'lwc';
import getKnockoutMatchesByStage from '@salesforce/apex/KnockoutStageController.getKnockoutMatchesByStage';

export default class KnockoutStageResults extends LightningElement {
    @api knockoutStageId; // This will be passed to the LWC as a parameter
    knockoutMatches = [];

    // Wire method to fetch matches based on knockout stage ID
    @wire(getKnockoutMatchesByStage, { knockoutStageId: '$knockoutStageId' })
    wiredMatches({ error, data }) {
        if (data) {
            console.log("####", JSON.stringify(data))
            this.knockoutMatches = data;
        } else if (error) {
            console.error('Error fetching knockout matches:', error);
        }
    }
}
