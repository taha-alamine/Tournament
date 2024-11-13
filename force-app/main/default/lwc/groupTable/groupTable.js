import { LightningElement, api, track, wire } from 'lwc';
import getTeamsByGroup from '@salesforce/apex/GroupTeams.getTeamsByGroup'
import TOURNAMENT_GROUP_NAME_FIELD from '@salesforce/schema/Tournament_Group__c.Group_Name__c';
import { getRecord } from 'lightning/uiRecordApi';
//import

const columns = [
    { label: 'Teams', fieldName: 'teams', type: 'text' },
    { label: 'P', fieldName: 'played', type: 'number' },
    { label: 'W', fieldName: 'wins', type: 'number' },
    { label: 'D', fieldName: 'draws', type: 'number' },
    { label: 'L', fieldName: 'losses', type: 'number' },
    { label: 'GF', fieldName: 'goalsFor', type: 'number' },
    { label: 'GA', fieldName: 'goalsAgainst', type: 'number' },
    { label: 'GD', fieldName: 'goalDifference', type: 'number' },
    { label: 'PTS', fieldName: 'points', type: 'number' },
];


export default class GroupTable extends LightningElement {

    
    columns = columns;
    @api recordId;
    @track record;
    @track currentGroup;
    @track groupList;
    error;


    @wire(getTeamsByGroup, { groupId: '$recordId' })
    wiredGroups(value) {
        const { data, error } = value;
        if (data) {
            let groupData = [];
            console.log("WiredGroup", data);
            let topTeams = [data[0], data[1]];  // Top 2 teams
            data.forEach((element, index) => {
                let tableRow = {};
                tableRow.teams = element.Name;
                tableRow.wins = element.Won__c;
                tableRow.losses = element.Lost__c;
                tableRow.played = element.Played__c;
                tableRow.draws = element.Drawn__c;
                tableRow.goalsFor = element.Goals_For__c;
                tableRow.goalsAgainst = element.Goals_Against__c;
                tableRow.goalDifference = element.Goals_For__c - element.Goals_Against__c;
                tableRow.points = element.Points__c;

                // Add a green circle for the top 2 teams
                tableRow.top2 = (topTeams.includes(element)) ? '🏆' : ''; // Add green circle for the top two teams

                groupData.push(tableRow);
            });
            console.log("$Data", JSON.stringify(groupData));
            this.groupList = groupData;
        } else if (error) {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading teams',
                    message: error.message,
                    variant: 'error',
                }),
            );
        }
    }

    

}