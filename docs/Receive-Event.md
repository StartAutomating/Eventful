
Receive-Event
-------------
### Synopsis
Receives Events

---
### Description

Receives Events and output from Event Subscriptions.

---
### Related Links
* [Send-Event](Send-Event.md)
* [Watch-Event](Watch-Event.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-EventSource -Subscriber | Receive-Event
```

#### EXAMPLE 2
```PowerShell
Receive-Event -SourceIdentifier * -First 1 # Receives the most recent event with any source identifier.
```

---
### Parameters
#### **SubscriptionID**

The event subscription ID.



|Type           |Requried|Postion|PipelineInput        |
|---------------|--------|-------|---------------------|
|```[Int32[]]```|true    |named  |true (ByPropertyName)|
---
#### **EventIdentifier**

The event ID.



|Type           |Requried|Postion|PipelineInput        |
|---------------|--------|-------|---------------------|
|```[Int32[]]```|true    |named  |true (ByPropertyName)|
---
#### **SourceIdentifier**

The event source identifier.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **First**

If provided, will return the first N events



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |named  |false        |
---
#### **Skip**

If provided, will skip the first N events.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |named  |false        |
---
#### **InputObject**

The input object.
If the Input Object was a job, it will receive the results of the job.



|Type            |Requried|Postion|PipelineInput |
|----------------|--------|-------|--------------|
|```[PSObject]```|false   |named  |true (ByValue)|
---
#### **Clear**

If set, will remove events from the system after they have been returned,
and will not keep results from Jobs or Event Handlers.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Outputs
System.Management.Automation.PSObject


System.Management.Automation.PSEventArgs


---
### Syntax
```PowerShell
Receive-Event [-First <Int32>] [-Skip <Int32>] [-InputObject <PSObject>] [-Clear] [<CommonParameters>]
```
```PowerShell
Receive-Event -SubscriptionID <Int32[]> [-SourceIdentifier <String[]>] [-First <Int32>] [-Skip <Int32>] [-InputObject <PSObject>] [-Clear] [<CommonParameters>]
```
```PowerShell
Receive-Event -EventIdentifier <Int32[]> [-SourceIdentifier <String[]>] [-First <Int32>] [-Skip <Int32>] [-InputObject <PSObject>] [-Clear] [<CommonParameters>]
```
```PowerShell
Receive-Event -SourceIdentifier <String[]> [-First <Int32>] [-Skip <Int32>] [-InputObject <PSObject>] [-Clear] [<CommonParameters>]
```
---


