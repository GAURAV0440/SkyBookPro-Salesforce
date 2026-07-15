@isTest
private class DuffelAuthServiceTest {

    @isTest
    static void testGetApiKey() {

        String apiKey = DuffelAuthService.getApiKey();

        System.assertNotEquals(
            null,
            apiKey
        );

        System.assertEquals(
            'DUFFEL_API_KEY',
            apiKey
        );
    }
}