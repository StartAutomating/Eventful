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




|Type     |Required|Position|PipelineInput        |Aliases|
|---------|--------|--------|---------------------|-------|
|`[Int32]`|true    |1       |true (ByPropertyName)|ID     |





---


### Syntax
```PowerShell
EventSources/@Job.ps1 [-JobID] <Int32> [<CommonParameters>]
```
