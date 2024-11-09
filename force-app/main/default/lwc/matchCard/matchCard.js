import { LightningElement, api, wire } from 'lwc';
import getMatchData from '@salesforce/apex/MatchData.getMatchData';
import MATCH_NAME_FIELD from '@salesforce/schema/Match__c.Name'

    columns = [
        {label: "", fieldName: ""},
        {label: "", fieldName: ""},
        {label: "", fieldName: ""},
    ];

export default class MatchCard extends LightningElement {



    @api recordId;

    

    @api matchData = {
        matchDate: '',
        score: '',
        homeTeamName: '',
        awayTeamName: '',
        matchLocation: ''
    };
    
    @wire(getMatchData, { matchId: '$recordId' })
    teamsDetailsHandler(value){
        const {data, error}  = value;
        if(data){
            console.log("###############", data.Result__c);
            return data;
        }
    }

    // get homeTeamFlagUrl() {
    //     return `/resource/${this.matchData.homeTeamFlag}`;
    // }

    // get awayTeamFlagUrl() {
    //     return `/resource/${this.matchData.awayTeamFlag}`;
    // }
}