trigger OpportunityTrigger on Opportunity (after insert, after update) {
    String[] ignoredStages = new String[] { 'Closed Lost' };

    Set<Id> accountIds = new Set<Id>();

    for (Opportunity opp : Trigger.new) {
        if (!ignoredStages.contains(opp.StageName)) {
            accountIds.add(opp.AccountId);
        }
    }

    List<Account> accountsWithOpportunities = [
        SELECT
            Id, (SELECT Id, Amount FROM Opportunities WHERE StageName NOT IN :ignoredStages)
        FROM Account
        WHERE Id IN :accountIds
    ];

    List<Account> accountsToUpdate = new List<Account>();

    for (Account acc : accountsWithOpportunities) {
        Decimal sum = 0;
        for (Opportunity opp : acc.Opportunities) {
            sum += opp.Amount;
        }

        Account updatedAccount = new Account();
        updatedAccount.Id = acc.Id;
        updatedAccount.Sum_Of_Opportunities__c = sum;
        accountsToUpdate.add(updatedAccount);
    }

    update accountsToUpdate;
}
