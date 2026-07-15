@isTest
public class DuffelConnectionTest {

    private class MockResponse
    implements HttpCalloutMock {

        public HttpResponse respond(
            HttpRequest req
        ) {

            HttpResponse res =
                new HttpResponse();

            res.setStatusCode(200);

            res.setBody(
                '{"message":"success"}'
            );

            return res;
        }
    }


    @isTest
    static void testConnection() {

        Test.setMock(
            HttpCalloutMock.class,
            new MockResponse()
        );

        Test.startTest();

        Http http = new Http();

        HttpRequest req =
            new HttpRequest();

        req.setEndpoint(
            'callout:Duffel_API/air/airlines'
        );

        req.setMethod('GET');

        HttpResponse res =
            http.send(req);

        System.assertEquals(
            200,
            res.getStatusCode()
        );

        Test.stopTest();
    }
}