public with sharing class KnockoutStageController {

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>>  getKnockoutMatchesByStage(Id knockoutStageId) {
        List<Match__c> matches = [
            SELECT Id, Match_Time__c, Knockout_Stage__r.Name, Knockout_Stage__c, 
                   Home_Team__r.Name, Away_Team__r.Name, Goals_Home_Team__c, Goals_Away_Team__c, 
                   Penalties__c
            FROM Match__c
            WHERE Knockout_Stage__c = :knockoutStageId
            ORDER BY Knockout_Stage__r.Name, Match_Time__c
        ];

        Map<String, List<Map<String, Object>>> groupedMatches = new Map<String, List<Map<String, Object>>>();
        List<Map<String, Object>> matchesByKnockout = new List<Map<String, Object>>();
        
       // String roundName = matches[0].Knockout_Stage__r.Name;
        for (Match__c match : matches) {
            Map<String, Object> matchData = new Map<String, Object>();
            matchData.put('matchId', match.Id);
            matchData.put('matchTime', match.Match_Time__c);
            matchData.put('teamAName', match.Home_Team__r.Name);
            matchData.put('teamBName', match.Away_Team__r.Name);
            matchData.put('teamAScore', match.Goals_Home_Team__c);
            matchData.put('teamBScore', match.Goals_Away_Team__c);
            matchData.put('penalty', match.Penalties__c != null ? match.Penalties__c : '');

            
            String roundName = match.Knockout_Stage__r.Name;
            if (!groupedMatches.containsKey(roundName)) {
                groupedMatches.put(roundName, new List<Map<String, Object>>());
            }
            groupedMatches.get(roundName).add(matchData);
        }


        List<Map<String, Object>> rounds = new List<Map<String, Object>>();
        for (String roundn : groupedMatches.keySet()) {
            Map<String, Object> round = new Map<String, Object>();
            round.put('roundName', roundn);
            round.put('matches', groupedMatches.get(roundn));
            rounds.add(round);
        }

        return rounds;
        
    }
}

