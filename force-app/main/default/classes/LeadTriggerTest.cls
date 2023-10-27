@IsTest
class LeadTriggerTest {

    @IsTest
    static void runPositiveTest() {
        Lead newLead = new Lead();
        newLead.FirstName = 'John';
        newLead.LastName = 'Williams';
        newLead.Company = 'Salesforce';
        newLead.Status = 'Open - Not Contacted';

        Test.startTest();
        insert newLead;
        Test.stopTest();

        List<Lead> leads = [SELECT Id FROM Lead];
        System.assertEquals(1, leads.size(), 'Expected 1 Lead to exist');
    }

    @IsTest
    static void runNegativeTest() {
        Lead newLead = new Lead();
        newLead.FirstName = 'John';
        newLead.LastName = 'Williams';
        newLead.Company = 'Salesforce';
        newLead.Status = 'Working - Contacted';

        Boolean hasError = false;

        Test.startTest();
        try {
            insert newLead;
        } catch (DmlException ex) {
            hasError = true;
        }
        Test.stopTest();

        System.assert(hasError, 'Expected error to be thrown');

        List<Lead> leads = [SELECT Id FROM Lead];
        System.assertEquals(0, leads.size(), 'Expected 0 Leads to exist');
    }

}
