import { LightningElement } from 'lwc';

export default class GroupTable extends LightningElement {
    data = [
        { team: 'Netherlands', wins: 2, draws: 1, losses: 0, points: 5, goalsFor: 5, goalsAgainst: 1, goalDifference: 4 },
        // ... other teams
    ];

    columns = [
        { label: 'Team', fieldName: 'team', type: 'text' },
        { label: 'Wins', fieldName: 'wins', type: 'number' },
        // ... other columns
    ];
}