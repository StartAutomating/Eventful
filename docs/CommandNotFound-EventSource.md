EventSources/@CommandNotFound.ps1
---------------------------------




### Synopsis
Sends events when a command is not found.



---


### Description

Sends events when a command is not found.

Handling this event can resolve any unknown command.



---


### Examples
#### EXAMPLE 1
```PowerShell
On@CommandNotFound
```

#### EXAMPLE 2
```PowerShell
On@CommandNotFound  -Then  { $event | Out-Host }
```



---


### Syntax
```PowerShell
EventSources/@CommandNotFound.ps1 [<CommonParameters>]
```
