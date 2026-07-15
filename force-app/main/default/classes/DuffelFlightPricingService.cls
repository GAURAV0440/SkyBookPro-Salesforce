public with sharing class DuffelFlightPricingService {

    public static Decimal calculatePrice(
        String seatClass,
        Decimal basePrice
    ) {

        Decimal finalPrice = basePrice;

        if (seatClass == 'Business') {
            finalPrice = basePrice * 1.5;
        }
        else if (seatClass == 'First Class') {
            finalPrice = basePrice * 2;
        }

        return finalPrice;
    }

}