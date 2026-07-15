public class FlightOfferWrapper {

    @AuraEnabled
    public String offerId;

    @AuraEnabled
    public String flightNumber;

    @AuraEnabled
    public String airline;

    @AuraEnabled
    public String origin;

    @AuraEnabled
    public String destination;

    @AuraEnabled
    public Datetime departureTime;

    @AuraEnabled
    public Datetime arrivalTime;

    @AuraEnabled
    public String duration;

    @AuraEnabled
    public Decimal price;

    @AuraEnabled
    public String currencyCode;

    @AuraEnabled
    public Integer seatsAvailable;

    @AuraEnabled
    public String seatClass;

    @AuraEnabled
    public List<SegmentWrapper> segments;

    public class SegmentWrapper {

        @AuraEnabled
        public String departureAirport;

        @AuraEnabled
        public String arrivalAirport;

        @AuraEnabled
        public Datetime departureTime;

        @AuraEnabled
        public Datetime arrivalTime;

        @AuraEnabled
        public String carrierCode;

        @AuraEnabled
        public String flightNumber;
    }
}