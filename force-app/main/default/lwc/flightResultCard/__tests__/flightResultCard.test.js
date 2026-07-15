import { createElement } from '@lwc/engine-dom';
import FlightResultCard from 'c/flightResultCard';

describe('c-flight-result-card', () => {

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(
                document.body.firstChild
            );
        }
    });

    it('renders flight information', () => {

        const element = createElement(
            'c-flight-result-card',
            {
                is: FlightResultCard
            }
        );

        element.flight = {
            airline: 'Air India',
            flightNumber: 'AI101',
            origin: 'DEL',
            destination: 'BOM',
            departureTime: '2026-07-03T10:00:00Z',
            arrivalTime: '2026-07-03T12:00:00Z',
            duration: '2h',
            price: 5000,
            currencyCode: 'INR'
        };

        document.body.appendChild(element);

        const buttons =
            element.shadowRoot.querySelectorAll(
                'lightning-button'
            );

        expect(buttons.length).toBe(2);

        expect(buttons[0].label)
            .toBe('Show Details');

        expect(buttons[1].label)
            .toBe('Select Flight');

    });

});