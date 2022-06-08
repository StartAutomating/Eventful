
EventSources/@HttpResponse.ps1
------------------------------
### Synopsis
Sends events on HTTP Responses.

---
### Description

Sends HTTP requests and signals on Responses


Event MessageData will contain the response, with two additional properties:
* .ResponseBytes
* .ResponseContent

---
### Parameters
#### **Uri**

The Uniform Resource Identifier.



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|true    |1      |true (ByPropertyName)|
---
#### **Method**

The HTTP Method



Valid Values:

* Get
* Head
* Post
* Put
* Delete
* Trace
* Options
* Merge
* Patch
|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |2      |true (ByPropertyName)|
---
#### **Header**

A collection of headers to send with the request.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |3      |true (ByPropertyName)|
---
#### **Body**

The request body.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[PSObject]```|false   |4      |true (ByPropertyName)|
---
#### **PollingInterval**

The polling interval.  
This is the minimum amount of time until you will be notified of the success or failure of a http request



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[TimeSpan]```|false   |4      |true (ByPropertyName)|
---
#### **TransferEncoding**

|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[Encoding]```|false   |named  |false        |
---
### Syntax
```PowerShell
EventSources/@HttpResponse.ps1 [-Uri] <Uri> [[-Method] <String>] [[-Header] <IDictionary>] [[-Body] <PSObject>] [[-PollingInterval] <TimeSpan>] [-TransferEncoding <Encoding>] [<CommonParameters>]
```
---


