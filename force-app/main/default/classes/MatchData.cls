public with sharing class MatchData {

    @AuraEnabled(cacheable=true)
    public static Match__c getMatchData(Id matchId) {
        // Logic to fetch match data from database or API
        //Match__c matchData = new Match__c();

        Match__c match = [SELECT Id, Name, Result__c, Match_Time__c, Location__c, Home_Team__c, Away_Team__c FROM Match__c WHERE Id = :matchId];
        
        // ... populate matchData fields
        return match;
    }
}