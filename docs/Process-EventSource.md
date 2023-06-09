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






|Type     |Required|Position|PipelineInput        |Aliases|
|---------|--------|--------|---------------------|-------|
|`[Int32]`|true    |1       |true (ByPropertyName)|ID     |



#### **Exit**

If set, will watch for process exit.  This is the default unless -StandardError or -StandardOutput are passed.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **StandardOutput**

If set, will watch for new standard output.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **StandardError**

If set, will watch for new standard erorr.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |





---


### Syntax
```PowerShell
EventSources/@Process.ps1 [-ProcessID] <Int32> [-Exit] [-StandardOutput] [-StandardError] [<CommonParameters>]
```
