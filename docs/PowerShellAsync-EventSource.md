EventSources/@PowerShellAsync.ps1
---------------------------------




### Synopsis
Runs PowerShell asynchronously



---


### Description

Runs PowerShell in the background.  
Events are fired on the completion or failure of the PowerShell command.



---


### Parameters
#### **ScriptBlock**

The scripts you would like to run.  Each script block will be counted as a distinct statement.






|Type             |Required|Position|PipelineInput|
|-----------------|--------|--------|-------------|
|`[ScriptBlock[]]`|true    |1       |false        |



#### **Parameter**

The named parameters passed to each script.






|Type             |Required|Position|PipelineInput|Aliases   |
|-----------------|--------|--------|-------------|----------|
|`[IDictionary[]]`|false   |named   |false        |Parameters|



#### **Runspace**

If provided, will run in a specified runspace.  The Runspace must already be open.






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[Runspace]`|false   |named   |false        |



#### **RunspacePool**

If provided, will run in a runspace pool.  The RunspacePool must already be open.






|Type            |Required|Position|PipelineInput|
|----------------|--------|--------|-------------|
|`[RunspacePool]`|false   |named   |false        |





---


### Syntax
```PowerShell
EventSources/@PowerShellAsync.ps1 [-ScriptBlock] <ScriptBlock[]> [-Parameter <IDictionary[]>] [-Runspace <Runspace>] [-RunspacePool <RunspacePool>] [<CommonParameters>]
```
