global class FlightStatusBatch
implements Database.Batchable<SObject> {

    global Database.QueryLocator start(
        Database.BatchableContext bc
    ) {

        return Database.getQueryLocator(
            [
                SELECT Id,
                       Status__c,
                       Departure_DateTime__c
                FROM Flight__c
                WHERE Departure_DateTime__c < :System.now()
            ]
        );
    }

    global void execute(
        Database.BatchableContext bc,
        List<Flight__c> scope
    ) {

        for(Flight__c flight : scope){

            flight.Status__c = 'Completed';
        }

        update scope;
    }

    global void finish(
        Database.BatchableContext bc
    ) {

        System.debug(
            'Flight Status Batch Completed'
        );
    }
}