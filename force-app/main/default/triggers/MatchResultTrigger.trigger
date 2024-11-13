trigger MatchResultTrigger on Match__c (after insert, after update) {
    Set<Id> tournamentIds = new Set<Id>();
    Set<Id> processedTournamentIds = new Set<Id>(); 
    Set<Id> processedMatchIds = new Set<Id>();

    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        List<Match__c> matches = [SELECT Id, Tournament_Format__c, Tournament_Group__r.Tournament__c, Tournament_Format__r.Name 
                                  FROM Match__c WHERE Id IN :Trigger.new];

        // Collect unique tournament IDs
        for (Match__c match : matches) {
            if (match.Tournament_Group__r != null && match.Tournament_Group__r.Tournament__c != null) {
                tournamentIds.add(match.Tournament_Group__r.Tournament__c);
            }
        }


        for (Id tournamentId : tournamentIds) {
            if (!processedTournamentIds.contains(tournamentId)) {
                processedTournamentIds.add(tournamentId); 



                for (Match__c match : matches) {
                    if (match.Tournament_Group__r != null && match.Tournament_Group__r.Tournament__c == tournamentId) {
                        if (!processedMatchIds.contains(match.Id)) {
                            processedMatchIds.add(match.Id);

                           
                            System.debug('Processing match: ' + match.Id);

                         
                            if (match.Tournament_Format__r.Name == 'Groups') {
                                QualificationLogic.handleGroupStageQualification(tournamentId);
                            } else if (match.Tournament_Format__c == 'Best Third Place') {
                                QualificationLogic.handleBestThirdPlaceQualification(tournamentId);
                            }
                        } else {
                            System.debug('Skipping already processed match: ' + match.Id);
                        }
                    }
                }
            }
        }
    }
}
