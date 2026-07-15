// Not required in Apex, @AuraEnabled works directly

public with sharing class BookingService {

    public static void initializeBooking(
        List<Booking__c> bookings
    ) {

        for(Booking__c booking : bookings){

            if(booking.Booking_Date__c == null){
                booking.Booking_Date__c = Date.today();
            }

            if(booking.Agent__c == null){
                booking.Agent__c = UserInfo.getUserId();
            }

            if(String.isBlank(booking.Booking_Status__c)){
                booking.Booking_Status__c = 'Draft';
            }

            if(String.isBlank(booking.Seat_Class__c)){
                booking.Seat_Class__c = 'Economy';
            }

            if(booking.Number_of_Seats__c == null){
                booking.Number_of_Seats__c = 1;
            }

            if(booking.Base_Fare__c == null){
                booking.Base_Fare__c = 0;
            }

            if(booking.Taxes_Fees__c == null){
                booking.Taxes_Fees__c = booking.Base_Fare__c * 0.10;
            }
        }
    }

    public static void validateBookingUpdate(
        List<Booking__c> newBookings,
        Map<Id, Booking__c> oldMap
    ) {

        for(Booking__c booking : newBookings){

            Booking__c oldBooking =
                oldMap.get(booking.Id);

            if(
                oldBooking.Booking_Status__c == 'Cancelled' &&
                booking.Booking_Status__c == 'Confirmed'
            ){
                booking.Booking_Status__c.addError(
                    'Cancelled bookings cannot be changed back to Confirmed.'
                );
            }

            if(
                booking.Number_of_Seats__c != null &&
                booking.Total_Passengers__c != null &&
                booking.Number_of_Seats__c <
                booking.Total_Passengers__c
            ){
                booking.Number_of_Seats__c.addError(
                    'Seats cannot be less than total passengers.'
                );
            }
        }
    }

    public static void processRefundQueue(
        List<Booking__c> newBookings,
        Map<Id, Booking__c> oldMap
    ){

        for(Booking__c booking : newBookings){

            Booking__c oldBooking =
                oldMap.get(booking.Id);

            if(
                oldBooking.Booking_Status__c != 'Cancelled' &&
                booking.Booking_Status__c == 'Cancelled'
            ){

                System.enqueueJob(
                    new BookingRefundQueueable(
                        booking.Id
                    )
                );
            }
        }
    }

    public static Booking__c createBooking(
        Id accountId,
        Id passengerId,
        Id flightId,
        Decimal baseFare,
        String seatClass
    ) {

        Booking__c booking = new Booking__c();

        booking.Account__c = accountId;
        booking.Passenger__c = passengerId;
        booking.Flight__c = flightId;

        booking.Booking_Date__c = Date.today();
        booking.Booking_Status__c = 'Confirmed';

        booking.Seat_Class__c =
            String.isBlank(seatClass)
                ? 'Economy'
                : seatClass;

        booking.Number_of_Seats__c = 1;

        Decimal exchangeRate = 128.42;

        Decimal fareInINR =
            (
                (baseFare == null ? 0 : baseFare)
                * exchangeRate
            ).setScale(2);

        booking.Base_Fare__c = fareInINR;

        booking.Taxes_Fees__c =
            (fareInINR * 0.10)
            .setScale(2);

        insert booking;

        return booking;
    }

    @AuraEnabled(cacheable=true)
    public static List<Booking__c> getMyBookings() {

        return [
            SELECT Id,
                   Name,
                   Booking_Status__c,
                   Booking_Date__c,
                   Seat_Class__c,
                   Base_Fare__c,
                   Days_Until_Departure__c,
                   Flight__r.Name
            FROM Booking__c
            WHERE Agent__c = :UserInfo.getUserId()
            ORDER BY CreatedDate DESC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Booking__c getBookingDetails(
        Id bookingId
    ) {

        return [
            SELECT Id,
                   Name,
                   Booking_Status__c,
                   Booking_Date__c,
                   Seat_Class__c,
                   Number_of_Seats__c,
                   Base_Fare__c,
                   Taxes_Fees__c,
                   Flight__r.Name,
                   Passenger__r.Name
            FROM Booking__c
            WHERE Id = :bookingId
            LIMIT 1
        ];
    }

    @AuraEnabled
    public static void cancelBooking(
        Id bookingId
    ) {

        Booking__c booking = [
            SELECT Id,
                   Booking_Status__c
            FROM Booking__c
            WHERE Id = :bookingId
            LIMIT 1
        ];

        booking.Booking_Status__c = 'Cancelled';

        update booking;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getRefundStatus(
        Id bookingId
    ) {

        Booking__c booking = [
            SELECT Booking_Status__c
            FROM Booking__c
            WHERE Id = :bookingId
            LIMIT 1
        ];

        if (booking.Booking_Status__c == 'Refunded') {
            return 'Refunded';
        }

        if (booking.Booking_Status__c == 'Cancelled') {
            return 'Processing';
        }

        return 'Initiated';
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> searchPassengers(
        String searchTerm
    ) {

        return [
            SELECT Id,
                Name,
                Email,
                Phone
            FROM Contact
            WHERE Name LIKE :('%' + searchTerm + '%')
            LIMIT 10
        ];
    }
    @AuraEnabled
    public static Id createBookingFromLWC(

        String firstName,
        String lastName,
        String email,
        String phone,

        String airline,
        String flightNumber,
        String origin,
        String destination,

        Datetime departureTime,
        Datetime arrivalTime,

        Decimal price,

        String offerId,
        String seatClass

    ) {

        try {

            Contact passenger;

            List<Contact> contacts = [
                SELECT Id, AccountId
                FROM Contact
                WHERE Email = :email
                LIMIT 1
            ];

            if (contacts.isEmpty()) {

                Account acc = new Account(
                    Name = firstName + ' ' + lastName
                );
                insert acc;

                passenger = new Contact(
                    FirstName = firstName,
                    LastName = lastName,
                    Email = email,
                    Phone = phone,
                    AccountId = acc.Id
                );
                insert passenger;

            } else {

                passenger = contacts[0];

            }

            FlightOfferWrapper offer = new FlightOfferWrapper();

            offer.offerId = offerId;
            offer.airline = airline;
            offer.flightNumber = flightNumber;
            offer.origin = origin;
            offer.destination = destination;
            offer.departureTime = departureTime;
            offer.arrivalTime = arrivalTime;
            offer.price = price;
            offer.currencyCode = 'GBP';
            offer.seatClass = seatClass;

            Flight__c flight =
                FlightRecordService.createFlightRecord(offer);

            Booking__c booking =
                createBooking(
                    passenger.AccountId,
                    passenger.Id,
                    flight.Id,
                    price,
                    seatClass
                );

            return booking.Id;

        }
        catch (Exception e) {

            System.debug('BOOKING ERROR: ' + e.getMessage());
            System.debug(e.getStackTraceString());

            throw new AuraHandledException(
                e.getMessage()
            );

        }

    }
    
    @AuraEnabled(cacheable=true)
    public static Integer getTotalBookings() {

        return [
            SELECT COUNT()
            FROM Booking__c
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getTotalRevenue() {

        AggregateResult result = [
            SELECT SUM(Total_Amount__c) total
            FROM Booking__c
        ];

        Decimal revenue =
            (Decimal)result.get('total');

        return revenue == null ? 0 : revenue;
    }

    @AuraEnabled(cacheable=true)
    public static List<Booking__c> getRecentBookings() {

        return [
            SELECT Id,
                Name,
                Booking_Status__c
            FROM Booking__c
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }
}