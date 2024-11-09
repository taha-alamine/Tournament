trigger UpdateTeamStats on Match__c (after insert, after update) {
        Set<Id> teamIdsToUpdate = new Set<Id>();
        for (Match__c match : Trigger.new) {
            teamIdsToUpdate.add(match.Home_Team__c);
            teamIdsToUpdate.add(match.Away_Team__c);
        }
    
        List<Team__c> teamsToUpdate = [SELECT Id, Goals_For__c, Goals_Against__c, Points__c, Won__c, Lost__c, Drawn__c, Played__c FROM Team__c WHERE Id IN :teamIdsToUpdate];
    
        for (Match__c match : Trigger.new) {
            for (Team__c team : teamsToUpdate) {
                //team.Drawn__c += Integer.valueOf(match.Result__c.split('-')[0].trim()) == Integer.valueOf(match.Result__c.split('-')[1].trim()) ? 1 : 0;
                
                // Add Knockout logic

                team.Played__c += 1;
                if (team.Id == match.Home_Team__c) {
                    if(match.Round_Number__c < 4)
                    team.Goals_For__c += Integer.valueOf(match.Result__c.split('-')[0].trim());
                    team.Goals_Against__c += Integer.valueOf(match.Result__c.split('-')[1].trim());
                    team.Points__c += Integer.valueOf(match.Result__c.split('-')[0].trim()) > Integer.valueOf(match.Result__c.split('-')[1].trim()) ? 3 : (Integer.valueOf(match.Result__c.split('-')[1].trim()) == Integer.valueOf(match.Result__c.split('-')[0].trim()) ? 1 : 0);
                    team.Won__c += Integer.valueOf(match.Result__c.split('-')[0].trim()) < Integer.valueOf(match.Result__c.split('-')[1].trim()) ? 0 : 1;
                    team.Lost__c += Integer.valueOf(match.Result__c.split('-')[0].trim()) > Integer.valueOf(match.Result__c.split('-')[1].trim()) ? 0 : 1;
                    team.Drawn__c += Integer.valueOf(match.Result__c.split('-')[0].trim()) == Integer.valueOf(match.Result__c.split('-')[1].trim()) ? 1 : 0; 
                } else if (team.Id == match.Away_Team__c && match) {
                    team.Goals_For__c += Integer.valueOf(match.Result__c.split('-')[1].trim());
                    team.Goals_Against__c += Integer.valueOf(match.Result__c.split('-')[0].trim());
                    team.Points__c += Integer.valueOf(match.Result__c.split('-')[1].trim()) > Integer.valueOf(match.Result__c.split('-')[0].trim()) ? 3 : (Integer.valueOf(match.Result__c.split('-')[0].trim()) == Integer.valueOf(match.Result__c.split('-')[1].trim()) ? 1 : 0);
                    team.Won__c += Integer.valueOf(match.Result__c.split('-')[0].trim()) > Integer.valueOf(match.Result__c.split('-')[1].trim()) ? 0 : 1;
                    team.Lost__c += Integer.valueOf(match.Result__c.split('-')[0].trim()) > Integer.valueOf(match.Result__c.split('-')[1].trim()) ? 1 : 0;
                    team.Drawn__c += Integer.valueOf(match.Result__c.split('-')[0].trim()) == Integer.valueOf(match.Result__c.split('-')[1].trim()) ? 1 : 0;
                }
            }
        }
    
        update teamsToUpdate;
    }
