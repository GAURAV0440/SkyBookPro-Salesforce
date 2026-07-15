import {
    LightningElement,
    wire
} from 'lwc';

import {
    subscribe,
    MessageContext
} from 'lightning/messageService';

import SKYBOOK_CHANNEL
from '@salesforce/messageChannel/SkyBookChannel__c';

import getTotalBookings
from '@salesforce/apex/BookingService.getTotalBookings';

import getTotalRevenue
from '@salesforce/apex/BookingService.getTotalRevenue';

import getRecentBookings
from '@salesforce/apex/BookingService.getRecentBookings';

export default class AgentDashboard
extends LightningElement {

    totalBookings = 0;
    totalRevenue = 0;

    get formattedRevenue() {

        return Number(
            this.totalRevenue || 0
        ).toLocaleString(
            'en-IN'
        );

    }

    recentBookings = [];

    subscription = null;

    @wire(MessageContext)
    messageContext;

    @wire(getTotalBookings)
    wiredBookings({ data }) {

        if (data) {

            this.totalBookings = data;
        }
    }

    @wire(getTotalRevenue)
    wiredRevenue({ data }) {

        if (data != null) {

            this.totalRevenue = data;
        }
    }

    @wire(getRecentBookings)
    wiredRecentBookings({ data }) {

        if (data) {

            this.recentBookings = data;
        }
    }

    connectedCallback() {

        this.subscribeToChannel();
    }

    subscribeToChannel() {

        if (this.subscription) {
            return;
        }

        this.subscription = subscribe(
            this.messageContext,
            SKYBOOK_CHANNEL,
            (message) => {

                console.log(
                    'LMS Message:',
                    message
                );
            }
        );
    }

    handleCreateBooking() {

        window.location.reload();

    }

    handleViewReports() {

        window.open(
            '/lightning/o/Report/home',
            '_blank'
        );

    }
}