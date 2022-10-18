
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



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **MessageData**

The message data



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByValue)



---
#### **Sender**

The sender.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **EventArgs**

The event arguments.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **PassThru**

If set, will output the created event.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
### Outputs
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)


* [Management.Automation.PSEventArgs](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSEventArgs)




---
### Syntax
```PowerShell
Send-Event [-SourceIdentifier] <String[]> [[-MessageData] <PSObject>] [[-Sender] <PSObject>] [[-EventArgs] <PSObject>] [-PassThru] [<CommonParameters>]
```
---


