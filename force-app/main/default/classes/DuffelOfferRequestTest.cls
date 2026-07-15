@isTest
public with sharing class DuffelOfferRequestTest {

    @isTest
    static void testOfferRequest() {

        Test.startTest();

        Http http = new Http();

        HttpRequest req = new HttpRequest();

        req.setEndpoint('callout:Duffel_API/air/offer_requests');
        req.setMethod('POST');

        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Duffel-Version', 'v2');

        String body =
        '{' +
            '"data":{' +
                '"slices":[{' +
                    '"origin":"DEL",' +
                    '"destination":"BOM",' +
                    '"departure_date":"2026-07-01"' +
                '}],' +
                '"passengers":[{' +
                    '"type":"adult"' +
                '}],' +
                '"cabin_class":"economy"' +
            '}' +
        '}';

        req.setBody(body);

        System.debug('Offer Request Body => ' + body);

        Test.stopTest();
    }
}