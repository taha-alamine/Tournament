import { LightningElement, track, wire, api} from 'lwc';
import getKnockoutStagesWithMatches from '@salesforce/apex/KnockoutStageController.getKnockoutStagesWithMatches';
import { NavigationMixin } from 'lightning/navigation';

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

    navigateToKnockoutRecord(event) {
        const knockoutId = event.currentTarget.dataset.knockoutId;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: knockoutId,
                actionName: 'view'
            }
        });
    }
    handleRowAction(event) {
        event.stopPropagation();
        const actionName = event.detail.action.name;
        const row = event.detail.matches;
        if (actionName === 'navigateToMatch') {
            this.navigateToMatchRecord(row.id);
        }
    }

    navigateToMatchRecord(matchId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: matchId,
                actionName: 'view'
            }
        });
    }

}
