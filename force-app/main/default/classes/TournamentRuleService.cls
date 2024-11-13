public with sharing class TournamentRuleService {
    
    public static void applyRules(List<Match__c> matches) {
        // Get the tournament IDs related to the matches
        Set<Id> tournamentIds = new Set<Id>();
        for (Match__c match : matches) {
            tournamentIds.add(match.Tournament__c);
        }
        
        // Retrieve tournament formats
        List<Tournament_Tournament_Format__c> formatAssignments = [
            SELECT Tournament__c, Tournament_Format__c, Tournament_Format__r.Name, Tournament_Format__r.Rules__c
            FROM Tournament_Tournament_Format__c
            WHERE Tournament__c IN :tournamentIds
        ];


        
        // Separate tournaments by format type for processing
        for (Tournament_Tournament_Format__c assignment : formatAssignments) {
            if (assignment.Tournament_Format__r.Name == 'Group Stage') {
                applyGroupStageRules(matches, assignment.Tournament__c);
            } else if (assignment.Tournament_Format__r.Name == 'Knockout Stage') {
                applyKnockoutStageRules(matches, assignment.Tournament__c);
            }
        }
    }

    // Group Stage Rule Logic
    private static void applyGroupStageRules(List<Match__c> matches, Id tournamentId) {
        
        Integer pointsForWin = 3;
        Integer pointsForDraw = 1;
        Integer pointsForLoss = 0;
        
        // Fetch relevant matches and teams
        List<Tournament_Group__c> tournamentGroups = [SELECT Id,isCompleted__c  FROM Tournament_Group__c WHERE Tournament__c = :tournamentId];
        boolean groupsStatus = tournamentGroups.stream().allMatch(g -> g.isCompleted__c == 'Yes');
        if(groupsStatus){

        Set<Id> groupIds = new Set<Id>();
        for(Tournament_Group__c groups : tournamentGroups){
            groupIds.add(groups.Id);
        }
        List<Team__c> teams = [SELECT Id, Points__c FROM Team__c WHERE Tournament_Group__c in :groupIds];
        Map<Id, Team__c> teamPointsMap = new Map<Id, Team__c>(teams);
        
        for (Match__c match : matches) {
            if (match.Tournament__c == tournamentId) {
                if (match.Goals_Home_Team__c > match.Goals_Away_Team__c) {
                    teamPointsMap.get(match.Home_Team__c).Points__c += pointsForWin;
                    teamPointsMap.get(match.Away_Team__c).Points__c += pointsForLoss;
                } else if (match.Goals_Home_Team__c < match.Goals_Away_Team__c) {
                    teamPointsMap.get(match.Away_Team__c).Points__c += pointsForWin;
                    teamPointsMap.get(match.Home_Team__c).Points__c += pointsForLoss;
                } else {
                    // Draw case
                    teamPointsMap.get(match.Home_Team__c).Points__c += pointsForDraw;
                    teamPointsMap.get(match.Away_Team__c).Points__c += pointsForDraw;
                }
            }
        }
        }
        
        update teamPointsMap.values();
    }

    // Knockout Stage Rule Logic
    private static void applyKnockoutStageRules(List<Match__c> matches, Id tournamentId) {
        List<Match__c> knockoutMatches = new List<Match__c>();
        
        for (Match__c match : matches) {
            if (match.Tournament__c == tournamentId && match.winner__c != null) {
                knockoutMatches.add(match);
            }
        }
        
        for (Match__c match : knockoutMatches) {
            NextRoundMatch__c nextMatch = new NextRoundMatch__c(
                Tournament__c = tournamentId,
                Team1__c = match.Winner__c
                // Set Team2__c based on other match winners when available
            );
            insert nextMatch;
        }
    }
}
