import { LightningElement, api, wire } from 'lwc';
import LightningFormattedRichText from 'lightning/formattedRichText';
import getTournamentFormatsByTournamentId from '@salesforce/apex/TournamentFormat.getTournamentFormatsByTournamentId';

export default class TournamentFormat extends LightningElement {
    
    
    @api recordId;
    tournamentFormats = [];
    error;

    @wire(getTournamentFormatsByTournamentId, { tournamentId: '$recordId' })
    wiredFormats({ error, data }) {
        if (data) {
            console.log(JSON.stringify(data))
            this.tournamentFormats = data.map(formatAssignment => ({
                id: formatAssignment.Id,
                name: formatAssignment.Tournament_Format__r.Name,
                rule: formatAssignment.Tournament_Format__r.Rules__c
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.tournamentFormats = [];
        }
    }


}