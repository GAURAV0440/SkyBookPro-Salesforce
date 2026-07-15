global class BookingReminderScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        System.debug('Booking Reminder Scheduler Executed');

        Database.executeBatch(
            new FlightStatusBatch(),
            200
        );
    }
}