import { LightningElement, api, wire, track } from 'lwc';
import getMatchesByTeam from '@salesforce/apex/TeamMatchController.getMatchesByTeam';

export default class TeamMatches extends LightningElement {

    @api recordId;
    @track matches = [];

    @wire(getMatchesByTeam, { teamId: '$recordId' })
    wiredMatches({ data, error }) {
        if (data) {

        console.log("##########",data);
            this.matches = data;

        } else if (error) {
            console.error('Error retrieving matches:', error);
        }
    }

}