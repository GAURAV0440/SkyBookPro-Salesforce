import {
    LightningElement,
    api
} from 'lwc';

export default class BookingSuccess
extends LightningElement {

    @api bookingId;

    handleNewBooking() {

        this.dispatchEvent(

            new CustomEvent(

                'newbooking'

            )

        );

    }

}