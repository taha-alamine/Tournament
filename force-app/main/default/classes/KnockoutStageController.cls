public with sharing class KnockoutStageController {

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getKnockoutStagesWithMatches(Id tournamentId) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();

        
        List<Knockout_Stage__c> knockoutStages = [SELECT Id, Name FROM Knockout_Stage__c WHERE tournament__c =: tournamentId];

        
        for (Knockout_Stage__c stage : knockoutStages) {
            Map<String, Object> stageData = new Map<String, Object>();
            stageData.put('stageName', stage.Name);

            
            List<Match__c> matches = [SELECT Id, Home_Team__r.Name, Away_Team__r.Name, Result__c, Match_Time__c 
                                      FROM Match__c 
                                      WHERE Knockout_Stage__c = :stage.Id];

            List<Map<String, String>> matchDetails = new List<Map<String, String>>();

            
            for (Match__c match : matches) {
                Map<String, String> matchData = new Map<String, String>();
                matchData.put('matchId', match.Id);
                matchData.put('homeTeam', match.Home_Team__r.Name);
                matchData.put('awayTeam', match.Away_Team__r.Name);
                matchData.put('result', match.Result__c);
                matchData.put('matchTime', String.valueOf(match.Match_Time__c));
                matchDetails.add(matchData);
            }

            stageData.put('matches', matchDetails);
            result.add(stageData);
        }

        return result;
    }
}

