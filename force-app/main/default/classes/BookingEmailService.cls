public with sharing class BookingEmailService {

    @future
    public static void sendBookingConfirmationEmail(Set<Id> bookingIds) {

        if (bookingIds == null || bookingIds.isEmpty()) {
            return;
        }

        List<Booking__c> bookings = [
            SELECT Id,
                   Name,
                   Passenger__r.Name,
                   Passenger__r.Email,
                   Flight__r.Name,
                   Booking_Date__c,
                   Booking_Status__c,
                   Total_Amount__c
            FROM Booking__c
            WHERE Id IN :bookingIds
        ];

        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();

        for (Booking__c booking : bookings) {

            if (booking.Passenger__r == null ||
                String.isBlank(booking.Passenger__r.Email)) {
                continue;
            }

            Messaging.SingleEmailMessage mail =
                new Messaging.SingleEmailMessage();

            mail.setToAddresses(
                new String[] {
                    booking.Passenger__r.Email
                }
            );

            mail.setSubject(
                'SkyBook Pro - Booking Confirmed'
            );

            mail.setPlainTextBody(

                'Dear ' + booking.Passenger__r.Name +

                '\n\nYour booking has been confirmed successfully.' +

                '\n\nBooking ID : ' + booking.Name +

                '\nFlight : ' + booking.Flight__r.Name +

                '\nBooking Date : ' + booking.Booking_Date__c +

                '\nStatus : ' + booking.Booking_Status__c +

                '\nAmount : ₹' + booking.Total_Amount__c +

                '\n\nThank you for choosing SkyBook Pro.'

            );

            emails.add(mail);
        }

        if (!Test.isRunningTest() && !emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }

    @future
    public static void sendCancellationEmail(Set<Id> bookingIds) {

        if (bookingIds == null || bookingIds.isEmpty()) {
            return;
        }

        List<Booking__c> bookings = [
            SELECT Id,
                   Name,
                   Passenger__r.Name,
                   Passenger__r.Email,
                   Flight__r.Name
            FROM Booking__c
            WHERE Id IN :bookingIds
        ];

        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();

        for (Booking__c booking : bookings) {

            if (booking.Passenger__r == null ||
                String.isBlank(booking.Passenger__r.Email)) {
                continue;
            }

            Messaging.SingleEmailMessage mail =
                new Messaging.SingleEmailMessage();

            mail.setToAddresses(
                new String[] {
                    booking.Passenger__r.Email
                }
            );

            mail.setSubject(
                'SkyBook Pro - Booking Cancelled'
            );

            mail.setPlainTextBody(

                'Dear ' + booking.Passenger__r.Name +

                '\n\nYour booking has been cancelled.' +

                '\n\nBooking ID : ' + booking.Name +

                '\nFlight : ' + booking.Flight__r.Name +

                '\n\nIf applicable, your refund will be processed shortly.' +

                '\n\nThank you for choosing SkyBook Pro.'

            );

            emails.add(mail);
        }

        if (!Test.isRunningTest() && !emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}