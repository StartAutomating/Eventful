
@FileChange.ps1
---------------
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



> **Type**: ```[String]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **FileFilter**

A wildcard filter describing the names of files to watch



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
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



> **Type**: ```[NotifyFilters[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Recurse**

If set, will include subdirectories in the watcher.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **EventName**

The names of the file change events to watch.
By default, watches for Changed, Created, Deleted, or Renamed



Valid Values:

* Changed
* Created
* Deleted
* Renamed



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:false



---
### Syntax
```PowerShell
@FileChange.ps1 [[-FilePath] <String>] [[-FileFilter] <String>] [[-NotifyFilter] {FileName | DirectoryName | Attributes | Size | LastWrite | LastAccess | CreationTime | Security}] [-Recurse] [[-EventName] <String[]>] [<CommonParameters>]
```
---



