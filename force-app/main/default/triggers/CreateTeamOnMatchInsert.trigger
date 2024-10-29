trigger CreateTeamOnMatchInsert on Match__c (before insert) {
    for (Match__c match : Trigger.new) {
        if (match.Home_Team__c == null) {
            Team__c newTeam = new Team__c();
            newTeam.Name = match.Home_Team__c; // Assuming a field for Team Name in CSV
          //  newTeam.External_ID__c = 'Team_' + match.Home_Team__c; // Generate a unique external ID
            insert newTeam;
            match.Home_Team__c = newTeam.Id;
        }
        if (match.Away_Team__c == null) {
            Team__c newTeam = new Team__c();
            newTeam.Name = match.Away_Team__c; // Assuming a field for Team Name in CSV
          //  newTeam.External_ID__c = 'Team_' + match.Home_Team__c; // Generate a unique external ID
            insert newTeam;
            match.Away_Team__c = newTeam.Id;
        }
        // Similar logic for Away Team
    }
}