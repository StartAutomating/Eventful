
EventSources/@LocationChanged.ps1
---------------------------------
### Synopsis
Sends events when the directory changes.

---
### Description

Sends events when the PowerShell current directory changes.

---
### Examples
#### EXAMPLE 1
```PowerShell
On@LocationChanged
```

#### EXAMPLE 2
```PowerShell
On@LocationChanged  -Then  { $event | Out-Host }
```

---
### Syntax
```PowerShell
EventSources/@LocationChanged.ps1 [<CommonParameters>]
```
---




