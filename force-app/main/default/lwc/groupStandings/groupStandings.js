import { LightningElement, api, wire } from 'lwc';
import getAllGroups from '@salesforce/apex/TournamentGroups.getAllGroups';

export default class GroupStandings extends LightningElement {
    @api recordId;

    @wire(getAllGroups, { tournamentId: '$recordId' })
    teamsDetailsHandler(value){
        const {data, error}  = value;
        if(data){
            console.log("LJAAAADIIIIIIDDDD ##############", data);
            return data;
        }
    }

}