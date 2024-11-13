public with sharing class MatchData {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getMatchData(Id matchId) {
        Match__c match = [SELECT Id, Name, Result__c, Match_Time__c, Location__c,
            Home_Team__r.Name, Away_Team__r.Name
            FROM Match__c 
            WHERE Id = :matchId LIMIT 1];

        Map<String, Object> matchData = new Map<String, Object>();
        matchData.put('matchId', match.Id);
        matchData.put('result', match.Result__c);
        matchData.put('matchTime', match.Match_Time__c);
        matchData.put('location', match.Location__c);
        matchData.put('homeTeamName', match.Home_Team__r.Name);
        matchData.put('awayTeamName', match.Away_Team__r.Name);

        return matchData;
    }
}