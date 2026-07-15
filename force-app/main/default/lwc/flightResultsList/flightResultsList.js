import {
    LightningElement,
    api
} from 'lwc';

export default class FlightResultsList
extends LightningElement {

    @api flights = [];

    selectedAirline = '';

    sortBy = 'price';

    sortOptions = [

        {
            label: 'Lowest Price',
            value: 'price'
        },

        {
            label: 'Departure Time',
            value: 'departure'
        }

    ];

    get hasFlights() {

        return this.filteredFlights.length > 0;

    }

    get airlineOptions() {

        const airlines = [

            ...new Set(

                this.flights.map(

                    flight => flight.airline

                )

            )

        ];

        return [

            {

                label: 'All Airlines',
                value: ''

            },

            ...airlines.map(

                airline => ({

                    label: airline,
                    value: airline

                })

            )

        ];

    }

    get filteredFlights() {

        let data = [...this.flights];

        if (this.selectedAirline) {

            data = data.filter(

                flight =>

                    flight.airline ===
                    this.selectedAirline

            );

        }

        if (this.sortBy === 'price') {

            data.sort(

                (a, b) =>

                    a.price - b.price

            );

        }

        if (this.sortBy === 'departure') {

            data.sort(

                (a, b) =>

                    new Date(a.departureTime) -

                    new Date(b.departureTime)

            );

        }

        return data;

    }

    handleAirlineChange(event) {

        this.selectedAirline =
            event.detail.value;

    }

    handleSortChange(event) {

        this.sortBy =
            event.detail.value;

    }

    handleSelectFlight(event) {

        this.dispatchEvent(

            new CustomEvent(

                'selectflight',

                {

                    detail: event.detail

                }

            )

        );

    }

}