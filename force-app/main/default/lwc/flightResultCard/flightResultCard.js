import {
    LightningElement,
    api
} from 'lwc';

export default class FlightResultCard
extends LightningElement {

    @api flight;

    get departure() {

        if (!this.flight.departureTime) {
            return '';
        }

        return new Date(
            this.flight.departureTime
        ).toLocaleString();
    }

    get arrival() {

        if (!this.flight.arrivalTime) {
            return '';
        }

        return new Date(
            this.flight.arrivalTime
        ).toLocaleString();
    }

    handleSelect() {

        this.dispatchEvent(

            new CustomEvent(

                'selectflight',

                {
                    detail: this.flight
                }

            )

        );

    }

}