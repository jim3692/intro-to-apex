@IsTest
class CalculateSumOfOpportunitiesBatchTest {

    @TestSetup
    static void makeData() {
        Account testingInc = new Account();
        testingInc.Name = 'Testing Inc.';
        testingInc.Sum_Of_Opportunities__c = 0;
        insert testingInc;

        Opportunity codeCoverage = new Opportunity();
        codeCoverage.Name = 'Code Coverage';
        codeCoverage.CloseDate = Date.today().addDays(3);
        codeCoverage.StageName = 'Prospecting';
        codeCoverage.Amount = 50 * 1000;
        codeCoverage.AccountId = testingInc.Id;

        Opportunity mocha = new Opportunity();
        mocha.Name = 'Mocha';
        mocha.CloseDate = Date.today().addDays(3);
        mocha.StageName = 'Closed Won';
        mocha.Amount = 25 * 1000;
        mocha.AccountId = testingInc.Id;

        OpportunityTriggerHandler.skipCalculateSumOfOpportunities = true;
        insert new Opportunity[] { codeCoverage, mocha };
        OpportunityTriggerHandler.skipCalculateSumOfOpportunities = false;
    }

    @IsTest
    static void runTest() {
        Account testingInc = [SELECT Id, Sum_Of_Opportunities__c FROM Account];
        System.assertEquals(0, testingInc.Sum_Of_Opportunities__c, 'Trigger should have been skipped');

        Test.startTest();
        CalculateSumOfOpportunitiesBatch.run();
        Test.stopTest();

        testingInc = [SELECT Id, Sum_Of_Opportunities__c FROM Account];
        System.assertEquals(75 * 1000, testingInc.Sum_Of_Opportunities__c, 'Opportunities in Status "Closed Won" should be accounted');
    }

}
