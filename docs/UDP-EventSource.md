
EventSources/@UDP.ps1
---------------------
### Synopsis
Signals on UDP

---
### Description

Runs PowerShell in the background.  
Events are fired on the completion or failure of the PowerShell command.

---
### Parameters
#### **IPAddress**

The IP Address where UDP packets can originate.  By default, [IPAddress]::Any.



|Type             |Requried|Postion|PipelineInput        |
|-----------------|--------|-------|---------------------|
|```[IPAddress]```|false   |1      |true (ByPropertyName)|
---
#### **Port**

The Port used to listen for packets.



|Type         |Requried|Postion|PipelineInput        |
|-------------|--------|-------|---------------------|
|```[Int32]```|true    |2      |true (ByPropertyName)|
---
#### **Encoding**

The encoding.  If provided, packet content will be decoded.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[Encoding]```|false   |3      |true (ByPropertyName)|
---
### Syntax
```PowerShell
EventSources/@UDP.ps1 [[-IPAddress] <IPAddress>] [-Port] <Int32> [[-Encoding] <Encoding>] [<CommonParameters>]
```
---


