import getTeamsByGroup from '@salesforce/apex/GroupTeams.getTeamsByGroup';
import getTeams from '@salesforce/apex/GroupTeams.getTeams';
import { LightningElement, wire, api} from 'lwc';

export default class TeamList extends LightningElement {

    teams = [];

    @api recordId;
    @wire(getTeamsByGroup, { groupId: '$recordId' })
    teamsDetailsHandler({data, error}){
        //console.log("###############", JSON.stringify(data));
        this.teams = data;
    }

    //@wire(getTeams)


    // connectedCallback() {
    //     this.getTeams();
    // }


    // async getTeams() {
    //     try {
    //         console.log("AAAAALLLL TEAMS", this.allTeams)
    //         console.log('#############', this.teams)
    //         const teams = await getTeamsByGroup('a06Qy0000094XkzIAE');
    //         this.teams = teams;
    //     } catch (error) {
    //         console.error(error);
    //     }
    // }

    get teamNames() {
        console.log("############# teamNames ::", this.teams)
        if (this.teams) {
            return this.teams.map(t=>t.Name);
        }
        return [];
    }

    get teamPoints() {
        console.log("############# teamNames ::", this.teams)
        if (this.teams) {
            return this.teams.map(t=>t.Points);
        }
        return [];
    }

    get columns() {
        return [
            { label: '#', fieldName: 'rank' },
            { label: 'Team', fieldName: 'teamName', type: 'text' },
            { label: 'P', fieldName: 'played', type: 'number' },
            { label: 'W', fieldName: 'won', type: 'number' },
            { label: 'D', fieldName: 'drawn', type: 'number' },
            { label: 'L', fieldName: 'lost', type: 'number' },
            { label: 'F', fieldName: 'goalsFor', type: 'number' },
            { label: 'A', fieldName: 'goalsAgainst', type: 'number' },
            { label: 'GD', fieldName: 'goalDifference', type: 'number' },
            { label: 'PTS', fieldName: 'points', type: 'number' }
        ];
    }
 }