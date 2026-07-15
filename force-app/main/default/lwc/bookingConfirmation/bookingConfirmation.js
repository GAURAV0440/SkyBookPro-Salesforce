import { LightningElement, api } from 'lwc';

import createBookingFromLWC
from '@salesforce/apex/BookingService.createBookingFromLWC';

export default class BookingConfirmation
extends LightningElement {

    @api flight;

    @api bookingData;

    isLoading = false;

    get passenger() {

        if (
            this.bookingData &&
            this.bookingData.passengers &&
            this.bookingData.passengers.length > 0
        ) {

            return this.bookingData.passengers[0];

        }

        return {};

    }

    get totalFare() {

        if (!this.flight) {

            return '0.00';

        }

        const price =
            Number(this.flight.price || 0);

        const count =
            Number(
                this.bookingData?.passengerCount || 1
            );

        return (
            price * count
        ).toFixed(2);

    }

    async handleConfirmBooking() {

        this.isLoading = true;

        try {

            const passenger =
                this.passenger;

            const bookingId =
                await createBookingFromLWC({

                    firstName:
                        passenger.firstName,

                    lastName:
                        passenger.lastName,

                    email:
                        passenger.email,

                    phone:
                        passenger.phone,

                    airline:
                        this.flight.airline,

                    flightNumber:
                        this.flight.flightNumber,

                    origin:
                        this.flight.origin,

                    destination:
                        this.flight.destination,

                    departureTime:
                        this.flight.departureTime,

                    arrivalTime:
                        this.flight.arrivalTime,

                    price:
                        this.flight.price,

                    offerId:
                        this.flight.offerId,

                    seatClass:
                        this.flight.seatClass || 'Economy'

                });

            this.dispatchEvent(

                new CustomEvent(

                    'confirmbooking',

                    {

                        detail: bookingId

                    }

                )

            );

        }

        catch (error) {

            console.error(
                'Booking Error',
                error
            );

            let message =
                'Booking Failed';

            if (
                error &&
                error.body &&
                error.body.message
            ) {

                message =
                    error.body.message;

            }
            else if (
                error &&
                error.message
            ) {

                message =
                    error.message;

            }

            alert(message);

        }

        finally {

            this.isLoading = false;

        }

    }

}