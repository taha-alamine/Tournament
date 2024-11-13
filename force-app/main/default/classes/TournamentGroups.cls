public with sharing class TournamentGroups {
    @AuraEnabled(cacheable=true)
    public static Map<String,  List<Team__c>> getAllGroups(Id tournamentId) {
        List<Tournament_Group__c> groups = [SELECT Id, Name FROM Tournament_Group__c WHERE tournament__c = :tournamentId];
        groups.sort(new GroupComparator());
        return getStandingGroups(tournamentId, groups);
    }


    private static String getGroupName(Id groupId) {
        return [SELECT name FROM Tournament_Group__c WHERE Id = :groupId LIMIT 1].Name;
    }

    public static Map<String,  List<Team__c>> getStandingGroups(Id tournamentId, List<Tournament_Group__c> groupIds){

        Map<String, List<Team__c>> teamsByGroups = new Map<String,  List<Team__c>>();

        try {

            for(Tournament_Group__c groupId : groupIds){
                teamsByGroups.put(getGroupName(groupId.Id), GroupTeams.getTeamsByGroup(groupId.Id));
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return teamsByGroups;
    }
}