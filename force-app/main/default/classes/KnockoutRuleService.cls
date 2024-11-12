public class KnockoutRuleService {

    void applyRules(Match__c match){

        List<Match__c> newMatches = new List<Match__c>();

        // Iterate over the matches that were inserted/updated
        for (Match__c match : Trigger.new) {
    
            // Check if the match is completed (both teams and result are present)
            if (match.Status__c == 'Completed' && match.Knockout_Stage__c != null) {
    
                // Get the next stage based on the current knockout stage
                Knockout_Stage__c currentStage = [SELECT Id, Next_Stage__c, Tournament__c, Name, Next_Stage__r.Name
                                                    FROM Knockout_Stage__c 
                                                    WHERE Id = :match.Knockout_Stage__c 
                                                    LIMIT 1];
    
                List<Match__c> matches = [SELECT Id, winner__c FROM Match__c WHERE Knockout_Stage__c = :currentStage.Id];
    
    
                // Find the teams that won the match (based on the score or penalty)
                Id teamA = match.Home_Team__c;
                Id teamB = match.Away_Team__c;
                Id winner = match.Winner__c; // Assume that 'Winner__c' stores the winner team
    
                // If the current knockout stage has a "next stage", create the next round match
                if (currentStage.Next_Stage__c != null) {
                    for(Integer i = 0 ; i <matches.size(); i= i+2){
                        newMatches.add(new Match__c(
                            Location__c = 'TBD',
                            Round_Number__c = currentStage.Next_Stage__r.Name,
                            Knockout_Stage__c = currentStage.Next_Stage__c, // Set the next knockout stage
                            Home_Team__c = matches[i].winner__c, // The winner from the current match
                            Away_Team__c =  matches[i+1].winner__c, // The loser from the current match
                            Status__c = 'Scheduled', // Initially set to scheduled
                            Match_Time__c = System.now().addDays(7) // You can define a logic for match date
                        ));
                    }
                   
    
                }
            }
        }
    
        // Insert the new matches if any
        if (!newMatches.isEmpty()) {
            insert newMatches;
        }
    }
}