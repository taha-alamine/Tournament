public with sharing class TeamMatchController {
    @AuraEnabled(cacheable=true)
    public static List<Match__c> getMatchesByTeam(Id teamId) {
        List<Match__c> homeMatches =  [
            SELECT Id, Match_Time__c, Result__c
            , Home_Team__r.Name
            , Away_Team__r.Name
            , Goals_Home_Team__c, Goals_Away_Team__c 
            FROM Match__c 
            WHERE Home_Team__c = :teamId
            ORDER BY Match_Time__c DESC
        ];

        List<Match__c> awayMatches =  [
            SELECT Id, Match_Time__c, Result__c
            , Home_Team__r.Name
            , Away_Team__r.Name
            , Goals_Home_Team__c, Goals_Away_Team__c 
            FROM Match__c 
            WHERE Away_Team__c = :teamId
            ORDER BY Match_Time__c DESC
        ];
        awayMatches.addAll(homeMatches);
        return awayMatches;
    }
}