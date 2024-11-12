trigger CreateNextRoundMatch on Match__c (after insert, after update) {
        KnockoutRuleService.applyKnockoutStageRules(Trigger.new)
}
