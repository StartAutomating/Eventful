Import-Event
------------




### Synopsis
Imports Events



---


### Description

Imports Events from a file on disk.



---


### Related Links
* [Export-Event](Export-Event.md)





---


### Examples
#### EXAMPLE 1
```PowerShell
Import-Event .\Events.clixml
```



---


### Parameters
#### **InputPath**

The input path.  This file should be created using Export-Event






|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|true    |1       |true (ByPropertyName)|Fullname|



#### **Resend**

If set, will resend events.
Only events sent with New-Event or Send-Event will be resent.






|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Replay |





---


### Syntax
```PowerShell
Import-Event [-InputPath] <String> [-Resend] [<CommonParameters>]
```
