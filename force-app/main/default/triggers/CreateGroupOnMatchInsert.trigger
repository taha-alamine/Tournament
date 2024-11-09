trigger CreateGroupOnMatchInsert on Match__c (before update) {
    for (Match__c match : Trigger.new) {
        Integer i = 0;
        if (match.Tournament_Group__c == null) {
            Tournament_Group__c newGroup = new Tournament_Group__c();
            newGroup.Group_Name__c = match.Tournament_Group__c; 
            newGroup.External_ID__c = 'Group_' + match.Tournament_Group__c + '1'; 
            insert newGroup;
            match.Tournament_Group__c = newGroup.Id;
        }
    }
}