EventSources/@Time.ps1
----------------------




### Synopsis
Sends an event at a specific time.



---


### Description

Sends an event at a specific date and time.



---


### Examples
#### EXAMPLE 1
```PowerShell
On Time "5:00 PM" { "EOD!" | Out-Host }
```



---


### Parameters
#### **DateTime**

The specific date and time the event will be triggered.






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[DateTime]`|true    |1       |false        |





---


### Syntax
```PowerShell
EventSources/@Time.ps1 [-DateTime] <DateTime> [<CommonParameters>]
```
