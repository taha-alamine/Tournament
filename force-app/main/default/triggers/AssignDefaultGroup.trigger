trigger AssignDefaultGroup on Match__c (before insert) {
    for (Match__c match : Trigger.new) {
        if (match.Group_Name__c == null) {
            // Replace 'DefaultGroupId' with the ID of your default Group
            match.Group_Name__c = 'DefaultGroupId';
        }
    }
}