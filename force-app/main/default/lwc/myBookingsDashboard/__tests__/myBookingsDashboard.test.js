import { createElement } from 'lwc';
import MyBookingsDashboard from 'c/myBookingsDashboard';

describe('c-my-bookings-dashboard', () => {

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders component successfully', () => {

        const element = createElement(
            'c-my-bookings-dashboard',
            {
                is: MyBookingsDashboard
            }
        );

        document.body.appendChild(element);

        expect(element).toBeTruthy();
    });

});