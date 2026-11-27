trigger OpportunityTrigger on Opportunity (before insert, before update) {
    OpportunityTriggerHandler.handleTrigger(Trigger.new, Trigger.oldMap, Trigger.isBefore, Trigger.isInsert);
}
