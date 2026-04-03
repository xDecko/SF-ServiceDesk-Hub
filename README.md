<div align="center">

# SF ServiceDesk Hub

<p>
  <img src="https://img.shields.io/badge/Salesforce-Developer%20Workflow-00A1E0?style=flat-square&logo=salesforce&logoColor=white" />
  <img src="https://img.shields.io/badge/Apex-Trigger%20%26%20Handler-1798c1?style=flat-square" />
  <img src="https://img.shields.io/badge/LWC-Frontend-0176D3?style=flat-square" />
  <img src="https://img.shields.io/badge/Project-MVP-5B5FC7?style=flat-square" />
</p>

<p><strong>This project is a Salesforce MVP built to practice a Salesforce Developer workflow.</strong></p>

<p>
  <a href="#overview">Overview</a> •
  <a href="#declarative-part">Declarative</a> •
  <a href="#apex-business-logic">Apex Logic</a> •
  <a href="#apex-controller">Controller</a> •
  <a href="#lightning-web-component">LWC</a> •
  <a href="#testing">Testing</a> •
  <a href="#tech-used">Tech Stack</a>
</p>

</div>

---

## Overview

The main goal was to create a simple ticket management flow using both declarative tools and code.  
Instead of trying to build a huge app, the idea was to complete a functional vertical slice that includes:

<div align="center">

| Scope | |
|---|---|
| Custom object | ✓ |
| Fields and validation | ✓ |
| Formula field | ✓ |
| Apex trigger and handler | ✓ |
| Apex controller | ✓ |
| Lightning Web Component | ✓ |
| Automated and manual testing | ✓ |

</div>

> I know Salesforce already includes standard objects like Cases for this kind of process, but this Service Hub MVP was built for testing and learning purposes, not to replace the standard solution.

---

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

  <img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/59f9e9fe-14f4-4df5-813d-b5c4174517f0" />


---

## Declarative part

I first created the base metadata in Salesforce:

- custom object: `Service_Request__c`
- validation rule to prevent closing a ticket without an assigned user
- formula field `Is_Overdue__c` to automatically mark overdue tickets

---

## Apex business logic

Then I added the business logic in Apex using:

- `ServiceRequestTrigger`
- `ServiceRequestHandler`

The trigger is intentionally thin, and the logic lives in the handler.

### Rules implemented

- if `Status__c` is empty on insert, set it to `New`
- if `Due_Date__c` is empty on insert, set it to today + 3 days
- if `Subject__c` or `Description__c` contains `urgent` or `critical`, set `Priority__c` to `High`
- if a ticket is updated from another priority to `High`, set `Due_Date__c` to today + 1 day

---

## Apex controller

I also created:

- `OpenRequestsController`

This controller exposes an `@AuraEnabled(cacheable=true)` method that returns open tickets so they can be consumed by the frontend.

---

## Lightning Web Component

For the UI, I built:

- `openRequestsList`

This LWC uses `@wire` with the Apex controller and shows open tickets on a Lightning Home page.

---

## Testing

The project includes Apex tests for the trigger/handler logic.

Tested scenarios:

- default values on insert
- keyword detection for high priority
- updating priority to high
- bulk insert
- bulk update

I also did manual validation in the UI to confirm that the rules behave correctly in real records.

---

## Project goal

<div align="center">

| Goal Area | |
|---|---|
| Data model design | ✓ |
| Declarative configuration | ✓ |
| Apex trigger logic | ✓ |
| Handler pattern | ✓ |
| Controller for LWC | ✓ |
| Simple frontend with LWC | ✓ |
| Automated testing | ✓ |
| Manual validation | ✓ |

</div>

---

## Tech used

<div align="center">

| Tool | Role |
|---|---|
| Salesforce Developer Edition | Platform |
| Salesforce CLI | Development workflow |
| VS Code | Code editor |
| Apex | Backend logic |
| Lightning Web Components | Frontend |
| Git / GitHub | Version control |

</div>

---

## Author

**Manuel Fernández**  
Built as a hands-on Salesforce Developer practice project.
