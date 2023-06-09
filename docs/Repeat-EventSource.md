EventSources/@Repeat.ps1
------------------------




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






|Type        |Required|Position|PipelineInput        |Aliases|
|------------|--------|--------|---------------------|-------|
|`[TimeSpan]`|true    |1       |true (ByPropertyName)|Every  |





---


### Syntax
```PowerShell
EventSources/@Repeat.ps1 [-Interval] <TimeSpan> [<CommonParameters>]
```
