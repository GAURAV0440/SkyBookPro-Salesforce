public with sharing class FlightRecordService {

    public static Flight__c createFlightRecord(
        FlightOfferWrapper offer
    ) {

        // Check if same flight already exists
        List<Flight__c> existingFlights = [
            SELECT Id,
                   Name,
                   Flight_Number__c,
                   Departure_DateTime__c
            FROM Flight__c
            WHERE Flight_Number__c = :offer.flightNumber
            AND Departure_DateTime__c = :offer.departureTime
            LIMIT 1
        ];

        if (!existingFlights.isEmpty()) {

            System.debug(
                'Flight already exists => ' +
                existingFlights[0].Id
            );

            return existingFlights[0];
        }

        Flight__c flight = new Flight__c();

        // Record Name
        flight.Name =
            offer.airline + ' - ' + offer.flightNumber;

        // Flight Details
        flight.Flight_Number__c =
            offer.flightNumber;

        flight.Airline_Name__c =
            offer.airline;

        flight.Origin_Airport__c =
            offer.origin;

        flight.Destination_Airport__c =
            offer.destination;

        // Date & Time
        flight.Departure_DateTime__c =
            offer.departureTime;

        flight.Arrival_DateTime__c =
            offer.arrivalTime;

        // Duration
        if (
            offer.departureTime != null &&
            offer.arrivalTime != null
        ) {

            Long diffMillis =
                offer.arrivalTime.getTime() -
                offer.departureTime.getTime();

            flight.Duration_Minutes__c =
                Integer.valueOf(
                    diffMillis / (1000 * 60)
                );
        }

        // Status
        flight.Status__c = 'Active';

        // Duffel Offer Id
        flight.Amadeus_Offer_ID__c =
            offer.offerId;

        insert flight;

        System.debug(
            'New Flight Created => ' +
            flight.Id
        );

        return flight;
    }
}