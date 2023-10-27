@IsTest
class OpportunityTriggerHandlerTest {

    static final Decimal INITIAL_AMOUNT = 50 * 1000;

    @TestSetup
    static void makeData() {
        Account testingInc = new Account();
        testingInc.Name = 'Testing Inc.';
        insert testingInc;

        Opportunity codeCoverage = new Opportunity();
        codeCoverage.Name = 'Code Coverage';
        codeCoverage.CloseDate = Date.today().addDays(3);
        codeCoverage.StageName = 'Prospecting';
        codeCoverage.Amount = INITIAL_AMOUNT;
        codeCoverage.AccountId = testingInc.Id;
        insert codeCoverage;
    }

    @IsTest
    static void runClosedWonTest() {
        Account testingInc = [SELECT Id, Sum_Of_Opportunities__c FROM Account];
        Decimal additionalAmount = 25 * 1000;

        Opportunity mocha = new Opportunity();
        mocha.Name = 'Mocha';
        mocha.CloseDate = Date.today().addDays(3);
        mocha.StageName = 'Closed Won';
        mocha.Amount = additionalAmount;
        mocha.AccountId = testingInc.Id;

        Test.startTest();
        insert mocha;
        Test.stopTest();

        Decimal totalExpectedAmount = INITIAL_AMOUNT + additionalAmount;
        testingInc = [SELECT Id, Sum_Of_Opportunities__c FROM Account];
        System.assertEquals(totalExpectedAmount, testingInc.Sum_Of_Opportunities__c, 'Opportunities in Status "Closed Won" should be accounted');
    }

    @IsTest
    static void runClosedLostTest() {
        Account testingInc = [SELECT Id, Sum_Of_Opportunities__c FROM Account];

        Opportunity jest = new Opportunity();
        jest.Name = 'Jest';
        jest.CloseDate = Date.today().addDays(3);
        jest.StageName = 'Closed Lost';
        jest.Amount = 15 * 1000;
        jest.AccountId = testingInc.Id;

        Test.startTest();
        insert jest;
        Test.stopTest();

        testingInc = [SELECT Id, Sum_Of_Opportunities__c FROM Account];
        System.assertEquals(INITIAL_AMOUNT, testingInc.Sum_Of_Opportunities__c, 'Opportunities in Status "Closed Lost" should not be accounted');
    }

}
