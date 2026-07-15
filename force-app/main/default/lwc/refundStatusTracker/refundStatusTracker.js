import {
    LightningElement,
    api,
    wire
} from 'lwc';

import getRefundStatus
from '@salesforce/apex/BookingService.getRefundStatus';

export default class RefundStatusTracker
extends LightningElement {

    @api bookingId;

    refundStatus = 'Initiated';

    @wire(
        getRefundStatus,
        {
            bookingId: '$bookingId'
        }
    )
    wiredRefundStatus({
        error,
        data
    }) {

        if (data) {

            this.refundStatus =
                data;
        }

        if (error) {

            console.error(error);
        }
    }

    get isRefunded() {

        return this.refundStatus ===
            'Refunded';
    }
}