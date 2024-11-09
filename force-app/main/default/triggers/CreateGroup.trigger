trigger CreateGroup on Match__c (before update) {
    for (Match__c match : Trigger.new) {
        if (match.Tournament_Group__c == null) {

            String uniqueId = 'Group_' + String.valueOf(Math.random()).substring(2, 6);


            Tournament_Group__c newGroup = new Tournament_Group__c();
            newGroup.Name = 'New Group'; 
            newGroup.External_ID__c = uniqueId;
            insert newGroup;

            match.Tournament_Group__c = newGroup.Id;
        }
    }
}