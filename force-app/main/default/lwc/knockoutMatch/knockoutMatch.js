import { LightningElement, api, wire } from 'lwc';
import getKnockoutMatchesByStage from '@salesforce/apex/KnockoutStageController.getKnockoutMatchesByStage';

export default class KnockoutStageResults extends LightningElement {
    @api knockoutStageId;
    knockoutMatches = [];

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
