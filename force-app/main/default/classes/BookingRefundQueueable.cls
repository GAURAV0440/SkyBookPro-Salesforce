public class BookingRefundQueueable implements Queueable {

    private Id bookingId;

    public BookingRefundQueueable(Id bookingId) {
        this.bookingId = bookingId;
    }

    public void execute(QueueableContext qc) {

        System.debug(
            'Refund Queue Executed for Booking: ' +
            bookingId
        );

        // Booking remains Cancelled.
        // Refund record is already created by Flow.
        // Refund Status remains "Initiated".
        // Future payment gateway/API refund logic can be added here.

    }
}