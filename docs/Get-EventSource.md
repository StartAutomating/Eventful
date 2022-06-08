
Get-EventSource
---------------
### Synopsis
Gets Event Sources

---
### Description

Gets Event Sources.

Event sources are commands or script blocks that can generate events.

Event sources can be implemented in:
* A .PS1 file starting with @
* An in-memory scriptblock variable starting with @
* A module command referenced within a PrivateData.OnQ section of the module manifest.

---
### Related Links
* [Watch-Event](Watch-Event.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-EventSource
```

#### EXAMPLE 2
```PowerShell
Get-EventSource -Subscription
```

---
### Parameters
#### **Name**

The name of the event source.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |1      |true (ByPropertyName)|
---
#### **Subscription**

If set, will get subscriptions related to event sources.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **SourceObject**

If set, will get source objects from the subscriptions related to event sources.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Help**

If set, will get full help for each event source.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
### Outputs
Eventful.EventSource


System.Management.Automation.CommandInfo


System.Management.Automation.PSEventSubscriber


psobject


---
### Syntax
```PowerShell
Get-EventSource [[-Name] <String[]>] [-Subscription] [-SourceObject] [-Help] [<CommonParameters>]
```
---


