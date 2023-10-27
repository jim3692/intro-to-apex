public class CalculateSumOfOpportunitiesBatch implements Database.Batchable<SObject>{
    private static final String ALL_ACCOUNTS_QUERY = 'SELECT Id FROM Account';

    private final String query;

    public static void run() {
        Database.executeBatch(new CalculateSumOfOpportunitiesBatch(ALL_ACCOUNTS_QUERY));
    }

    public CalculateSumOfOpportunitiesBatch(String query) {
        this.query = query;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.query);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        Set<Id> scopeIds = new Map<Id,Account>(scope).keySet();
        OpportunityTriggerHandler.calculateSumOfOpportunities(scopeIds);
    }

    public void finish(Database.BatchableContext bc) { }
}