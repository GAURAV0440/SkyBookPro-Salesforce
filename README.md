# SkyBook Pro

SkyBook Pro is a Salesforce flight booking project.

It lets a user search flights, select a flight, enter passenger details, confirm a booking, view bookings, cancel bookings, and track refund status.

The project is built inside Salesforce using Lightning Web Components, Apex, custom objects, flows, validation rules, and the Duffel flight API.

---

# Project Overview

SkyBook Pro was created to show how a flight booking system can work inside Salesforce.

The main idea is simple:

- A user searches for flights.
- Salesforce asks Duffel for flight offers.
- The user selects one offer.
- Salesforce stores the passenger, flight, and booking information.
- Agents can view bookings, cancel bookings, and see booking totals.

This project can be used by:

- Students learning Salesforce development.
- Recruiters or interviewers reviewing a Salesforce project.
- Developers who want to understand a booking workflow.
- Travel support teams as a starting point for an internal booking tool.

The project solves a common business problem: managing flight bookings, passenger details, cancellations, refunds, and approvals in one Salesforce app.

---

# Features

| Feature                | What it does                                                                                                                                     |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Flight search          | The user enters origin, destination, departure date, adult count, and cabin class. The current Duffel Apex request searches one adult passenger. |
| Duffel flight offers   | Apex calls the Duffel API and returns flight offers to the Lightning Web Component.                                                              |
| Flight result list     | Users can filter results by airline and sort results by lowest price or departure time.                                                          |
| Flight card            | Each flight result shows airline, flight number, route, time, duration, fare, and a select button.                                               |
| Passenger form         | The user enters passenger name, email, phone, date of birth, passport number, and meal preference.                                               |
| Booking confirmation   | The user reviews flight, passenger, and fare details before confirming.                                                                          |
| Booking creation       | Salesforce creates or reuses a Contact, creates or reuses a Flight record, and creates a confirmed Booking record.                               |
| Booking success screen | The app shows the new booking id and lets the user start another booking.                                                                        |
| My Bookings dashboard  | Users can see their bookings, filter them, view details, cancel a booking, or click a download action.                                           |
| Booking details        | Shows booking status, flight, passenger, seat class, base fare, and taxes.                                                                       |
| Booking cancellation   | Cancels a booking, saves a cancellation reason, sends a cancellation email, and starts refund processing logic.                                  |
| Refund status tracker  | Shows a simple refund status for a booking.                                                                                                      |
| Agent dashboard        | Shows total bookings, total revenue, and recent bookings.                                                                                        |
| Group booking approval | Metadata exists for approving large bookings through Salesforce approval tools.                                                                  |
| Booking emails         | Apex sends booking confirmation and cancellation emails.                                                                                         |
| Flight status batch    | A batch job marks past flights as completed.                                                                                                     |
| Booking cleanup job    | A queueable job can cancel old draft bookings.                                                                                                   |
| Validation rules       | Salesforce blocks invalid booking, passenger, and refund data.                                                                                   |
| Unit tests             | Apex tests and LWC Jest tests are included.                                                                                                      |

Under development:

- Itinerary download is not finished. The button currently shows a "coming soon" message.
- Real payment gateway refund processing is not finished. The queueable refund class is a placeholder for future payment API logic.
- The guided booking UI currently passes one passenger into the booking flow.
- Adult count is collected in the search form, but the Apex Duffel request currently uses one adult passenger.

---

# Project Workflow

1. The user opens the SkyBook Pro Lightning app.
2. The user searches for flights by entering route, date, and cabin class.
3. The `skyBookApp` component sends the search data to Apex.
4. `DuffelFlightSearchService` calls Duffel through the Salesforce Named Credential called `Duffel_API`.
5. Duffel returns flight offers.
6. Apex converts the Duffel response into `FlightOfferWrapper` objects.
7. The flight results are shown in Salesforce.
8. The user filters, sorts, and selects a flight.
9. The user enters passenger details.
10. The user reviews the booking confirmation screen.
11. `BookingService.createBookingFromLWC` creates or reuses the passenger Contact.
12. `FlightRecordService` creates or reuses a Flight record.
13. `BookingService` creates a confirmed Booking record.
14. The booking trigger sets defaults, validates updates, and sends confirmation email.
15. The success screen shows the booking id.
16. The user or agent can later view, cancel, or track the booking.
17. If a booking is cancelled, Salesforce sends a cancellation email and starts refund-related logic.

---

# Technologies Used

| Technology                           | Why we used it                                                                                    |
| ------------------------------------ | ------------------------------------------------------------------------------------------------- |
| Salesforce Platform                  | It stores data, runs business rules, and provides the main app environment.                       |
| Salesforce DX                        | It keeps Salesforce metadata in a Git-friendly project structure.                                 |
| Lightning Web Components             | It builds the user interface inside Salesforce.                                                   |
| Apex                                 | It runs server-side logic such as flight search, booking creation, cancellation, email, and jobs. |
| SOQL                                 | It reads Salesforce records from Apex. SOQL is Salesforce's query language.                       |
| Custom Objects                       | They store project data such as bookings, flights, refunds, and passenger details.                |
| Salesforce Flows                     | They automate approval, reminders, and rollup-style work without writing only Apex.               |
| Salesforce Approval Process          | It supports supervisor approval for group bookings.                                               |
| Salesforce Validation Rules          | They stop bad data from being saved.                                                              |
| Salesforce Lightning Message Service | It lets Lightning components send booking messages to each other.                                 |
| Duffel API                           | It provides real flight offer data for flight search.                                             |
| Named Credential                     | It stores the Duffel connection setup securely in Salesforce.                                     |
| LWC Jest                             | It tests Lightning Web Components.                                                                |
| ESLint                               | It checks JavaScript code quality.                                                                |
| Prettier                             | It formats Apex, XML, JavaScript, HTML, JSON, and Markdown files.                                 |
| Husky and lint-staged                | They run formatting, linting, and related tests before commits.                                   |

---

# Project Structure

```text
skybook-pro/
+-- force-app/main/default/
|   +-- applications/
|   +-- approvalProcesses/
|   +-- classes/
|   +-- flows/
|   +-- flexipages/
|   +-- lwc/
|   +-- messageChannels/
|   +-- objects/
|   +-- permissionsets/
|   +-- triggers/
|   +-- workflows/
+-- config/
+-- scripts/
+-- package.json
+-- sfdx-project.json
+-- jest.config.js
+-- eslint.config.js
+-- README.md
```

| Path                                       | What it contains                                                                        |
| ------------------------------------------ | --------------------------------------------------------------------------------------- |
| `force-app/main/default/applications`      | Salesforce app metadata, including the SkyBook Pro app.                                 |
| `force-app/main/default/classes`           | Apex classes for Duffel calls, booking logic, emails, jobs, wrappers, and tests.        |
| `force-app/main/default/triggers`          | The Booking trigger.                                                                    |
| `force-app/main/default/lwc`               | Lightning Web Components for the user interface.                                        |
| `force-app/main/default/objects`           | Custom Salesforce objects and fields.                                                   |
| `force-app/main/default/flows`             | Salesforce automation flows.                                                            |
| `force-app/main/default/approvalProcesses` | Group booking approval process metadata.                                                |
| `force-app/main/default/messageChannels`   | Lightning Message Service channel for booking messages.                                 |
| `force-app/main/default/permissionsets`    | Permission sets for Duffel access, refunds, and group booking management.               |
| `force-app/main/default/workflows`         | Field updates used by approval and workflow metadata.                                   |
| `config`                                   | Scratch org configuration. A scratch org is a temporary Salesforce org for development. |
| `scripts`                                  | Sample Apex and SOQL scripts.                                                           |
| `package.json`                             | Node scripts and development dependencies for tests, linting, and formatting.           |

---

# How Everything Works Together

## Frontend

The frontend is made of Lightning Web Components.

Important components:

- `skyBookApp` controls the full booking journey.
- `flightSearchForm` collects search input.
- `flightResultsList` shows and filters offers.
- `flightResultCard` shows one flight offer.
- `passengerDetailsForm` collects passenger data.
- `bookingConfirmation` confirms the booking and calls Apex.
- `bookingSuccess` shows the final booking id.
- `myBookingsDashboard` shows existing bookings.
- `agentDashboard` shows booking totals and recent bookings.
- `refundStatusTracker` shows refund progress.

## Backend

The backend is Apex.

Important classes:

- `DuffelFlightSearchService` searches flights from Duffel.
- `BookingService` creates, reads, cancels, and summarizes bookings.
- `FlightRecordService` creates or reuses Flight records.
- `BookingEmailService` sends booking and cancellation emails.
- `BookingTriggerHandler` keeps trigger logic organized.
- `BookingRefundQueueable` is prepared for future refund processing.
- `FlightStatusBatch` marks old flights as completed.
- `BookingCleanupJob` cancels old draft bookings.

## Database

The database is Salesforce data storage.

Custom objects such as `Booking__c`, `Flight__c`, `Refund__c`, and `Passenger_Detail__c` store the project data.

## External API

Duffel is used for flight search.

Apex sends a request to Duffel and receives offers. The offers are then shown in the Lightning Web Components.

## Authentication

Salesforce login handles user access.

Duffel authentication should be configured in Salesforce using a Named Credential called `Duffel_API`. The secret key should not be stored directly in the repository.

---

# APIs Used

## Duffel API

Duffel is the active external flight API in this project.

It is used to:

- Search flight offers.
- Read airline, route, time, price, currency, and duration data.
- Return offers to the Salesforce UI.

The Apex endpoint is:

```text
callout:Duffel_API/air/offer_requests
```

This means Salesforce expects a Named Credential named `Duffel_API`.

## Phase 2 API Update: Amadeus to Duffel

Originally, the project used Amadeus-related naming.

In Phase 2, the flight search implementation was moved to Duffel because Duffel better matched the final project implementation and requirements.

Important note:

- The active Apex services use Duffel.
- The custom field `Amadeus_Offer_ID__c` still exists on `Flight__c`.
- In the current code, that older field name is used to store the Duffel offer id.

This is a legacy naming detail, not an active Amadeus integration.

## Internal Apex Methods Used by LWC

| Apex method                               | Used for                                        |
| ----------------------------------------- | ----------------------------------------------- |
| `DuffelFlightSearchService.searchFlights` | Searches flight offers from Duffel.             |
| `BookingService.createBookingFromLWC`     | Creates passenger, flight, and booking records. |
| `BookingService.getMyBookings`            | Shows bookings for the current Salesforce user. |
| `BookingService.getBookingDetails`        | Shows one booking's details.                    |
| `BookingService.cancelBooking`            | Cancels a booking.                              |
| `BookingService.getRefundStatus`          | Returns simple refund status text.              |
| `BookingService.getTotalBookings`         | Counts bookings for the agent dashboard.        |
| `BookingService.getTotalRevenue`          | Calculates total booking revenue.               |
| `BookingService.getRecentBookings`        | Shows recent bookings.                          |

---

# Database

Salesforce stores the project data.

In Salesforce, a custom object is like a database table. A field is like a column.

| Object                                                      | What it stores                                                                                                          |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `Booking__c`                                                | Main booking record. Stores passenger, flight, status, date, seat class, fare, taxes, and cancellation reason.          |
| `Flight__c`                                                 | Flight details such as airline, flight number, origin, destination, departure, arrival, duration, status, and offer id. |
| `Passenger_Detail__c`                                       | Passenger information such as name, email, date of birth, passport, meal preference, and seat number.                   |
| `Flight_Segment__c`                                         | Segment-level flight information for multi-part journeys.                                                               |
| `Refund__c`                                                 | Refund amount, refund status, requested date, completed date, and refund reference.                                     |
| `Group_Approval__c`                                         | Approval status and supervisor information for group bookings.                                                          |
| `Public_Event__c`, `Sessions__c`, `Session_Registration__c` | Extra Salesforce metadata in the repository. These objects are not part of the main SkyBook booking flow.               |
| `Account`                                                   | Standard Salesforce object used for customer/account records.                                                           |
| `Contact`                                                   | Standard Salesforce object used for the primary passenger in the current booking flow.                                  |
| `Case`                                                      | Standard Salesforce object used by refund-related flow metadata.                                                        |

## Important Data Rules

| Rule                                                     | Meaning                                                               |
| -------------------------------------------------------- | --------------------------------------------------------------------- |
| Booking departure must be in the future                  | Users cannot create a booking for a flight that has already departed. |
| Seat count must be positive                              | At least one seat is required.                                        |
| Cancellation reason is required                          | A booking needs a reason when it is cancelled.                        |
| Cancelled or refunded bookings cannot be confirmed again | This protects booking history.                                        |
| Refund cannot be more than booking total                 | Refund amount must stay within the paid amount.                       |
| Passport required for international passenger details    | International passengers need passport information.                   |

---

# AI Features

This repository does not currently include AI features.

There is no OpenAI API, chatbot, recommendation model, or machine learning model in the codebase.

The main intelligence in the project comes from Salesforce automation, validation rules, Apex logic, and the Duffel flight API.

---

# Installation

## 1. Clone the repository

```bash
git clone <repository-url>
cd skybook-pro
```

## 2. Install Node dependencies

```bash
npm install
```

Node dependencies are used for LWC Jest tests, linting, formatting, and Git hooks.

## 3. Install Salesforce CLI

Install the Salesforce CLI if it is not already installed.

Then confirm it works:

```bash
sf --version
```

## 4. Log in to a Salesforce org

```bash
sf org login web --alias skybook-dev --set-default
```

## 5. Deploy the Salesforce metadata

```bash
sf project deploy start --source-dir force-app
```

If you want to deploy to a specific org, use your org alias instead of a real username:

```bash
sf project deploy start --source-dir force-app --target-org skybook-dev
```

## 6. Configure Duffel access in Salesforce

Create a Named Credential in Salesforce:

| Setting  | Value                                                          |
| -------- | -------------------------------------------------------------- |
| Name     | `Duffel_API`                                                   |
| Purpose  | Allows Apex to call Duffel without storing the secret in code. |
| Base URL | Duffel API base URL, usually `https://api.duffel.com`.         |
| Secret   | Your Duffel API token. Do not commit it to Git.                |

The code calls:

```text
callout:Duffel_API/air/offer_requests
```

## 7. Open the Salesforce org

```bash
sf org open
```

Then open the SkyBook Pro app from the Salesforce App Launcher.

## 8. Run LWC unit tests

```bash
npm test
```

## 9. Run LWC coverage

```bash
npm run test:unit:coverage
```

You can also run the same LWC coverage command directly:

```bash
npx sfdx-lwc-jest --coverage
```

## 10. Run linting

```bash
npm run lint
```

---

# Environment Variables

This repository does not include a `.env` file.

Secrets should not be stored in Git.

| Variable or setting           | Description                                                                                                                                               |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Duffel_API` Named Credential | Salesforce setting used by Apex to call Duffel. This should hold the Duffel API connection and secret token.                                              |
| `DUFFEL_API_KEY` placeholder  | `DuffelAuthService` currently returns this placeholder string. Do not replace it with a real key in source code. Use a secure Salesforce setting instead. |

---

# Testing

The project includes two main test types.

| Test type      | Location                                   | Purpose                                                                                        |
| -------------- | ------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| Apex tests     | `force-app/main/default/classes/*Test.cls` | Test booking logic, Duffel parsing, pricing, flight records, triggers, emails, and async jobs. |
| LWC Jest tests | `force-app/main/default/lwc/**/__tests__`  | Test Lightning Web Component behavior.                                                         |

Useful commands:

```bash
npm test
npm run test:unit:coverage
npx sfdx-lwc-jest --coverage
npm run lint
npm run prettier:verify
```

Run all local Apex tests in a specific Salesforce org and collect Apex code coverage:

```bash
sf apex run test --target-org skybook-dev --test-level RunLocalTests --code-coverage --wait 60
```

Deploy the full `force-app` metadata folder to a specific Salesforce org:

```bash
sf project deploy start --source-dir force-app --target-org skybook-dev
```

---

# Future Improvements

- Rename the legacy `Amadeus_Offer_ID__c` field to a Duffel-friendly name.
- Add real payment gateway integration.
- Complete itinerary PDF/download functionality.
- Store all passenger records in `Passenger_Detail__c` during the guided booking flow.
- Support multiple passengers from search to final booking.
- Add more detailed refund status updates.
- Add better error messages for Duffel callout failures.
- Add screenshots and demo video links.
- Add deployment notes for Named Credential setup.
- Add more page layouts and Lightning App Builder configuration for the main components.

---

# Challenges Faced

- Connecting Salesforce Apex to an external flight API requires secure callout setup.
- Duffel response data must be converted into simple objects that LWC can display.
- Salesforce validation rules and Apex logic must agree with each other.
- Booking cancellation touches many areas: status, reason, email, refund tracking, and automation.
- Some older metadata names still reference Amadeus even though Duffel is now the active API.
- Some features are partly prepared in metadata but not fully connected to the guided booking UI yet.
- Some UI values, such as adult count and cancellation reason text, are collected but need deeper backend connection.

---

# Lessons Learned

This project helps explain:

- How Salesforce DX projects are organized.
- How Lightning Web Components talk to Apex.
- How Apex calls an external API.
- How custom Salesforce objects work like database tables.
- How validation rules protect data quality.
- How triggers, queueable jobs, batch jobs, flows, and approval processes support business workflows.
- How tests are written for Apex and LWC.
- Why secrets should be stored in Salesforce configuration, not in source code.

---

# Contributors

| Name   | Role                        |
| ------ | --------------------------- |
| Gaurav | Project owner and developer |

---

