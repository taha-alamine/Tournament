trigger ParseMatchResult on Match__c (before insert, before update) {
    for (Match__c match : Trigger.new) {
        if (String.isNotBlank(match.Result__c)) {
            List<String> scores = match.Result__c.split('-');
            
            if (scores.size() > 2) {
                match.Goals_Home_Team__c = Integer.valueOf(scores[0].trim());
                match.Goals_Away_Team__c = Integer.valueOf(scores[1].trim());
            }
        }
    }
}