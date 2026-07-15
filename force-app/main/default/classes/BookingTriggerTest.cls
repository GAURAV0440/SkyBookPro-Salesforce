@isTest
private class BookingTriggerTest {

    @isTest
    static void testBeforeInsertTrigger() {

        Account acc =
            TestDataFactory.createAccount(
                'Trigger Account'
            );

        Contact con =
            TestDataFactory.createContact(
                acc.Id,
                'John',
                'Doe'
            );

        Flight__c flight =
            TestDataFactory.createFlight(
                'DEL',
                'BOM',
                System.now().addDays(5)
            );

        Booking__c booking = new Booking__c(
            Account__c = acc.Id,
            Passenger__c = con.Id,
            Flight__c = flight.Id
        );

        insert booking;

        Booking__c result = [
            SELECT Booking_Date__c,
                   Booking_Status__c,
                   Seat_Class__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];

        System.assertEquals(
            Date.today(),
            result.Booking_Date__c
        );

        System.assertEquals(
            'Draft',
            result.Booking_Status__c
        );

        System.assertEquals(
            'Economy',
            result.Seat_Class__c
        );
    }

    @isTest
    static void testBeforeUpdateValidation() {

        Account acc =
            TestDataFactory.createAccount(
                'Validation Account'
            );

        Contact con =
            TestDataFactory.createContact(
                acc.Id,
                'Jane',
                'Smith'
            );

        Flight__c flight =
            TestDataFactory.createFlight(
                'DEL',
                'BLR',
                System.now().addDays(3)
            );

        Booking__c booking =
            TestDataFactory.createBooking(
                con.Id,
                flight.Id,
                2
            );

        booking.Booking_Status__c =
            'Cancelled';

        booking.Cancellation_Reason__c =
            'Customer Request';

        update booking;

        booking.Booking_Status__c =
            'Confirmed';

        Test.startTest();

        try {

            update booking;

            System.assert(
                false,
                'Should have thrown validation error'
            );

        } catch(Exception e) {

            System.assert(
                e.getMessage().contains(
                    'Cancelled bookings cannot be changed back to Confirmed'
                )
            );
        }

        Test.stopTest();
    }
}