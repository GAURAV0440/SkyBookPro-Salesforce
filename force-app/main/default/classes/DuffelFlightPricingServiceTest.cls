@isTest
private class DuffelFlightPricingServiceTest {

    @isTest
    static void testEconomyPrice() {

        Decimal price =
            DuffelFlightPricingService.calculatePrice(
                'Economy',
                1000
            );

        System.assertEquals(
            1000,
            price
        );
    }


    @isTest
    static void testBusinessPrice() {

        Decimal price =
            DuffelFlightPricingService.calculatePrice(
                'Business',
                1000
            );

        System.assertEquals(
            1500,
            price
        );
    }


    @isTest
    static void testFirstClassPrice() {

        Decimal price =
            DuffelFlightPricingService.calculatePrice(
                'First Class',
                1000
            );

        System.assertEquals(
            2000,
            price
        );
    }
}