
EventSources/@Job.ps1
---------------------
### Synopsis
Watches a PowerShell Job's State.

---
### Description

Watches a PowerShell Job's StateChange event.

This will send an event when a job finishes.

---
### Parameters
#### **JobID**

> **Type**: ```[Int32]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
### Syntax
```PowerShell
EventSources/@Job.ps1 [-JobID] <Int32> [<CommonParameters>]
```
---



