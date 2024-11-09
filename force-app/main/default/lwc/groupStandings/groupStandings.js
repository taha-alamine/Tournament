import { LightningElement, api, wire, track } from 'lwc';
import getAllGroups from '@salesforce/apex/TournamentGroups.getAllGroups';
//import getGroupName from '@salesforce/apex/TournamentGroups.getGroupName';
import { NavigationMixin } from 'lightning/navigation';

const columns = [
    {
        label: 'Team',
        fieldName: 'teams',
        type: 'button',
        typeAttributes: {
            label: { fieldName: 'teams' },
            name: 'navigateToTeam',
            variant: 'base'
        }
    },
    { label: 'P', fieldName: 'played', type: 'number' },
    { label: 'W', fieldName: 'wins', type: 'number' },
    { label: 'D', fieldName: 'draws', type: 'number' },
    { label: 'L', fieldName: 'losses', type: 'number' },
    { label: 'GF', fieldName: 'goalsFor', type: 'number' },
    { label: 'GA', fieldName: 'goalsAgainst', type: 'number' },
    { label: 'GD', fieldName: 'goalDifference', type: 'number' },
    { label: 'PTS', fieldName: 'points', type: 'number' },
];

export default class GroupStandings extends NavigationMixin(LightningElement) {

    columns = columns;
    @api recordId;
    @track groups;
    @track groupName;
    @track currentTournament;
    @track groupStanding;
    error;

    navigateToGroupRecord(event) {
        const groupId = event.currentTarget.dataset.groupId;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: groupId,
                actionName: 'view'
            }
        });
    }

    // fetchRecordName(recordId){
    //     getRecordNameById({ recordId })
    //         .then(name => {
    //             this.groupNames.push(name); // Assign the name to a variable
    //             console.log('Record Name:', this.recordName); // Optional: Log the name
    //         })
    //         .catch(error => {
    //             console.error('Error fetching record name:', error);
    //         });
    // };

    @wire(getAllGroups, { tournamentId: '$recordId' })
    groupsStandingHandler(value){
        const {data, error}  = value;
        if(data){
            let standind = [];
            let groupNames = [];
            for (let element in data) {
                let groupStandings = {};
                let groupData = []
                data[element].forEach(e => {
                    let tableRow = {};
                   // tableRow.group = element;
                    tableRow.id = e.Id;
                    tableRow.teams = e.Name;
                    tableRow.wins = e.Won__c;
                    tableRow.losses = e.Lost__c;
                    tableRow.played =  e.Played__c;
                    tableRow.drawn =  e.Drawn__c;
                    tableRow.goalsFor =  e.Goals_For__c;
                    tableRow.goalsAgainst =  e.Goals_Against__c;
                    tableRow.points = e.Point__c;
                    groupData.push(tableRow);
                })
                groupStandings.Id = data[element][0].Tournament_Group__c;
                groupStandings.group= element;
                groupStandings.teams = groupData;
                standind.push(groupStandings);
                console.log("groupStandinfdkjsdbf", JSON.stringify(groupStandings));
            }

            this.groups = groupNames;
            this.groupStanding = standind;
            
            return data;
        }
    }



    handleRowAction(event) {
        event.stopPropagation();
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'navigateToTeam') {
            this.navigateToTeamRecord(row.id);
        }
    }

    navigateToTeamRecord(teamId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: teamId,
                actionName: 'view'
            }
        });
    }
}