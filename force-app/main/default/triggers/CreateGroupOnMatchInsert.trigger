trigger CreateGroupOnMatchInsert on Match__c (before insert) {
    for (Match__c match : Trigger.new) {
        Integer i = 0;
        if (match.Tournament_Group__c == null) {
            Tournament_Group__c newGroup = new Tournament_Group__c();
            newGroup.Group_Name__c = match.Tournament_Group__c; // Assuming a field for Group Name in CSV
            newGroup.External_ID__c = 'Group_' + match.Tournament_Group__c + '1'; // Generate a unique external ID
            insert newGroup;
            match.Tournament_Group__c = newGroup.Id;
        }
    }
}