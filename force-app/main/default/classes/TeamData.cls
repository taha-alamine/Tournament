public with sharing class TeamData {

    @AuraEnabled(cacheable=true)
    public static List<Team__c> getTeam(Id matchId) {
        List<Team__c> Team = new List<Team__c>();

        List<Match__c> matches = [SELECT Id, Home_Team__c, Away_Team__c, Goals_Home_Team__c, Goals_Away_Team__c FROM Match__c WHERE Id = :matchId];

       
        Map<Id, Team__c> TeamMap = new Map<Id, Team__c>();

        for (Match__c match : matches) {
            
            Team__c homeTeam = TeamMap.get(match.Home_Team__c);
            if (homeTeam == null) {
                homeTeam = new Team__c();
                homeTeam.Name = match.Home_Team__r.Name;
                TeamMap.put(match.Home_Team__c, homeTeam);
            }
            homeTeam.Goals_For__c += match.Goals_Home_Team__c;
            homeTeam.Goals_Against__c += match.Goals_Away_Team__c;
            homeTeam.Played__c += 1;
            homeTeam.Won__c += match.Goals_Home_Team__c > match.Goals_Away_Team__c ? 1 : 0;
            homeTeam.Lost__c += match.Goals_Home_Team__c < match.Goals_Away_Team__c ? 1 : 0;
            homeTeam.Drawn__c += match.Goals_Home_Team__c == match.Goals_Away_Team__c ? 1 : 0;
            homeTeam.Points__c += match.Goals_Home_Team__c > match.Goals_Away_Team__c ? 3 : (match.Goals_Home_Team__c == match.Goals_Away_Team__c ? 1 : 0);

            
            Team__c awayTeam = TeamMap.get(match.Away_Team__c);
            if (awayTeam == null) {
                awayTeam = new Team__c();
                awayTeam.Name = match.Away_Team__r.Name;
                TeamMap.put(match.Away_Team__c, awayTeam);
            }
            awayTeam.Goals_For__c += match.Goals_Away_Team__c;
            awayTeam.Goals_Against__c += match.Goals_Home_Team__c;
            awayTeam.Played__c += 1;
            awayTeam.Won__c += match.Goals_Away_Team__c > match.Goals_Home_Team__c ? 1 : 0;
            awayTeam.Lost__c += match.Goals_Away_Team__c < match.Goals_Home_Team__c ? 1 : 0;
            awayTeam.Drawn__c += match.Goals_Away_Team__c == match.Goals_Home_Team__c ? 1 : 0;
            awayTeam.Points__c += match.Goals_Away_Team__c > match.Goals_Home_Team__c ? 3 : (match.Goals_Away_Team__c == match.Goals_Home_Team__c ? 1 : 0);
        }

        return TeamMap.values();
    }
}