public class KnockoutRuleService {

    public static void applyRules(Match__c match){

        List<Match__c> newMatches = new List<Match__c>();

        for (Match__c match : Trigger.new) {
    
            if (match.Status__c == 'Completed' && match.Knockout_Stage__c != null) {
    
              
                Knockout_Stage__c currentStage = [SELECT Id, Next_Stage__c, Tournament__c, Name, Next_Stage__r.Name
                                                    FROM Knockout_Stage__c 
                                                    WHERE Id = :match.Knockout_Stage__c 
                                                    LIMIT 1];
    
                List<Match__c> matches = [SELECT Id, winner__c FROM Match__c WHERE Knockout_Stage__c = :currentStage.Id];
    
                Id teamA = match.Home_Team__c;
                Id teamB = match.Away_Team__c;
                Id winner = match.Winner__c; 
    
                if (currentStage.Next_Stage__c != null) {
                    for(Integer i = 0 ; i <matches.size(); i= i+2){
                        if(currentStage.Next_Stage__c == 'Final'){
                            newMatches.add(new Match__c(
                            Location__c = 'TBD',
                            Round_Number__c = 'Third-place Final',
                            Knockout_Stage__c = currentStage.Next_Stage__c, 
                            Home_Team__c = matches[i].winner__c == matches[i].Home_Team__c ? matches[i].Away_Team__c : matches[i].Home_Team__c, 
                            Away_Team__c =  matches[i+1].winner__c, == matches[i+1].Home_Team__c ? matches[i+1].Away_Team__c : matches[i+1].Home_Team__c, 
                            Status__c = 'Scheduled',
                            Match_Time__c = System.now().addDays(6) 
                        ));
                        }
                        newMatches.add(new Match__c(
                            Location__c = 'TBD',
                            Round_Number__c = currentStage.Next_Stage__r.Name,
                            Knockout_Stage__c = currentStage.Next_Stage__c, 
                            Home_Team__c = matches[i].winner__c, 
                            Away_Team__c =  matches[i+1].winner__c, 
                            Status__c = 'Scheduled',
                            Match_Time__c = System.now().addDays(7) 
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