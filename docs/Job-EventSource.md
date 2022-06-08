
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

|Type         |Requried|Postion|PipelineInput        |
|-------------|--------|-------|---------------------|
|```[Int32]```|true    |1      |true (ByPropertyName)|
---
### Syntax
```PowerShell
EventSources/@Job.ps1 [-JobID] <Int32> [<CommonParameters>]
```
---


