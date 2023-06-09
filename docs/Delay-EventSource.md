@Delay.ps1
----------




### Synopsis
Send an event after a delay.



---


### Description

Send an event after waiting an arbitrary [Timespan]



---


### Examples
#### EXAMPLE 1
```PowerShell
On Delay "00:00:01" -Then { "In a second!" | Out-Host }
```



---


### Parameters
#### **Wait**

The amount of time to wait






|Type        |Required|Position|PipelineInput        |Aliases     |
|------------|--------|--------|---------------------|------------|
|`[TimeSpan]`|true    |1       |true (ByPropertyName)|Delay<br/>In|





---


### Syntax
```PowerShell
@Delay.ps1 [-Wait] <TimeSpan> [<CommonParameters>]
```
