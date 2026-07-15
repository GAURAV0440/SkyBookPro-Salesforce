@isTest
private class BookingServiceTest {

    @isTest
    static void testBookingProcess() {

        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;

        Contact con = new Contact(
            LastName = 'Test Passenger',
            Email = 'test@test.com',
            AccountId = acc.Id
        );
        insert con;

        Flight__c flight = new Flight__c(
            Name = 'AI-101',
            Flight_Number__c = 'AI101',
            Airline_Name__c = 'Air India',
            Origin_Airport__c = 'DEL',
            Destination_Airport__c = 'BOM',
            Departure_DateTime__c = System.now().addDays(5),
            Arrival_DateTime__c = System.now().addDays(5).addHours(2),
            Status__c = 'Active'
        );
        insert flight;

        Test.startTest();

        Booking__c booking =
            BookingService.createBooking(
                acc.Id,
                con.Id,
                flight.Id,
                5000,
                'Economy'
            );

        Test.stopTest();

        System.assertNotEquals(
            null,
            booking.Id
        );

        Booking__c createdBooking = [
            SELECT Id,
                   Booking_Status__c,
                   Taxes_Fees__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];

        Decimal expectedTax =
            ((5000 * 128.42) * 0.10).setScale(2);

        System.assertEquals(
            'Confirmed',
            createdBooking.Booking_Status__c
        );

        System.assertEquals(
            expectedTax,
            createdBooking.Taxes_Fees__c
        );
    }

    @isTest
    static void testRefundQueue() {

        Account acc = new Account(
            Name = 'Refund Account'
        );
        insert acc;

        Contact con = new Contact(
            LastName = 'Refund Passenger',
            Email = 'refund@test.com',
            AccountId = acc.Id
        );
        insert con;

        Flight__c flight = new Flight__c(
            Name = 'AI-102',
            Flight_Number__c = 'AI102',
            Airline_Name__c = 'Air India',
            Origin_Airport__c = 'DEL',
            Destination_Airport__c = 'BLR',
            Departure_DateTime__c = System.now().addDays(3),
            Arrival_DateTime__c = System.now().addDays(3).addHours(2),
            Status__c = 'Active'
        );
        insert flight;

        Decimal exchangeRate = 128.42;

        Decimal fareInINR =
            (5000 * exchangeRate).setScale(2);

        Booking__c booking = new Booking__c(
            Account__c = acc.Id,
            Passenger__c = con.Id,
            Flight__c = flight.Id,
            Booking_Status__c = 'Confirmed',
            Seat_Class__c = 'Economy',
            Number_of_Seats__c = 1,
            Base_Fare__c = fareInINR,
            Taxes_Fees__c = (fareInINR * 0.10).setScale(2)
        );
        insert booking;

        booking.Booking_Status__c = 'Cancelled';
		booking.Cancellation_Reason__c = 'Customer Request';

        Test.startTest();

        update booking;

        Test.stopTest();

        Booking__c updatedBooking = [
            SELECT Booking_Status__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];

        System.assertEquals(
            'Cancelled',
            updatedBooking.Booking_Status__c
        );
    }

    @isTest
    static void testFlightStatusBatch() {

        Flight__c flight = new Flight__c(
            Name = 'AI-103',
            Flight_Number__c = 'AI103',
            Airline_Name__c = 'Air India',
            Origin_Airport__c = 'DEL',
            Destination_Airport__c = 'GOA',
            Departure_DateTime__c = System.now().addDays(-1),
            Arrival_DateTime__c = System.now(),
            Status__c = 'Active'
        );
        insert flight;

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
    static void testCleanupJob() {

        Account acc = new Account(
            Name = 'Cleanup Account'
        );
        insert acc;

        Contact con = new Contact(
            LastName = 'Cleanup Passenger',
            Email = 'cleanup@test.com',
            AccountId = acc.Id
        );
        insert con;

        Flight__c flight = new Flight__c(
            Name = 'AI-104',
            Flight_Number__c = 'AI104',
            Airline_Name__c = 'Air India',
            Origin_Airport__c = 'DEL',
            Destination_Airport__c = 'HYD',
            Departure_DateTime__c = System.now().addDays(2),
            Arrival_DateTime__c = System.now().addDays(2).addHours(2),
            Status__c = 'Active'
        );
        insert flight;

        Decimal exchangeRate = 128.42;

        Decimal fareInINR =
            (1000 * exchangeRate).setScale(2);

        Booking__c booking = new Booking__c(
            Account__c = acc.Id,
            Passenger__c = con.Id,
            Flight__c = flight.Id,
            Booking_Date__c = Date.today().addDays(-40),
            Booking_Status__c = 'Draft',
            Seat_Class__c = 'Economy',
            Number_of_Seats__c = 1,
            Base_Fare__c = fareInINR,
            Taxes_Fees__c = (fareInINR * 0.10).setScale(2)
        );
        insert booking;

        Test.startTest();

        System.enqueueJob(
            new BookingCleanupJob()
        );

        Test.stopTest();

        Booking__c updatedBooking = [
            SELECT Booking_Status__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];

        System.assertEquals(
            'Cancelled',
            updatedBooking.Booking_Status__c
        );
    }
   @isTest
    static void testGetMyBookings() {

        List<Booking__c> bookings =
            BookingService.getMyBookings();

        System.assertNotEquals(
            null,
            bookings
        );

    }

    @isTest
    static void testGetTotalBookings() {

        Integer total =
            BookingService.getTotalBookings();

        System.assert(
            total >= 0
        );

    }

    @isTest
    static void testGetTotalRevenue() {

        Decimal revenue =
            BookingService.getTotalRevenue();

        System.assertNotEquals(
            null,
            revenue
        );

    }

    @isTest
    static void testGetRecentBookings() {

        List<Booking__c> bookings =
            BookingService.getRecentBookings();

        System.assertNotEquals(
            null,
            bookings
        );

    }

    @isTest
    static void testSearchPassengers() {

        Account acc =
            new Account(
                Name='Search'
            );
        insert acc;

        Contact c =
            new Contact(

                FirstName='John',

                LastName='Doe',

                Email='john@test.com',

                AccountId=acc.Id

            );

        insert c;

        List<Contact> result =
            BookingService.searchPassengers(
                'John'
            );

        System.assert(
            result.size() > 0
        );

    }

}