trigger OpportunityTrigger on Opportunity (after insert, after update) {
    Set<Id> accountIds = new Set<Id>();

    for (Opportunity opp : Trigger.new) {
        if (!OpportunityTriggerHandler.IGNORED_STAGES.contains(opp.StageName)) {
            accountIds.add(opp.AccountId);
        }
    }

    OpportunityTriggerHandler.calculateSumOfOpportunities(accountIds);
}
