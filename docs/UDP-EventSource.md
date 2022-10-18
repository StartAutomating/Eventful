
EventSources/@UDP.ps1
---------------------
### Synopsis
Signals on UDP

---
### Description

Runs PowerShell in the background.  
Events are fired on the completion or failure of the PowerShell command.

---
### Parameters
#### **IPAddress**

The IP Address where UDP packets can originate.  By default, [IPAddress]::Any.



> **Type**: ```[IPAddress]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Port**

The Port used to listen for packets.



> **Type**: ```[Int32]```

> **Required**: true

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Encoding**

The encoding.  If provided, packet content will be decoded.



> **Type**: ```[Encoding]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
### Syntax
```PowerShell
EventSources/@UDP.ps1 [[-IPAddress] <IPAddress>] [-Port] <Int32> [[-Encoding] <Encoding>] [<CommonParameters>]
```
---



