import { LightningElement, api } from 'lwc';

export default class PassengerDetailsForm extends LightningElement {

    @api passengerCount = 1;

    @api isInternational = false;

    passengers = [];

    mealOptions = [
        {
            label: 'Vegetarian',
            value: 'Vegetarian'
        },
        {
            label: 'Non-Vegetarian',
            value: 'Non-Vegetarian'
        },
        {
            label: 'Vegan',
            value: 'Vegan'
        },
        {
            label: 'No Preference',
            value: 'No Preference'
        }
    ];

    connectedCallback() {

        this.passengers = [];

        for (let i = 1; i <= this.passengerCount; i++) {

            this.passengers.push({

                id: i,

                firstName: '',

                lastName: '',

                email: '',

                phone: '',

                dob: '',

                passport: '',

                mealPreference: 'No Preference'

            });

        }

    }

    handleChange(event) {

        const index =
            Number(event.target.dataset.index) - 1;

        const field =
            event.target.name;

        this.passengers[index][field] =
            event.target.value;

        this.passengers = [...this.passengers];

    }

    validateAllPassengers() {

        for (const passenger of this.passengers) {

            if (

                !passenger.firstName ||

                !passenger.lastName ||

                !passenger.email ||

                !passenger.phone ||

                !passenger.dob

            ) {

                return false;

            }

            if (

                this.isInternational &&

                !passenger.passport

            ) {

                return false;

            }

        }

        return true;

    }

    handleContinue() {

        if (!this.validateAllPassengers()) {

            alert(

                this.isInternational

                    ? 'Please complete all passenger details including Passport Number.'

                    : 'Please complete all required passenger details.'

            );

            return;

        }

        this.dispatchEvent(

            new CustomEvent(

                'passengersubmit',

                {

                    detail: this.passengers

                }

            )

        );

    }

}