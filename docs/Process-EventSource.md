
EventSources/@Process.ps1
-------------------------
### Synopsis
Watches a process.

---
### Description

Watches a process.

If -Exit is passed, watches for process exit.

If -Output is passed, watches for process output

If -Error is passed, watched for process error

---
### Parameters
#### **ProcessID**

The process identifier



> **Type**: ```[Int32]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Exit**

If set, will watch for process exit.  This is the default unless -StandardError or -StandardOutput are passed.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **StandardOutput**

If set, will watch for new standard output.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **StandardError**

If set, will watch for new standard erorr.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
EventSources/@Process.ps1 [-ProcessID] <Int32> [-Exit] [-StandardOutput] [-StandardError] [<CommonParameters>]
```
---



