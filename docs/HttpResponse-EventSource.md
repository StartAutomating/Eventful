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






|Type   |Required|Position|PipelineInput        |Aliases|
|-------|--------|--------|---------------------|-------|
|`[Uri]`|true    |1       |true (ByPropertyName)|Url    |



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






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|



#### **Header**

A collection of headers to send with the request.






|Type           |Required|Position|PipelineInput        |Aliases|
|---------------|--------|--------|---------------------|-------|
|`[IDictionary]`|false   |3       |true (ByPropertyName)|Headers|



#### **Body**

The request body.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |4       |true (ByPropertyName)|



#### **PollingInterval**

The polling interval.  
This is the minimum amount of time until you will be notified of the success or failure of a http request






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[TimeSpan]`|false   |4       |true (ByPropertyName)|



#### **TransferEncoding**




|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[Encoding]`|false   |named   |false        |





---


### Syntax
```PowerShell
EventSources/@HttpResponse.ps1 [-Uri] <Uri> [[-Method] <String>] [[-Header] <IDictionary>] [[-Body] <PSObject>] [[-PollingInterval] <TimeSpan>] [-TransferEncoding <Encoding>] [<CommonParameters>]
```
