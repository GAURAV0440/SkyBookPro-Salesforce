@isTest
private class FlightRecordServiceTest {

    @isTest
    static void testCreateNewFlight() {

        FlightOfferWrapper offer = new FlightOfferWrapper();

        offer.offerId = 'offer123';
        offer.airline = 'Air India';
        offer.flightNumber = 'AI101';

        offer.origin = 'DEL';
        offer.destination = 'BOM';

        offer.departureTime =
            Datetime.newInstance(
                2026, 7, 10, 10, 0, 0
            );

        offer.arrivalTime =
            Datetime.newInstance(
                2026, 7, 10, 12, 30, 0
            );

        Test.startTest();

        Flight__c flight =
            FlightRecordService.createFlightRecord(
                offer
            );

        Test.stopTest();

        System.assertNotEquals(
            null,
            flight.Id
        );

        System.assertEquals(
            'AI101',
            flight.Flight_Number__c
        );

        System.assertEquals(
            'Active',
            flight.Status__c
        );

        System.assertEquals(
            150,
            flight.Duration_Minutes__c
        );
    }


    @isTest
    static void testExistingFlightReturned() {

        Flight__c existingFlight =
            new Flight__c(
                Name = 'Air India - AI101',
                Flight_Number__c = 'AI101',
                Airline_Name__c = 'Air India',
                Origin_Airport__c = 'DEL',
                Destination_Airport__c = 'BOM',
                Departure_DateTime__c =
                    Datetime.newInstance(
                        2026, 7, 10, 10, 0, 0
                    ),
                Arrival_DateTime__c =
                    Datetime.newInstance(
                        2026, 7, 10, 12, 30, 0
                    ),
                Status__c = 'Active'
            );

        insert existingFlight;


        FlightOfferWrapper offer =
            new FlightOfferWrapper();

        offer.flightNumber = 'AI101';

        offer.departureTime =
            Datetime.newInstance(
                2026, 7, 10, 10, 0, 0
            );


        Flight__c result =
            FlightRecordService.createFlightRecord(
                offer
            );

        System.assertEquals(
            existingFlight.Id,
            result.Id
        );
    }
}