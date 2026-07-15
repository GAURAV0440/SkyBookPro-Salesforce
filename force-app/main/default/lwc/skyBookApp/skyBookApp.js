import { LightningElement } from 'lwc';
import searchFlights
from '@salesforce/apex/DuffelFlightSearchService.searchFlights';

export default class SkyBookApp extends LightningElement {

    flights = [];

    selectedFlight;

    bookingData;

    bookingId;

    showSearch = true;
    showResults = false;
    showPassengerForm = false;
    showConfirmation = false;
    showSuccess = false;

    async handleFlightSearch(event) {

        const searchData = event.detail;

        try {

            this.flights = await searchFlights({

                origin: searchData.origin,

                destination: searchData.destination,

                departureDate: searchData.departureDate,

                cabinClass: searchData.cabinClass

            });

            this.showSearch = true;
            this.showResults = true;
            this.showPassengerForm = false;
            this.showConfirmation = false;
            this.showSuccess = false;

        }

        catch (error) {

            console.error(error);

            alert('Unable to search flights.');

        }

    }

    handleFlightSelected(event) {

        this.selectedFlight = event.detail;

        this.showSearch = false;
        this.showResults = false;
        this.showPassengerForm = true;
        this.showConfirmation = false;
        this.showSuccess = false;

    }

    handlePassengerSubmit(event) {

        const passengers = event.detail;

        this.bookingData = {

            passengers: passengers,

            passengerCount: passengers.length,

            primaryEmail: passengers[0].email,

            primaryPhone: passengers[0].phone

        };

        this.showPassengerForm = false;

        this.showConfirmation = true;

    }

    handleBookingConfirmed(event) {

        this.bookingId = event.detail;

        this.showConfirmation = false;

        this.showSuccess = true;

    }

    handleNewBooking() {

        this.flights = [];

        this.selectedFlight = null;

        this.bookingData = null;

        this.bookingId = null;

        this.showSearch = true;

        this.showResults = false;

        this.showPassengerForm = false;

        this.showConfirmation = false;

        this.showSuccess = false;

    }

}