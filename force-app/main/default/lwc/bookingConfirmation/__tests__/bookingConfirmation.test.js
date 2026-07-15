const { createElement } = require('lwc');
const BookingConfirmation = require('c/bookingConfirmation').default;

describe('c-booking-confirmation', () => {

    afterEach(() => {

        while (document.body.firstChild) {
            document.body.removeChild(
                document.body.firstChild
            );
        }

    });

    it('renders confirm booking button', () => {

        const element = createElement(
            'c-booking-confirmation',
            {
                is: BookingConfirmation
            }
        );

        element.flight = {

            airline: 'Air India',
            origin: 'DEL',
            destination: 'BOM',
            flightNumber: 'AI101',
            departureTime: '2026-07-20T10:00:00Z',
            arrivalTime: '2026-07-20T12:00:00Z',
            offerId: 'offer123',
            seatClass: 'Economy',
            price: 5000,
            currencyCode: 'INR'

        };

        element.bookingData = {

            passengerCount: 1,

            passengers: [
                {

                    firstName: 'Gaurav',
                    lastName: 'Chawla',
                    email: 'test@test.com',
                    phone: '9999999999'

                }
            ]

        };

        document.body.appendChild(element);

        return Promise.resolve().then(() => {

            const button =
                element.shadowRoot.querySelector(
                    'lightning-button'
                );

            expect(button).not.toBeNull();

            expect(button.label)
                .toBe('Confirm Booking');

        });

    });

});