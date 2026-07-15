public with sharing class DuffelFlightSearchService {

    @AuraEnabled(cacheable=false)
    public static List<FlightOfferWrapper> searchFlights(
        String origin,
        String destination,
        Date departureDate
    ) {

        List<FlightOfferWrapper> flightOffers =
            new List<FlightOfferWrapper>();

        try {

            Http http = new Http();
            HttpRequest req = new HttpRequest();

            req.setEndpoint('callout:Duffel_API/air/offer_requests');
            req.setMethod('POST');

            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Duffel-Version', 'v2');

            String requestBody =
            '{' +
                '"data":{' +
                    '"slices":[{' +
                        '"origin":"' + origin + '",' +
                        '"destination":"' + destination + '",' +
                        '"departure_date":"' + String.valueOf(departureDate) + '"' +
                    '}],' +
                    '"passengers":[{' +
                        '"type":"adult"' +
                    '}],' +
                    '"cabin_class":"economy"' +
                '}' +
            '}';

            req.setBody(requestBody);

            HttpResponse res = http.send(req);

            System.debug('STATUS => ' + res.getStatusCode());

            if(res.getStatusCode() == 201){

                Map<String,Object> responseMap =
                    (Map<String,Object>)JSON.deserializeUntyped(
                        res.getBody()
                    );

                Map<String,Object> data =
                    (Map<String,Object>)responseMap.get('data');

                List<Object> offers =
                    (List<Object>)data.get('offers');

                for(Object obj : offers){

                    Map<String,Object> offer =
                        (Map<String,Object>)obj;

                    FlightOfferWrapper wrapper =
                        new FlightOfferWrapper();

                    wrapper.offerId =
                        String.valueOf(
                            offer.get('id')
                        );

                    wrapper.price =
                        Decimal.valueOf(
                            String.valueOf(
                                offer.get('total_amount')
                            )
                        );

                    wrapper.currencyCode =
                        String.valueOf(
                            offer.get('total_currency')
                        );

                    wrapper.seatClass = 'Economy';

                    List<Object> slices =
                        (List<Object>)offer.get('slices');

                    if(slices != null &&
                       !slices.isEmpty()){

                        Map<String,Object> slice =
                            (Map<String,Object>)slices[0];

                        wrapper.duration =
                            String.valueOf(
                                slice.get('duration')
                            );

                        List<Object> segments =
                            (List<Object>)slice.get('segments');

                        if(segments != null &&
                           !segments.isEmpty()){

                            Map<String,Object> segment =
                                (Map<String,Object>)segments[0];

                            Map<String,Object> marketingCarrier =
                                (Map<String,Object>)
                                segment.get(
                                    'marketing_carrier'
                                );

                            wrapper.airline =
                                String.valueOf(
                                    marketingCarrier.get(
                                        'name'
                                    )
                                );

                            wrapper.flightNumber =
                                String.valueOf(
                                    segment.get(
                                        'marketing_carrier_flight_number'
                                    )
                                );

                            Map<String,Object> originAirport =
                                (Map<String,Object>)
                                segment.get('origin');

                            Map<String,Object> destinationAirport =
                                (Map<String,Object>)
                                segment.get('destination');

                            wrapper.origin =
                                String.valueOf(
                                    originAirport.get(
                                        'iata_code'
                                    )
                                );

                            wrapper.destination =
                                String.valueOf(
                                    destinationAirport.get(
                                        'iata_code'
                                    )
                                );

                            String departTime =
                                String.valueOf(
                                    segment.get(
                                        'departing_at'
                                    )
                                );

                            String arriveTime =
                                String.valueOf(
                                    segment.get(
                                        'arriving_at'
                                    )
                                );

                            if(departTime != null){

                                departTime =
                                    departTime.replace(
                                        'T',
                                        ' '
                                    );

                                departTime =
                                    departTime.replace(
                                        'Z',
                                        ''
                                    );

                                wrapper.departureTime =
                                    Datetime.valueOfGmt(
                                        departTime
                                    );
                            }

                            if(arriveTime != null){

                                arriveTime =
                                    arriveTime.replace(
                                        'T',
                                        ' '
                                    );

                                arriveTime =
                                    arriveTime.replace(
                                        'Z',
                                        ''
                                    );

                                wrapper.arrivalTime =
                                    Datetime.valueOfGmt(
                                        arriveTime
                                    );
                            }
                        }
                    }

                    flightOffers.add(wrapper);
                }
            }

        } catch(Exception e){

            System.debug(
                'Duffel Error => ' +
                e.getMessage()
            );
        }

        return flightOffers;
    }
}