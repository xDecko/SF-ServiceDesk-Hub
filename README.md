# SF ServiceDesk Hub

This project is a Salesforce MVP built to practice a Salesforce Developer workflow.

The main goal was to create a simple ticket management flow using both declarative tools and code.  
Instead of trying to build a huge app, the idea was to complete a functional vertical slice that includes:

- custom object
- fields and validation
- a formula field
- Apex trigger and handler
- an Apex controller
- a Lightning Web Component
- automated and manual testing

I know Salesforce already includes standard objects like Cases for this kind of process, but this Service Hub MVP was built for testing and learning purposes, not to replace the standard solution.

## What this project does

The project uses a custom object called `Service_Request__c` to manage service tickets.

Each ticket includes basic information like:

- Subject
- Description
- Status
- Priority
- Assigned To
- Due Date
- Overdue flag

### Declarative part
I first created the base metadata in Salesforce:

- custom object: `Service_Request__c`
- validation rule to prevent closing a ticket without an assigned user
- formula field `Is_Overdue__c` to automatically mark overdue tickets

### Apex business logic
Then I added the business logic in Apex using:

- `ServiceRequestTrigger`
- `ServiceRequestHandler`

The trigger is intentionally thin, and the logic lives in the handler.

Rules implemented:

- if `Status__c` is empty on insert, set it to `New`
- if `Due_Date__c` is empty on insert, set it to today + 3 days
- if `Subject__c` or `Description__c` contains `urgent` or `critical`, set `Priority__c` to `High`
- if a ticket is updated from another priority to `High`, set `Due_Date__c` to today + 1 day

### Apex controller
I also created:

- `OpenRequestsController`

This controller exposes an `@AuraEnabled(cacheable=true)` method that returns open tickets so they can be consumed by the frontend.

### Lightning Web Component
For the UI, I built:

- `openRequestsList`

This LWC uses `@wire` with the Apex controller and shows open tickets on a Lightning Home page.

## Testing

The project includes Apex tests for the trigger/handler logic.

Tested scenarios:

- default values on insert
- keyword detection for high priority
- updating priority to high
- bulk insert
- bulk update

I also did manual validation in the UI to confirm that the rules behave correctly in real records.

## Project goal

- data model design
- declarative configuration
- Apex trigger logic
- handler pattern
- controller for LWC
- simple frontend with LWC
- automated testing
- manual validation

## Tech used

- Salesforce Developer Edition
- Salesforce CLI
- VS Code
- Apex
- Lightning Web Components
- Git / GitHub

## Author
Manuel Fernández
Built as a hands-on Salesforce Developer practice project.