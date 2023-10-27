@IsTest
class LeadTriggerTest {

    @IsTest
    static void runPositiveTestAdmin() {
        Lead newLead = new Lead();
        newLead.FirstName = 'John';
        newLead.LastName = 'Williams';
        newLead.Company = 'Salesforce';
        newLead.Status = 'Working - Contacted';

        Test.startTest();
        insert newLead;
        Test.stopTest();

        List<Lead> leads = [SELECT Id FROM Lead];
        System.assertEquals(1, leads.size(), 'Admin should be able to insert Leads in any Status');
    }

    @IsTest
    static void runPositiveTestNonAdmin() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Solution Manager' AND IsActive = TRUE LIMIT 1];

        Lead newLead = new Lead();
        newLead.FirstName = 'John';
        newLead.LastName = 'Williams';
        newLead.Company = 'Salesforce';
        newLead.Status = 'Open - Not Contacted';

        Test.startTest();
        System.runAs(u) {
            insert newLead;
        }
        Test.stopTest();

        List<Lead> leads = [SELECT Id FROM Lead];
        System.assertEquals(1, leads.size(), 'Non-admin should be able to insert Leads in status "Open - Not Contacted"');
    }

    @IsTest
    static void runNegativeTest() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Solution Manager' AND IsActive = TRUE LIMIT 1];

        Lead newLead = new Lead();
        newLead.FirstName = 'John';
        newLead.LastName = 'Williams';
        newLead.Company = 'Salesforce';
        newLead.Status = 'Working - Contacted';

        Boolean hasError = false;

        Test.startTest();
        System.runAs(u) {
            try {
                insert newLead;
            } catch (DmlException ex) {
                hasError = true;
            }
        }
        Test.stopTest();

        System.assert(hasError, 'Non-admin should not be able to insert Leads in status other than "Open - Not Contacted"');

        List<Lead> leads = [SELECT Id FROM Lead];
        System.assertEquals(0, leads.size(), 'Expected 0 Leads to exist');
    }

}
