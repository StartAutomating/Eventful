Watch-Event
-----------




### Synopsis
Watches Events



---


### Description

Watches Events by SourceIdentifier, or using an EventSource script.



---


### Related Links
* [Get-EventSource](Get-EventSource.md)



* [Register-ObjectEvent](https://docs.microsoft.com/powershell/module/Microsoft.PowerShell.Utility/Register-ObjectEvent)



* [Register-EngineEvent](https://docs.microsoft.com/powershell/module/Microsoft.PowerShell.Utility/Register-EngineEvent)



* [Get-EventSubscriber](https://docs.microsoft.com/powershell/module/Microsoft.PowerShell.Utility/Get-EventSubscriber)



* [Unregister-Event](https://docs.microsoft.com/powershell/module/Microsoft.PowerShell.Utility/Unregister-Event)





---


### Examples
#### EXAMPLE 1
```PowerShell
Watch-Event -SourceIdentifier MySignal -Then {"fire!" | Out-Host }
```

#### EXAMPLE 2
```PowerShell
On MySignal { "fire!" | Out-host }
```
New-Event MySignal


---


### Outputs
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)


* [Management.Automation.PSObject](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSObject)






---


### Syntax
```PowerShell
Watch-Event [<CommonParameters>]
```
