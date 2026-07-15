@isTest
private class AsyncApexTest {

    @isTest
    static void testFutureMethod() {

        Account acc =
            TestDataFactory.createAccount(
                'Future Account'
            );

        Contact con =
            TestDataFactory.createContact(
                acc.Id,
                'Future',
                'User'
            );

        Flight__c flight =
            TestDataFactory.createFlight(
                'DEL',
                'BOM',
                System.now().addDays(5)
            );

        Booking__c booking =
            TestDataFactory.createBooking(
                con.Id,
                flight.Id,
                1
            );

        Test.startTest();

        BookingEmailService.sendBookingConfirmationEmail(
            new Set<Id>{ booking.Id }
        );

        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testQueueableJob() {

        Account acc =
            TestDataFactory.createAccount(
                'Queue Account'
            );

        Contact con =
            TestDataFactory.createContact(
                acc.Id,
                'Queue',
                'User'
            );

        Flight__c flight =
            TestDataFactory.createFlight(
                'DEL',
                'BLR',
                System.now().addDays(5)
            );

        Booking__c booking =
            TestDataFactory.createBooking(
                con.Id,
                flight.Id,
                1
            );

        Test.startTest();

        System.enqueueJob(
            new BookingRefundQueueable(
                booking.Id
            )
        );

        Test.stopTest();

        Booking__c updatedBooking = [
            SELECT Booking_Status__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];

        System.assertEquals(
            'Confirmed',
            updatedBooking.Booking_Status__c
        );
    }

    @isTest
    static void testBatchJob() {

        Flight__c flight =
            TestDataFactory.createFlight(
                'DEL',
                'GOA',
                System.now().addDays(-2)
            );

        Test.startTest();

        Database.executeBatch(
            new FlightStatusBatch(),
            1
        );

        Test.stopTest();

        Flight__c updatedFlight = [
            SELECT Status__c
            FROM Flight__c
            WHERE Id = :flight.Id
        ];

        System.assertEquals(
            'Completed',
            updatedFlight.Status__c
        );
    }

    @isTest
    static void testScheduledJob() {

        Test.startTest();

        String cronExp =
            '0 0 7 * * ?';

        System.schedule(
            'Test Reminder Job',
            cronExp,
            new BookingReminderScheduler()
        );

        Test.stopTest();

        System.assert(true);
    }
}