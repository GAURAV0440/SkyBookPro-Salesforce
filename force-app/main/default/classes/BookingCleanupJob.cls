public class BookingCleanupJob implements Queueable {

    public void execute(QueueableContext qc) {

        List<Booking__c> oldBookings = [
            SELECT Id, Booking_Status__c, Booking_Date__c
            FROM Booking__c
            WHERE Booking_Status__c = 'Draft'
            AND Booking_Date__c < :Date.today().addDays(-30)
        ];

        for(Booking__c booking : oldBookings){
            booking.Booking_Status__c = 'Cancelled';
            booking.Cancellation_Reason__c = 'Auto Cleanup';
        }

        if(!oldBookings.isEmpty()){
            update oldBookings;
        }

        System.debug(
            oldBookings.size() +
            ' old draft bookings cancelled.'
        );
    }
}