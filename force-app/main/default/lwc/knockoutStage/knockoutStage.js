import { LightningElement, track, wire, api} from 'lwc';
import getKnockoutStagesWithMatches from '@salesforce/apex/KnockoutStageController.getKnockoutStagesWithMatches';

export default class KnockoutStage extends LightningElement {
    @api recordId;
    @track knockoutStages = [];
    error;

    
    @wire(getKnockoutStagesWithMatches, {tournamentId : '$recordId'})
    wiredMatches({ error, data }) {
        if (data) {
            console.log('Knockout Stages Data:', data);
            this.knockoutStages = data; 
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.knockoutStages = [];
        }
    }
}
