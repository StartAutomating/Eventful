@{
    RootModule = 'Eventful.psm1'
    Description = 'Easy Eventful Asynchronous Scripting with PowerShell'
    ModuleVersion = '0.1.7'
    GUID = 'f4d780da-be78-49c6-921a-436e053cb97c'
    Author = 'James Brundage'
    Copyright = '2021 Start-Automating'
    FormatsToProcess = 'Eventful.format.ps1xml'
    TypesToProcess = 'Eventful.types.ps1xml'
    AliasesToExport = '*'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/Eventful'
            LicenseURI = 'https://github.com/StartAutomating/Eventful/blob/main/LICENSE'

            Tags = 'Eventful', 'Events'

            ReleaseNotes = @'
## 0.1.7
* Adding On@CommandNotFound event source (Fixes #11)
* Watch-Event now allows eventsources -recursively (Fixes #15)

---

## 0.1.6
* Adding LocationChanged event source (Fixes #12)

---

## 0.1.5
* Adding On@Event (#2)
* Send-Event support for piping existing events (#4)
* Adding /docs (#5)

---

## 0.1.4

* Module Rebranded to Eventful.
* Get-EventHandler added

---

## 0.1.3
New Event Source:
* VariableSet

Receive-Event now returns event most-recent to least-recent.
Receive-Event now has -First and -Skip.

Bugfix:  On@Repeat now actually starts it's timer.

---

## 0.1.2
New Event Source:
* UDP

PowerShellAsync Event Source now allows for a -Parameter dictionaries.

---

## 0.1.1
New Event Sources:
* HTTPResponse
* PowerShellAsync

---

New Event Source Capabilities:

Event Sources can now return an InitializeEvent property or provide a ComponentModel.InitializationEvent attribute.
This will be called directly after the subscription is created, so as to avoid signalling too soon.

## 0.1
Initial Module Release.

Fun simple event syntax (e.g. on mysignal {"do this"} or on delay "00:00:01" {"do that"})
Better pipelining support for Sending events.

---
'@
        }


        Eventful = @{
            'Time' = '@Time.ps1'
            'Delay' = '@Delay.ps1'
            'Process' = 'EventSources/@Process.ps1'
            'ModuleChanged' = 'EventSources/@ModuleChanged.ps1'
            'Job' = 'EventSources/@Job.ps1'
            'PowerShellAsync' = 'EventSources/@PowerShellAsync.ps1'
            'HttpResponse' = 'EventSources/@HttpResponse.ps1'
            'VariableSet' = 'EventSources/@VariableSet.ps1'
            'UDP' = 'EventSources/@UDP.ps1'
            'Event' = 'EventSources/@Event.ps1'
            'LocationChanged' = 'EventSources/@LocationChanged.ps1'
        }
    }
}
