public with sharing class BookingTriggerHandler {

    public static void beforeInsert(
        List<Booking__c> newBookings
    ) {

        BookingService.initializeBooking(
            newBookings
        );

    }

    public static void beforeUpdate(
        List<Booking__c> newBookings,
        Map<Id, Booking__c> oldMap
    ) {

        BookingService.validateBookingUpdate(
            newBookings,
            oldMap
        );

    }

    public static void afterInsert(
        List<Booking__c> newBookings
    ) {

        Set<Id> bookingIds = new Set<Id>();

        for (Booking__c booking : newBookings) {

            bookingIds.add(booking.Id);

        }

        BookingEmailService.sendBookingConfirmationEmail(
            bookingIds
        );

    }

    public static void afterUpdate(
        List<Booking__c> newBookings,
        Map<Id, Booking__c> oldMap
    ) {

        BookingService.processRefundQueue(
            newBookings,
            oldMap
        );

        Set<Id> cancelledBookingIds = new Set<Id>();

        for (Booking__c booking : newBookings) {

            Booking__c oldBooking =
                oldMap.get(booking.Id);

            if (
                oldBooking.Booking_Status__c != 'Cancelled' &&
                booking.Booking_Status__c == 'Cancelled'
            ) {

                cancelledBookingIds.add(
                    booking.Id
                );

            }

        }

        if (!cancelledBookingIds.isEmpty()) {

            BookingEmailService.sendCancellationEmail(
                cancelledBookingIds
            );

        }

    }

}