public with sharing class DuffelResponseInspector {

    public static void inspectOffer() {

        List<FlightOfferWrapper> flights =
            DuffelFlightSearchService.searchFlights(
                'DEL',
                'BOM',
                Date.today().addDays(20)
            );

        System.debug(
            'Flights Found = ' +
            flights.size()
        );
    }
}