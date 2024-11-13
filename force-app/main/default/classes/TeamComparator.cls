public class TeamComparator implements Comparator<Team__c> {
    public Integer compare(Team__c o1, Team__c o2) {
        Integer returnValue = 0;
        
        if(o1 == null && o2 == null) {
            returnValue = 0;
        } else if(o1 == null) {
            returnValue = -1; 
        } else if(o2 == null) {
            returnValue = 1;
        } else if (o1.Points__c == o2.Points__c) {
            if(o1.Goals_For__c > o2.Goals_For__c){
                returnValue = -1;
            }
            else if(o1.Goals_For__c < o2.Goals_For__c){
                returnValue = 1;
            }
            else {
                if(o1.Won__c > o2.Won__c){
                    returnValue = -1;
                }
                else if(o1.Won__c < o2.Won__c){
                    returnValue = 1;
                }
            }
        } else if (o1.Points__c == null){
            returnValue = -1;
        } else if (o2.Points__c == null){
            returnValue = 1;
        } else if (o1.Points__c > o2.Points__c) {
            returnValue = -1;
        } else if (o1.Points__c < o2.Points__c) {
            returnValue = 1;
        }
        return returnValue;
    }
}