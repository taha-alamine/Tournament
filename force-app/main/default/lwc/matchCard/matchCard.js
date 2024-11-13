import { LightningElement, api, wire } from 'lwc';
import getMatchData from '@salesforce/apex/MatchData.getMatchData';

export default class MatchCard extends LightningElement {
    @api recordId; 

    matchTime;
    location;
    homeTeamName;
    awayTeamName;
    homeTeamFlag;
    awayTeamFlag;
    matchResultHome;
    matchResultAway;

    @wire(getMatchData, { matchId: '$recordId' })
    wiredMatch({ error, data }) {
        if (data) {

            console.log("111111",JSON.stringify(data) )
            this.matchTime = new Date(data.matchTime).toLocaleString();
            this.location = data.location;
            this.homeTeamName = data.homeTeamName;
            this.awayTeamName = data.awayTeamName;
            this.homeTeamFlag = data.homeTeamFlag;
            this.awayTeamFlag = data.awayTeamFlag;
            this.matchResultHome = data.result ? data.result.split(' - ')[0] : "-";
            this.matchResultAway = data.result ? data.result.split(' - ')[1] : "-";
        } else if (error) {
            console.error('Error fetching match details: ', error);
        }
    }
}