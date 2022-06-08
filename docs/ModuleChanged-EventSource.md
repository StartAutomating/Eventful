
EventSources/@ModuleChanged.ps1
-------------------------------
### Synopsis
Watches for Module loads and unloads.

---
### Description

Polls the current set of globally imported PowerShell modules.

When this changes, one of two events will be generated:

PowerShell.Module.Loaded will be sent when one or more modules is loaded
PowerShell.Module.Unloaded will be sent when one or more modules is unloaded

Only one event if each will be sent per polling interval.

---
### Parameters
#### **PollingInterval**

The frequency to check for a module load.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[TimeSpan]```|false   |1      |false        |
---
### Syntax
```PowerShell
EventSources/@ModuleChanged.ps1 [[-PollingInterval] <TimeSpan>] [<CommonParameters>]
```
---


