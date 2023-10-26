trigger LeadTrigger on Lead (before insert) {
    String targetStatus = 'Open - Not Contacted';
    String message = String.format('New Leads should have Status: "{0}"', new String[] { targetStatus });

    for (Lead l : Trigger.new) {
        if (l.Status != targetStatus) {
            l.addError(message);
        }
    }
}
