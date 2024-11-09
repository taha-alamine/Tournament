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
    // data = [
    //     { team: 'Netherlands', wins: 2, draws: 1, losses: 0, points: 5, goalsFor: 5, goalsAgainst: 1, goalDifference: 4 },
    //     // ... other teams
    // ];

    // @wire(getTeamsByGroup, { groupId: '$recordId' })
    // teamsDetailsHandler(value){
    //     const {data, error}  = value;
        
    //     if(data){
    //         this.record = data
    //         console.log("###############", data);
    //         return data;
    //     }
    // }

    @wire(getRecord, { recordId: '$recordId', fields: [TOURNAMENT_GROUP_NAME_FIELD] })
    store({ error, data }) {
        if (data) {
            console.log("Just Wired", data)
            this.record = data;
            this.error = undefined;
            this.currentGroup = this.name ;
        } else if (error) {
            this.error = error;
            this.record = undefined;
        }
    }

    get name() {
        return this.record.fields.Group_Name__c.value;
    }

    @wire(getTeamsByGroup, { groupId: '$recordId' })
    wiredGroups(value) {
        // Destructure the provisioned value 
        const { data, error } = value;
        if (data) {
            // Map the data in the datatable
            let groupData = [];
            console.log("WiredGroup", data);
            data.forEach(element => {
                let tableRow = {};
                tableRow.teams = element.Name;
                tableRow.wins = element.Won__c;
                tableRow.losses = element.Lost__c;
                tableRow.played =  element.Played__c;
                tableRow.drawn =  element.Drawn__c;
                tableRow.goalsFor =  element.Goals_For__c;
                tableRow.goalsAgainst =  element.Goals_Against__c;
                tableRow.points = element.Point__c;;
                groupData.push(tableRow);
            });
            console.log("$Data", data);
            this.groupList = groupData;
        } else if (error) {
            this.error = error;
        }
    }

    
    // get name(){
    //     console.log(this.record.fields);
    // }

}