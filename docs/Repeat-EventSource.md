
@Repeat.ps1
-----------
### Synopsis
Send events on repeat.

---
### Description

Sends events on repeat, at a given [Timespan] -Interval.

---
### Examples
#### EXAMPLE 1
```PowerShell
On Interval "00:01:00" { "Every minute" | Out-Host }
```

---
### Parameters
#### **Interval**

The amount of time to wait between sending events.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[TimeSpan]```|true    |1      |true (ByPropertyName)|
---
### Syntax
```PowerShell
@Repeat.ps1 [-Interval] <TimeSpan> [<CommonParameters>]
```
---


