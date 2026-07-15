import { LightningElement, api } from 'lwc';

export default class FlightSearchForm extends LightningElement {

    @api origin = '';
    @api initialDestination = '';

    destination = '';
    departureDate = '';
    returnDate = '';
    adults = 1;
    cabinClass = 'economy';

    connectedCallback() {

        if (this.initialDestination) {
            this.destination = this.initialDestination;
        }
    }

    cabinOptions = [
        { label: 'Economy', value: 'economy' },
        { label: 'Premium Economy', value: 'premium_economy' },
        { label: 'Business', value: 'business' },
        { label: 'First Class', value: 'first' }
    ];

    handleOriginChange(event) {
        this.origin = event.target.value;
    }

    handleDestinationChange(event) {
        this.destination = event.target.value;
    }

    handleDepartureDateChange(event) {
        this.departureDate = event.target.value;
    }

    handleReturnDateChange(event) {
        this.returnDate = event.target.value;
    }

    handleAdultsChange(event) {
        this.adults = event.target.value;
    }

    handleCabinClassChange(event) {
        this.cabinClass = event.target.value;
    }

    handleSearch() {

        if (
            !this.origin ||
            !this.destination ||
            !this.departureDate
        ) {

            alert('Please fill all required fields');
            return;
        }

        this.dispatchEvent(
            new CustomEvent(
                'flightsearch',
                {
                    detail: {
                        origin: this.origin,
                        destination: this.destination,
                        departureDate: this.departureDate,
                        returnDate: this.returnDate,
                        adults: this.adults,
                        cabinClass: this.cabinClass
                    }
                }
            )
        );
    }
}