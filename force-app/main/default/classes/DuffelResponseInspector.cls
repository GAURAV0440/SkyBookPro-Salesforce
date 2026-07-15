public with sharing class DuffelResponseInspector {

    public static void inspectOffer() {

        List<FlightOfferWrapper> flights =
            DuffelFlightSearchService.searchFlights(
                'DEL',
                'BOM',
                Date.today(),
                'economy'
            );

        System.debug(
            'Flights Found = ' +
            flights.size()
        );
    }
}