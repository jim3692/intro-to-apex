public with sharing class OpportunityTriggerHandler {
    @TestVisible
    private static Boolean skipCalculateSumOfOpportunities = false;

    public static final String[] IGNORED_STAGES = new String[] { 'Closed Lost' };

    public static void calculateSumOfOpportunities(Set<Id> accountIds) {
        if (skipCalculateSumOfOpportunities) {
            return;
        }

        List<Account> accountsWithOpportunities = [
            SELECT
                Id, (SELECT Id, Amount FROM Opportunities WHERE StageName NOT IN :IGNORED_STAGES)
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
}
