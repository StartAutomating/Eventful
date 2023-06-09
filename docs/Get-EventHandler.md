Get-EventHandler
----------------




### Synopsis
Gets Event Handlers



---


### Description

Gets files that act as Event Handlers.

These files can be named a few ways:

* On_[EventName].ps1  / [EventName].handler.ps1 (These handle a single event)
* [Name].handlers.ps1 / [Name].events.ps1       (These handle multiple events)



---


### Parameters
#### **HandlerPath**

The path to the handler file(s)






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |1       |true (ByPropertyName)|





---


### Syntax
```PowerShell
Get-EventHandler [[-HandlerPath] <String[]>] [<CommonParameters>]
```
