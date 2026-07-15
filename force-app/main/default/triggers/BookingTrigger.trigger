trigger BookingTrigger on Booking__c (
    before insert,
    before update,
    after insert,
    after update
) {

    if (Trigger.isBefore && Trigger.isInsert) {
        BookingTriggerHandler.beforeInsert(
            Trigger.new
        );
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        BookingTriggerHandler.beforeUpdate(
            Trigger.new,
            Trigger.oldMap
        );
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        BookingTriggerHandler.afterInsert(
            Trigger.new
        );
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        BookingTriggerHandler.afterUpdate(
            Trigger.new,
            Trigger.oldMap
        );
    }
}