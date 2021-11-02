function Send-Event
{
    <#
    .Synopsis
        Sends Events
    .Description
        Sends Events to PowerShell.

        Send-Event is a wrapper for the built-in command New-Event with a few key differences:
        1. It allows MessageData to be piped in
        2. You can send multiple sourceidentifiers
        3. It does not output by default (you must pass -PassThru)
    .Example
        1..4 | Send-Event "Hit It"
    .Link
        New-Event
    .Link
        Watch-Event
    #>
    [OutputType([Nullable],[Management.Automation.PSEventArgs])]
    param(
    # The SourceIdentifier
    [Parameter(Mandatory,Position=0)]
    [string[]]
    $SourceIdentifier,

    # The message data
    [Parameter(ValueFromPipeline,Position=1)]
    [PSObject]
    $MessageData,

    # The sender.
    [Parameter(ValueFromPipelineByPropertyName,Position=2)]
    [PSObject]
    $Sender,

    # The event arguments.
    [Parameter(ValueFromPipelineByPropertyName,Position=3)]
    [PSObject]
    $EventArgs,

    # If set, will output the created event.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $PassThru
    )


    begin {
        # Be we start, get a reference to New-Event
        $newEvent = $ExecutionContext.SessionState.InvokeCommand.GetCommand('New-Event','Cmdlet')
    }
    process {
        #region Map New-Event Parameters
        $newEventParams = @{} + $PSBoundParameters # Copy bound parameters.
        foreach ($k in @($newEventParams.Keys)) {
            if (-not $newEvent.Parameters[$k]) {   # If a parameter isn't for New-Event
                $newEventParams.Remove($k)         # remove it from the copy.
            }
        }
        # If we're piping in MessageData, but the message only contains "Sender" and "Event"
        if ($newEventParams.Sender -and $newEventParams.EventArgs -and
            $newEventParams.MessageData.psobject.properties.Count -eq 2 -and
            $newEventParams.MessageData.Sender -and $newEventParams.MessageData.EventArgs) {
            $newEventParams.Remove('MessageData') # remove the MessageData.
        }
        # Always remove the sourceID parameter (New-Event allows one, Send-Event allows many)
        $newEventParams.Remove('SourceIdentifier')
        #endregion Map New-Event Parameters

        #region Send Each Event
        foreach ($sourceID in $SourceIdentifier) { # Walk over each source identifier 
            # and call New-Event.
            $evt = New-Event @newEventParams -SourceIdentifier $sourceID
            if ($PassThru) { # If we want to -PassThru events
                $evt         # output the created event.
            }
        }
        #endregion Send Each Event
    }
}
