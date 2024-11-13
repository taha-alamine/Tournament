trigger CreateNextRoundMatch on Match__c (before insert, before update) {
    
    //Stop recursive trigger
    if(KnockoutLogic.run){
    
    
        List<Match__c> newMatches = new List<Match__c>();
    Integer advancingTeams = 0;

    for (Match__c match : Trigger.new) {

        if (match.Status__c == 'Completed' && match.Knockout_Stage__c != null) {

            Knockout_Stage__c currentStage = [SELECT Id, Next_Stage__c, Tournament__c, Name, Advancing_teams__c
                                                FROM Knockout_Stage__c 
                                                WHERE Id = :match.Knockout_Stage__c 
                                                LIMIT 1];

            List<Match__c> matches = [SELECT Id, winner__c,winner__r.Id,winner__r.Name, Away_Team__c, Home_Team__c FROM Match__c WHERE Knockout_Stage__c = :currentStage.Id];


            Id teamA = match.Home_Team__c;
            Id teamB = match.Away_Team__c;
            Id winner = match.Winner__c;

            advancingTeams = Integer.valueOf(currentStage.Advancing_teams__c);
            if (currentStage.Next_Stage__c != null) {
                integer c =0;
                for(Integer i = 0 ; i <matches.size(); i= i+2){
                    c++;
                    if(c>=Integer.valueOf(currentStage.Advancing_teams__c)){
                        break;
                    }
                    newMatches.add(new Match__c(
                        Home_Team__c = matches[i].winner__r.Id,
                        Location__c = 'TBD',
                        Round_Number__c = currentStage.Next_Stage__c,
                        Knockout_Stage__c = currentStage.Next_Stage__c, 
                        Away_Team__c =  matches[i+1].winner__r.Id, 
                        Status__c = 'Scheduled', 
                        Match_Time__c = System.now().addDays(7), 
                        Name= matches[i].winner__r.Name + ' vs ' + matches[i+1].winner__r.Name
                    ));
                }
               

            }
        }
    }
    insert newMatches;
    KnockoutLogic.run = false;
}
}