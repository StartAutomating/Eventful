
EventSources/@VariableSet.ps1
-----------------------------
### Synopsis
Watches for variable sets.

---
### Description

Watches for assignments to a variable.  

Events are sent directly after the variable is set.

The -Sender is the callstack, The -MessageData is the value of the variable.

---
### Parameters
#### **VariableName**

The name of the variable



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
### Syntax
```PowerShell
EventSources/@VariableSet.ps1 [-VariableName] <String> [<CommonParameters>]
```
---




