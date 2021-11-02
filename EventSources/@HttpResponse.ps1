<#
.Synopsis
    Sends events on HTTP Responses.
.Description
    Sends HTTP requests and signals on Responses


    Event MessageData will contain the response, with two additional properties:
    * .ResponseBytes
    * .ResponseContent
#>
[ComponentModel.InitializationEvent({
    # Because of the potential for a "narrow window" timing issue,
    # this event source needs to send the request the moment after the event has been subscribed to.
    $httpAsyncInfo = [PSCustomObject]@{
        InputObject  = $this
        IAsyncResult = $this.BeginGetResponse($null, $null)
        InvokeID     = $this.RequestID
    }
    if ($null -eq $Global:HttpResponsesAsync) {
        $Global:HttpResponsesAsync = [Collections.ArrayList]::new()
    }
    $null = $Global:HttpResponsesAsync.Add($httpAsyncInfo)
})]
param(
# The Uniform Resource Identifier.
[Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
[Alias('Url')]
[Uri]
$Uri,

# The HTTP Method
[Parameter(Position=1,ValueFromPipelineByPropertyName)]
[ValidateSet('Get','Head','Post','Put','Delete','Trace','Options','Merge','Patch')]
[string]
$Method = 'GET',

# A collection of headers to send with the request.
[Parameter(Position=2,ValueFromPipelineByPropertyName)]
[Alias('Headers')]
[Collections.IDictionary]
$Header,

# The request body.
[Parameter(Position=3,ValueFromPipelineByPropertyName)]
[PSObject]
$Body,

# The polling interval.  
# This is the minimum amount of time until you will be notified of the success or failure of a http request
[Parameter(Position=3,ValueFromPipelineByPropertyName)]
[Timespan]
$PollingInterval = "00:00:00.331",

[Text.Encoding]
$TransferEncoding = $([Text.Encoding]::UTF8)
)

process {
    # Clear the event subscriber if one exists.
    $eventSubscriber = Get-EventSubscriber -SourceIdentifier "@HttpResponse_Check" -ErrorAction SilentlyContinue
    if ($eventSubscriber) {$eventSubscriber | Unregister-Event}

    # Create a new subscriber for the request.
    $httpResponseCheckTimer = New-Object Timers.Timer -Property @{
        Interval  = $PollingInterval.TotalMilliseconds # Every pollinginterval,
        AutoReset = $true
    }
    $HttpResponseChecker = 
        Register-ObjectEvent -InputObject $httpResponseCheckTimer -EventName Elapsed -Action {
            $toCallEnd = # check to see if any requests have completed.
                @(foreach ($httpAsyncInfo in $Global:HttpResponsesAsync) { 
                    if ($httpAsyncInfo.IAsyncResult.IsCompleted) {
                        $httpAsyncInfo
                    }
                })

            $null = # Foreach completed request
                foreach ($httpAsyncInfo in $toCallEnd) {
                    $webResponse = 
                        try {   # try to get the response
                            $httpAsyncInfo.InputObject.EndGetResponse($httpAsyncInfo.IAsyncResult)
                        } catch {                                
                            $_ # and catch any error.
                        }

                    
                    if ($webResponse -is [Management.Automation.ErrorRecord] -or 
                        $webResponse -is [Exception]) # If we got an error
                    {
                        # Signal the error
                        New-Event -SourceIdentifier "HttpRequest.Failed.$($httpAsyncInfo.InvokeID)" -MessageData $webResponse
                        $Global:HttpResponsesAsync.Remove($httpAsyncInfo)
                        continue
                    }


                    # Otherwise, get the response stream 
                    $ms = [IO.MemoryStream]::new()
                    $null = $webResponse.GetResponseStream().CopyTo($ms)
                    $responseBytes = $ms.ToArray() # as a [byte[]].
                    $ms.Close()
                    $ms.Dispose()
                    

                    $encoding = # See if the response had an encoding
                        if ($webResponse.ContentEncoding) { $webResponse.ContentEncoding }
                        elseif ($webResponse.CharacterSet) {
                            # or a character set.
                            [Text.Encoding]::GetEncodings() | Where-Object Name -EQ $webResponse.CharacterSet
                        }

                    $webResponseContent = 
                        if ($encoding) { # If it did, decode the response content.
                            [IO.StreamReader]::new([IO.MemoryStream]::new($responseBytes), $encoding).ReadToEnd()
                        } else {
                            $null
                        }

                    # Add the properties to the web response.
                    $webResponse | 
                        Add-Member NoteProperty ResponseBytes $webResponseContent -Force -PassThru |
                        Add-Member NoteProperty ResponseContent $webResponseContent -Force
                    $webResponse.Close()

                    # And send the response with the additional information.
                    New-Event -SourceIdentifier "HttpRequest.Completed.$($httpAsyncInfo.InvokeID)" -MessageData $webResponse
                    $Global:HttpResponsesAsync.Remove($httpAsyncInfo)
                }

            if ($Global:HttpResponsesAsync.Count -eq 0) {
                Get-EventSubscriber -SourceIdentifier "@HttpResponse_Check" | Unregister-Event
            }
        }

    $httpResponseCheckTimer.Start() # Start it's timer.


    $httpRequest = [Net.HttpWebRequest]::CreateHttp($Uri)
    $httpRequest.Method = $Method
    if ($Header -and $Header.Count) {
        foreach ($kv in $Header.GetEnumerator()) {
            $httpRequest.Headers[$kv.Key] = $kv.Value
        }
    }
    if ($Body) {
        $requestStream = $httpRequest.GetRequestStream()
        
        if (-not $requestStream) { return }
        if ($body -is [byte[]] -or $Body -as [byte[]]) {
            [IO.MemoryStream]::new([byte[]]$Body).CopyTo($requestStream)
        }
        elseif ($Body -is [string]) {
            [IO.StreamWriter]::new($requestStream, $TransferEncoding).Write($Body)
        }
        else {
            [IO.StreamWriter]::new($requestStream, $TransferEncoding).Write((ConvertTo-Json -InputObject $body -Depth 100))
        }
    }
    $requestId   = [Guid]::NewGuid().ToString() 
    $httpRequest |
        Add-Member NoteProperty SourceIdentifier "HttpRequest.Completed.$requestId","HttpRequest.Failed.$requestId" -Force -PassThru |
        Add-Member NoteProperty RequestID $requestId -Force -PassThru
}