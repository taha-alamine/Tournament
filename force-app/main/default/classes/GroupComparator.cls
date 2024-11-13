public class GroupComparator implements Comparator<Tournament_Group__c> {
    public Integer compare(Tournament_Group__c o1, Tournament_Group__c o2) {
        Integer returnValue = 0;
        
        if(o1 == null && o2 == null) {
            returnValue = 0;
        } else if(o1 == null) {
            returnValue = -1; 
        } else if(o2 == null) {
            returnValue = 1;
        }  else if (o1.Name == null){
            returnValue = -1;
        } else if (o2.Name == null){
            returnValue = 1;
        } else if (o1.Name > o2.Name) {
            returnValue = -1;
        } else if (o1.Name < o2.Name) {
            returnValue = 1;
        }
        return returnValue;
    }
}