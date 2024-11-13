public with sharing class TournamentService {

    public static void checkAndStartKnockoutPhase(Id tournamentId) {
        List<Match__c> groupMatches = [SELECT Id, Status__c FROM Match__c WHERE Tournament__c = :tournamentId AND Tournament_Group__c != null];
        
        Boolean allGroupsCompleted = groupMatches.stream().allMatch(match -> match.Status__c == 'Completed');
        
        if (allGroupsCompleted) {
            startKnockoutPhase(tournamentId);
        }
    }

    private static void startKnockoutPhase(Id tournamentId, Integer qualifyingTeams) {

        Map<Id, List<Team__c>> standings = getQualifyingTeams(tournamentId, Integer qualifyingTeams);
        
        createKnockoutMatches(tournamentId, qualifyingTeamsByGroup);
    }
    
    private static Map<Id, List<Team__c>> getQualifyingTeams(Id tournamentId, Integer qualifyingTeams) {
        // Query standings and sort by points, goal difference, etc., to get top teams
        List<Tournament_Group__c> groupsByTournaments = [SELECT Id FROM Tournament_Group__c WHERE Tournament__c = :tournamentId];

        Map<Id, List<Team__c>> qualifiedTeamsByGroups = new Map<Id, List<Team__c>>();
            for(Tournament_Group__c grou : groupsByTournaments){
                qualifiedTeamsByGroups.put(grou.Id, [SELECT Id, Name, Tournament_Group__c, Points__c, Won__c FROM Team__c 
                                                     WHERE Tournament_Group__c = :grou.Id 
                                                     ORDER BY Points__c Desc
                                                     LIMIT :qualifyingTeams]);
                    } 
        return qualifiedTeamsByGroups;
    }

    private static void createKnockoutMatches(Id tournamentId, Map<Id, List<Team__c>> qualifyingTeamsByGroup) {
        List<Match__c> knockoutMatches = new List<Match__c>();
        Integer round = 3; 
    
        
        List<Team__c> teamList = new List<Team__c>();
    
        // Flatten and order qualifying teams by groups in a list
        for (List<Team__c> groupTeams : qualifyingTeamsByGroup.values()) {
            teamList.addAll(groupTeams);
        }
    
        for (Integer i = 0; i < teamList.size(); i += 2) {
            if (i + 1 < teamList.size()) {
                Match__c knockoutMatch = new Match__c();
                knockoutMatch.Tournament__c = tournamentId;
                knockoutMatch.Round__c = round;
                knockoutMatch.Home_Team__c = teamList[i].Id;
                knockoutMatch.Away_Team__c = teamList[i + 1].Id;
                knockoutMatch.IsKnockoutMatch__c = 'Yes';
                knockoutMatches.add(knockoutMatch);
            }
        }
    
        insert knockoutMatches;
    }
}
