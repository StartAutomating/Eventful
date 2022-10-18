
Clear-EventSource
-----------------
### Synopsis
Clears event source subscriptions

---
### Description

Clears any active subscriptions for any event source.

---
### Related Links
* [Get-EventSource](Get-EventSource.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Clear-EventSource
```

---
### Parameters
#### **Name**

The name of the event source.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.
    
If you pass ```-Confirm:$false``` you will not be prompted.
    
    
If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---
### Outputs
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)




---
### Syntax
```PowerShell
Clear-EventSource [[-Name] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


