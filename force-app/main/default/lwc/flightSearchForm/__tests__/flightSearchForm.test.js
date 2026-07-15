import { createElement } from 'lwc';
import FlightSearchForm from 'c/flightSearchForm';

describe('c-flight-search-form', () => {

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders search button', () => {

        const element = createElement(
            'c-flight-search-form',
            {
                is: FlightSearchForm
            }
        );

        document.body.appendChild(element);

        const button =
            element.shadowRoot.querySelector(
                'lightning-button'
            );

        expect(button).not.toBeNull();
        expect(button.label).toBe('Search Flights');
    });

});