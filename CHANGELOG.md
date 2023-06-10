## Eventful 0.1.8:

* Eventful Supports Sponsorship (#25)
* New Commands!
  * Import-Event (#28)
  * Export-Event (#27)    
* Send-Event can now send -EventArguments and -MessageData (#26)
* Watch-Event now supports -MaxTriggerCount and -MessageData (#29)
* Simplifying event source registration (any `@*` script or function) (#30)
* Making one-time event sources more efficient (#31)

---

## Eventful 0.1.7:
* Adding On@CommandNotFound event source (Fixes #11)
* Watch-Event now allows eventsources -recursively (Fixes #15)

---

## Eventful 0.1.6
* Adding LocationChanged event source (Fixes #12)

---

## Eventful 0.1.5
* Adding On@Event (#2)
* Send-Event support for piping existing events (#4)
* Adding /docs (#5)

---

## Eventful 0.1.4

* Module Rebranded to Eventful.
* Get-EventHandler added

---

## Eventful 0.1.3
New Event Source:
* VariableSet

Receive-Event now returns event most-recent to least-recent.
Receive-Event now has -First and -Skip.

Bugfix:  On@Repeat now actually starts it's timer.

---

## Eventful 0.1.2
New Event Source:
* UDP

PowerShellAsync Event Source now allows for a -Parameter dictionaries.

---

## Eventful 0.1.1
New Event Sources:
* HTTPResponse
* PowerShellAsync

---

New Event Source Capabilities:

Event Sources can now return an InitializeEvent property or provide a ComponentModel.InitializationEvent attribute.
This will be called directly after the subscription is created, so as to avoid signalling too soon.

---

## Eventful 0.1

Initial Module Release.

Fun simple event syntax (e.g. on mysignal {"do this"} or on delay "00:00:01" {"do that"})
Better pipelining support for Sending events.

---