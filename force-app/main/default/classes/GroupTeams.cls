public with sharing class GroupTeams {

    @AuraEnabled(cacheable=true)
    public static  List<Team__c> getTeamsByGroup(Id groupId) {
        List<Team__c> teams = [SELECT Name FROM Team__c WHERE Tournament_Group__c = :groupId];
        return teams;
    }

    @AuraEnabled(cacheable=true)
    public static  List<Team__c> getTeams() {
        List<Team__c> teams = [SELECT Name, Tournament_Group__c FROM Team__c];
        return teams;
    }

    @AuraEnabled(cacheable=true)
    public static  List<Team__c> getTeamsPoints() {
        List<Team__c> teams = [SELECT Name FROM Team__c WHERE Tournament_Group__c = :groupId];
        return teams;
    }
}