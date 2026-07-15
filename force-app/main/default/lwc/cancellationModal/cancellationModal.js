import {
    LightningElement,
    api,
    wire
} from 'lwc';

import {
    publish,
    MessageContext
} from 'lightning/messageService';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

import cancelBooking
from '@salesforce/apex/BookingService.cancelBooking';

import SKYBOOK_CHANNEL
from '@salesforce/messageChannel/SkyBookChannel__c';

export default class CancellationModal
extends LightningElement {

    @api bookingId;

    @wire(MessageContext)
    messageContext;

    reason = '';

    handleReasonChange(event) {

        this.reason =
            event.target.value;
    }

    async handleCancelBooking() {

        try {

            await cancelBooking({
                bookingId: this.bookingId
            });

            publish(
                this.messageContext,
                SKYBOOK_CHANNEL,
                {
                    bookingId: this.bookingId,
                    action: 'cancelled'
                }
            );

            this.dispatchEvent(
                new CustomEvent(
                    'bookingcancelled'
                )
            );

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message:
                        'Booking cancelled successfully',
                    variant: 'success'
                })
            );

        } catch (error) {

            console.error(error);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message:
                        'Error cancelling booking',
                    variant: 'error'
                })
            );
        }
    }
}