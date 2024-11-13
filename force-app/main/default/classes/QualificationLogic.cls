public class QualificationLogic {
    public static void handleGroupStageQualification(Id tournamentId) {
        if(KnockoutLogic.qualificationLogicRun){

        
        Integer number_of_teams = 0;

        List<Tournament_Group__c> groupStandings = [SELECT Id, Name, isCompleted__c FROM Tournament_Group__c WHERE Tournament__c = :tournamentId];
        boolean groupsStatus = true;

        Map<String, List<Team__c>> groupMap = new Map<String, List<Team__c>>();

        for (Tournament_Group__c standing : groupStandings) {
            if(standing.isCompleted__c != 'Yes'){
                groupsStatus = false;
                break;
            }
            List<Team__c> teams_by_group = new List<Team__c>([SELECT Name, Points__c, Goals_For__c FROM Team__c WHERE Tournament_Group__c = :standing.Id]);
            number_of_teams += teams_by_group.size();
            teams_by_group.sort(new TeamComparator());
            groupMap.put(standing.Name, new List<Team__c>{teams_by_group[0], teams_by_group[1]});
        }
        if(groupsStatus = true){
            String round = '';
            if(number_of_teams == 32){
                round = 'Round of 16';
            }
            if(number_of_teams == 48){
                round = 'Round of 32';
            }
            if(number_of_teams == 16){
                round = 'Quarter Final';
            }
            if(number_of_teams == 8){
                round = 'Semi Final';
            }
            if(number_of_teams == 4){
                round = 'Final';
            }

            Knockout_Stage__c knockout = [SELECT Id FROM Knockout_Stage__c WHERE Name = :round LIMIT 1];
            List<Match__c> knockoutMatches = new List<Match__c>();
    
            List<String> groupNames = new List<String>(groupMap.keySet());
            groupNames.sort();
            List<Match__c> matchups = new List<Match__c>();
            
            for (Integer i = 0; i < groupNames.size(); i +=2) {
            
                String currentGroup = groupNames[i];
                String nextGroup= groupNames[i + 1]; 
    
                List<Team__c> currentGroupTeams = groupMap.get(currentGroup);
                List<Team__c> nextGroupTeams = groupMap.get(nextGroup);
            
                Match__c match1 = new Match__c(
                    Knockout_Stage__c= knockout.Id,
                    Home_Team__c= currentGroupTeams[0].Id,
                    Away_Team__c= nextGroupTeams[1].Id,
                   Round_Number__c= round, 
                    Location__c= 'TBD',
                    Name= currentGroupTeams[0].Name + ' vs ' + nextGroupTeams[1].Name
                );
                matchups.add(match1);

                Match__c match2 = new Match__c(
                    Knockout_Stage__c= knockout.Id,
                    Home_Team__c= currentGroupTeams[1].Id,
                    Away_Team__c= nextGroupTeams[0].Id,
                    Round_Number__c=round,
                    Location__c= 'TBD',  
                    Name= currentGroupTeams[1].Name + ' vs ' +nextGroupTeams[0].Name
                );
                matchups.add(match2);        
            }   
            insert matchups; 
            KnockoutLogic.qualificationLogicRun = false;
        }    
    }
    }

   
    public static void handleBestThirdPlaceQualification(Id tournamentId) {
        
        List<Tournament_Group__c> groupStandings = [SELECT Id, Name FROM Tournament_Group__c WHERE Tournament__c = :tournamentId];

        
        Map<String, List<Team__c>> groupMap = new Map<String, List<Team__c>>();

        for (Tournament_Group__c standing : groupStandings) {
                groupMap.put(standing.Name, new List<Team__c>([SELECT Name FROM Team__c WHERE Tournament_Group__c = :standing.Id]));
        }
       
        groupStandings.sort();

        // Select the best 4 third-placed teams
        List<Team__c> bestThirdPlaceTeams = new List<Team__c>();
        Integer count = 0;
        for (Tournament_Group__c standing : groupStandings) {
            //TODO
            bestThirdPlaceTeams.addAll([SELECT Id, Name FROM Team__c WHERE Tournament_Group__c = :standing.Id LIMIT 2]);
           
        }

    }   
}