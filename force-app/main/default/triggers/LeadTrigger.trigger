trigger LeadTrigger on Lead (before insert) {
    Id userProfileId = UserInfo.getProfileId();
    Profile userProfile = [SELECT Name FROM Profile WHERE Id = :userProfileId];

    String[] affectedProfiles = new String[] { 'Solution Manager' };
    String targetStatus = 'Open - Not Contacted';
    String message = String.format('New Leads should have Status: "{0}"', new String[] { targetStatus });

    for (Lead l : Trigger.new) {
        if (l.Status != targetStatus && affectedProfiles.contains(userProfile.Name)) {
        l.addError(message);
    }
    }
}
