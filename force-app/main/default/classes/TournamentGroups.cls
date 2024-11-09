public with sharing class TournamentGroups {
    @AuraEnabled(cacheable=true)
    public static Map<Tournament_Group__c,  List<Team__c>> getAllGroups(Id tournamentId) {
        List<Tournament_Group__c> groups = [SELECT Id FROM Tournament_Group__c WHERE tournament__c = :tournamentId];
        return getStandingGroups(tournamentId, groups);
    }


    private static List<Tournament_Group__c> getGroupName(Id groupId) {
        return [SELECT name FROM Tournament_Group__c WHERE Id = :groupId LIMIT 1];
    }

    public static Map<Tournament_Group__c,  List<Team__c>> getStandingGroups(Id tournamentId, List<Tournament_Group__c> groupIds){

        Map<Tournament_Group__c, List<Team__c>> teamsByGroups = new Map<Tournament_Group__c,  List<Team__c>>();

        try {

            for(Tournament_Group__c groupId : groupIds){
                teamsByGroups.put(getGroupName(groupId.Id)[0], GroupTeams.getTeamsByGroup(groupId.Id));
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return teamsByGroups;
    }
}