@isTest
private class DuffelFlightSearchServiceTest {

    private class DuffelMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setStatusCode(201);

            String body =
            '{'+
                '"data":{'+
                    '"offers":[{'+
                        '"id":"offer123",'+
                        '"total_amount":"5000",'+
                        '"total_currency":"INR",'+
                        '"slices":[{'+
                            '"duration":"PT2H",'+
                            '"segments":[{'+
                                '"marketing_carrier":{"name":"Air India"},'+
                                '"marketing_carrier_flight_number":"AI101",'+
                                '"origin":{"iata_code":"DEL"},'+
                                '"destination":{"iata_code":"BOM"},'+
                                '"departing_at":"2026-07-01T10:00:00Z",'+
                                '"arriving_at":"2026-07-01T12:00:00Z"'+
                            '}]'+
                        '}]'+
                    '}]'+
                '}'+
            '}';

            res.setBody(body);
            return res;
        }
    }

    @isTest
    static void testSearchFlights() {

        Test.setMock(
            HttpCalloutMock.class,
            new DuffelMock()
        );

        Test.startTest();

        List<FlightOfferWrapper> offers =
            DuffelFlightSearchService.searchFlights(
                'DEL',
                'BOM',
                Date.today()
            );

        Test.stopTest();

        System.assertEquals(
            1,
            offers.size()
        );

        System.assertEquals(
            'Air India',
            offers[0].airline
        );

        System.assertEquals(
            'AI101',
            offers[0].flightNumber
        );
    }
}