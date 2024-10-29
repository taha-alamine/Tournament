trigger CreateGroup on Match__c (before insert) {
    for (Match__c match : Trigger.new) {
        if (match.Group_Name__c == null) {
            // Generate a unique external ID
            String uniqueId = 'Group_' + String.valueOf(Math.random()).substring(2, 6);

            // Create a new Group record
            Group__c newGroup = new Group__c();
            newGroup.Name = 'New Group'; // Replace with appropriate name
            newGroup.External_ID__c = uniqueId;
            insert newGroup;

            // Assign the new Group to the Match record
            match.Group_Name__c = newGroup.Id;
        }
    }
}