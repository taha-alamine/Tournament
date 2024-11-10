trigger UpdateTeamStats on Match__c (after insert, after update) {
    Set<Id> teamIdsToUpdate = new Set<Id>();
    
    // Collect Team IDs from Match records
    for (Match__c match : Trigger.new) {
        teamIdsToUpdate.add(match.Home_Team__c);
        teamIdsToUpdate.add(match.Away_Team__c);
    }

    // Retrieve current Team records
    Map<Id, Team__c> teamsToUpdateMap = new Map<Id, Team__c>(
        [SELECT Id, Goals_For__c, Goals_Against__c, Points__c, Won__c, Lost__c, Drawn__c, Played__c 
         FROM Team__c WHERE Id IN :teamIdsToUpdate]
    );

    // Process Matches
    for (Match__c match : Trigger.new) {
        if (String.isNotBlank(match.Result__c) && match.Result__c.contains('-')) {
            Integer homeScore = Integer.valueOf(match.Result__c.split('-')[0].trim());
            Integer awayScore = Integer.valueOf(match.Result__c.split('-')[1].trim());
            
            // Handle update case by subtracting old values if this is an update
            if (Trigger.isUpdate && Trigger.oldMap.containsKey(match.Id)) {
                Match__c oldMatch = Trigger.oldMap.get(match.Id);
                Integer oldHomeScore = Integer.valueOf(oldMatch.Result__c.split('-')[0].trim());
                Integer oldAwayScore = Integer.valueOf(oldMatch.Result__c.split('-')[1].trim());

                if (teamsToUpdateMap.containsKey(match.Home_Team__c)) {
                    Team__c homeTeam = teamsToUpdateMap.get(match.Home_Team__c);
                    homeTeam.Goals_For__c -= oldHomeScore;
                    homeTeam.Goals_Against__c -= oldAwayScore;
                    homeTeam.Points__c -= (oldHomeScore > oldAwayScore ? 3 : (oldHomeScore == oldAwayScore ? 1 : 0));
                    homeTeam.Won__c -= (oldHomeScore > oldAwayScore ? 1 : 0);
                    homeTeam.Lost__c -= (oldHomeScore < oldAwayScore ? 1 : 0);
                    homeTeam.Drawn__c -= (oldHomeScore == oldAwayScore ? 1 : 0);
                    homeTeam.Played__c -= 1;
                }

                if (teamsToUpdateMap.containsKey(match.Away_Team__c)) {
                    Team__c awayTeam = teamsToUpdateMap.get(match.Away_Team__c);
                    awayTeam.Goals_For__c -= oldAwayScore;
                    awayTeam.Goals_Against__c -= oldHomeScore;
                    awayTeam.Points__c -= (oldAwayScore > oldHomeScore ? 3 : (oldAwayScore == oldHomeScore ? 1 : 0));
                    awayTeam.Won__c -= (oldAwayScore > oldHomeScore ? 1 : 0);
                    awayTeam.Lost__c -= (oldAwayScore < oldHomeScore ? 1 : 0);
                    awayTeam.Drawn__c -= (oldAwayScore == oldHomeScore ? 1 : 0);
                    awayTeam.Played__c -= 1;
                }
            }

            // Update current match results for home team
            if (teamsToUpdateMap.containsKey(match.Home_Team__c)) {
                Team__c homeTeam = teamsToUpdateMap.get(match.Home_Team__c);
                homeTeam.Goals_For__c += homeScore;
                homeTeam.Goals_Against__c += awayScore;
                homeTeam.Points__c += homeScore > awayScore ? 3 : (homeScore == awayScore ? 1 : 0);
                homeTeam.Won__c += homeScore > awayScore ? 1 : 0;
                homeTeam.Lost__c += homeScore < awayScore ? 1 : 0;
                homeTeam.Drawn__c += homeScore == awayScore ? 1 : 0;
                homeTeam.Played__c += 1;
            }

            // Update current match results for away team
            if (teamsToUpdateMap.containsKey(match.Away_Team__c)) {
                Team__c awayTeam = teamsToUpdateMap.get(match.Away_Team__c);
                awayTeam.Goals_For__c += awayScore;
                awayTeam.Goals_Against__c += homeScore;
                awayTeam.Points__c += awayScore > homeScore ? 3 : (awayScore == homeScore ? 1 : 0);
                awayTeam.Won__c += awayScore > homeScore ? 1 : 0;
                awayTeam.Lost__c += awayScore < homeScore ? 1 : 0;
                awayTeam.Drawn__c += awayScore == homeScore ? 1 : 0;
                awayTeam.Played__c += 1;
            }
        }
    }

    // Update Team stats
    update teamsToUpdateMap.values();
}
