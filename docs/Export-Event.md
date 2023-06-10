Export-Event
------------




### Synopsis
Exports events



---


### Description

Exports events to a file for long term storage.



---


### Related Links
* [Import-Event](Import-Event.md)



* [Receive-Event](Receive-Event.md)





---


### Examples
#### EXAMPLE 1
```PowerShell
Export-Event -OutputPath .\Events.clixml -SourceIdentifier *
```



---


### Parameters
#### **OutputPath**

The Output Path for the exported events.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |1       |false        |



#### **SourceIdentifier**

The source identifier.  If not provided, all unhandled events will be exported.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|



#### **First**

If provided, will return the first N events






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |3       |false        |



#### **Skip**

If provided, will skip the first N events.






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |4       |false        |



#### **Force**

If set, will overwrite existing files.
If not set, existing files will be read in, and events will be appeneded.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |





---


### Syntax
```PowerShell
Export-Event [-OutputPath] <String> [[-SourceIdentifier] <String[]>] [[-First] <Int32>] [[-Skip] <Int32>] [-Force] [<CommonParameters>]
```
