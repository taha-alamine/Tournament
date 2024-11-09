trigger CreateTeamOnMatchInsert on Match__c (before insert) {
    for (Match__c match : Trigger.new) {
        if (match.Home_Team__c == null) {
            Team__c newTeam = new Team__c();
            newTeam.Name = match.Home_Team__c;
            insert newTeam;
            match.Home_Team__c = newTeam.Id;
        }
        if (match.Away_Team__c == null) {
            Team__c newTeam = new Team__c();
            newTeam.Name = match.Away_Team__c; 

            insert newTeam;
            match.Away_Team__c = newTeam.Id;
        }
    }
}