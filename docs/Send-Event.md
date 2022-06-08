
Send-Event
----------
### Synopsis
Sends Events

---
### Description

Sends Events to PowerShell.

Send-Event is a wrapper for the built-in command New-Event with a few key differences:
1. It allows MessageData to be piped in
2. You can send multiple sourceidentifiers
3. It does not output by default (you must pass -PassThru)

---
### Related Links
* [New-Event](https://docs.microsoft.com/powershell/module/Microsoft.PowerShell.Utility/New-Event)
* [Watch-Event](Watch-Event.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
1..4 | Send-Event "Hit It"
```

---
### Parameters
#### **SourceIdentifier**

The SourceIdentifier



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|true    |1      |false        |
---
#### **MessageData**

The message data



|Type            |Requried|Postion|PipelineInput |
|----------------|--------|-------|--------------|
|```[PSObject]```|false   |2      |true (ByValue)|
---
#### **Sender**

The sender.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[PSObject]```|false   |3      |true (ByPropertyName)|
---
#### **EventArgs**

The event arguments.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[PSObject]```|false   |4      |true (ByPropertyName)|
---
#### **PassThru**

If set, will output the created event.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
### Outputs
System.Nullable


System.Management.Automation.PSEventArgs


---
### Syntax
```PowerShell
Send-Event [-SourceIdentifier] <String[]> [[-MessageData] <PSObject>] [[-Sender] <PSObject>] [[-EventArgs] <PSObject>] [-PassThru] [<CommonParameters>]
```
---


