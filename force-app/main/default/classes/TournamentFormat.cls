public with sharing class TournamentFormat {
   
        @AuraEnabled(cacheable=true)
        public static List<Tournament_Tournament_Format__c> getTournamentFormatsByTournamentId(Id tournamentId) {
            return [
                SELECT Id, Tournament__c, Tournament_Format__c, Tournament_Format__r.Name, Tournament_Format__r.Rules__c
                FROM Tournament_Tournament_Format__c
                WHERE Tournament__c = :tournamentId
            ];
        }

        @AuraEnabled(cacheable=true)
        public static List<Tournament_Tournament_Format__c> getTournamentFormats(Id tournamentId) {
            return [
                SELECT Id, Tournament_Format__c, Tournament_Format__r.Name
                FROM Tournament_Tournament_Format__c
                WHERE Tournament__c = :tournamentId
            ];
    }

}