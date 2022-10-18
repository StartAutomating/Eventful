
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



> **Type**: ```[Uri]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



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



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Header**

A collection of headers to send with the request.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Body**

The request body.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **PollingInterval**

The polling interval.  
This is the minimum amount of time until you will be notified of the success or failure of a http request



> **Type**: ```[TimeSpan]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **TransferEncoding**

> **Type**: ```[Encoding]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
EventSources/@HttpResponse.ps1 [-Uri] <Uri> [[-Method] <String>] [[-Header] <IDictionary>] [[-Body] <PSObject>] [[-PollingInterval] <TimeSpan>] [-TransferEncoding <Encoding>] [<CommonParameters>]
```
---



