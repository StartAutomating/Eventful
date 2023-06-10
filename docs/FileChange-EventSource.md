EventSources/@FileChange.ps1
----------------------------




### Synopsis
Watches for File Changes.



---


### Description

Uses the [IO.FileSystemWatcher] to watch for changes to files.

Because some applications and frameworks write to files differently,
you may see more than one event for a given change.



---


### Parameters
#### **FilePath**

The path to the file or directory






|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|false   |1       |true (ByPropertyName)|Fullname|



#### **FileFilter**

A wildcard filter describing the names of files to watch






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|



#### **NotifyFilter**

A notify filter describing the file changes that should raise events.



Valid Values:

* FileName
* DirectoryName
* Attributes
* Size
* LastWrite
* LastAccess
* CreationTime
* Security






|Type               |Required|Position|PipelineInput        |
|-------------------|--------|--------|---------------------|
|`[NotifyFilters[]]`|false   |3       |true (ByPropertyName)|



#### **Recurse**

If set, will include subdirectories in the watcher.






|Type      |Required|Position|PipelineInput|Aliases                                      |
|----------|--------|--------|-------------|---------------------------------------------|
|`[Switch]`|false   |named   |false        |InludeSubsdirectory<br/>InludeSubsdirectories|



#### **EventName**

The names of the file change events to watch.
By default, watches for Changed, Created, Deleted, or Renamed



Valid Values:

* Changed
* Created
* Deleted
* Renamed






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |4       |false        |





---


### Syntax
```PowerShell
EventSources/@FileChange.ps1 [[-FilePath] <String>] [[-FileFilter] <String>] [[-NotifyFilter] {FileName | DirectoryName | Attributes | Size | LastWrite | LastAccess | CreationTime | Security}] [-Recurse] [[-EventName] <String[]>] [<CommonParameters>]
```
