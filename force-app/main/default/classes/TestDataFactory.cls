@isTest
public class TestDataFactory {

    public static Account createAccount(String name) {

        Account acc = new Account(
            Name = name
        );

        insert acc;

        return acc;
    }

    public static Contact createContact(
        Id accountId,
        String firstName,
        String lastName
    ) {

        Contact con = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = 'test@test.com',
            AccountId = accountId
        );

        insert con;

        return con;
    }

    public static Flight__c createFlight(
        String origin,
        String destination,
        Datetime departureTime
    ) {

        Flight__c flight = new Flight__c(
            Name = 'AI-101',
            Flight_Number__c = 'AI101',
            Airline_Name__c = 'Air India',
            Origin_Airport__c = origin,
            Destination_Airport__c = destination,
            Departure_DateTime__c = departureTime,
            Arrival_DateTime__c = departureTime.addHours(2),
            Status__c = 'Active'
        );

        insert flight;

        return flight;
    }

    public static Booking__c createBooking(
        Id contactId,
        Id flightId,
        Integer seats
    ) {

        Contact con = [
            SELECT AccountId
            FROM Contact
            WHERE Id = :contactId
        ];

        Booking__c booking = new Booking__c(
            Account__c = con.AccountId,
            Passenger__c = contactId,
            Flight__c = flightId,
            Booking_Status__c = 'Confirmed',
            Seat_Class__c = 'Economy',
            Number_of_Seats__c = seats,
            Base_Fare__c = 5000,
            Taxes_Fees__c = 500
        );

        insert booking;

        return booking;
    }
}