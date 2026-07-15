import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getMyBookings
from '@salesforce/apex/BookingService.getMyBookings';

import cancelBooking
from '@salesforce/apex/BookingService.cancelBooking';

const COLUMNS = [
    {
        label: 'Booking',
        fieldName: 'Name'
    },
    {
        label: 'Status',
        fieldName: 'Booking_Status__c'
    },
    {
        label: 'Date',
        fieldName: 'Booking_Date__c',
        type: 'date'
    },
    {
        label: 'Seat Class',
        fieldName: 'Seat_Class__c'
    },
    {
        label: 'Fare',
        fieldName: 'Base_Fare__c',
        type: 'currency'
    },
    {
        type: 'button',
        typeAttributes: {
            label: 'View Details',
            name: 'view',
            variant: 'brand'
        }
    },
    {
        type: 'button',
        typeAttributes: {
            label: 'Cancel',
            name: 'cancel',
            variant: 'destructive'
        }
    },
    {
        type: 'button',
        typeAttributes: {
            label: 'Download',
            name: 'download',
            variant: 'success'
        }
    }
];

export default class MyBookingsDashboard
extends LightningElement {

    columns = COLUMNS;

    bookings = [];
    allBookings = [];

    error;

    selectedBookingId;

    activeFilter = 'all';

    @wire(getMyBookings)
    wiredBookings({ error, data }) {

        if (data) {

            this.allBookings = data;

            this.applyFilter();

            this.error = undefined;

        } else if (error) {

            this.error = error;
        }
    }

    applyFilter() {

        if (this.activeFilter === 'all') {

            this.bookings =
                [...this.allBookings];
        }

        else if (
            this.activeFilter === 'upcoming'
        ) {

            this.bookings =
                this.allBookings.filter(
                    booking =>
                        booking
                        .Days_Until_Departure__c >= 0
                );
        }

        else if (
            this.activeFilter === 'past'
        ) {

            this.bookings =
                this.allBookings.filter(
                    booking =>
                        booking
                        .Days_Until_Departure__c < 0
                );
        }

        else {

            this.bookings =
                this.allBookings.filter(
                    booking =>
                        booking
                        .Booking_Status__c ===
                        'Cancelled'
                );
        }
    }

    handleFilter(event) {

        this.activeFilter =
            event.target.dataset.filter;

        this.applyFilter();
    }

    async handleRowAction(event) {

        const action =
            event.detail.action.name;

        const row =
            event.detail.row;

        if (action === 'view') {

            this.selectedBookingId =
                row.Id;
        }

        if (action === 'cancel') {

            await cancelBooking({
                bookingId: row.Id
            });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message:
                        'Booking cancelled',
                    variant: 'success'
                })
            );
        }

        if (action === 'download') {

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Info',
                    message:
                        'Download Itinerary feature coming soon',
                    variant: 'info'
                })
            );
        }
    }
}