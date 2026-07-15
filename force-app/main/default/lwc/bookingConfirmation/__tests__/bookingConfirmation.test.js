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
            price: 5000,
            currencyCode: 'INR'
        };

        element.passenger = {
            firstName: 'Gaurav',
            lastName: 'Chawla',
            email: 'test@test.com',
            phone: '9999999999'
        };

        document.body.appendChild(element);

        const button =
            element.shadowRoot.querySelector(
                'lightning-button'
            );

        expect(button).not.toBeNull();

        expect(button.label)
            .toBe('Confirm Booking');

    });

});