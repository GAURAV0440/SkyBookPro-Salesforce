import { LightningElement, api, wire } from 'lwc';
import getBookingDetails
from '@salesforce/apex/BookingService.getBookingDetails';

export default class BookingDetailView extends LightningElement {

    @api bookingId;

    booking;
    error;

    @wire(getBookingDetails, {
        bookingId: '$bookingId'
    })
    wiredBooking({ error, data }) {

        if (data) {

            this.booking = data;
            this.error = undefined;

        } else if (error) {

            this.error = error;
            this.booking = undefined;
        }
    }
}