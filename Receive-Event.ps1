function Receive-Event
{
    <#
    .Synopsis
        Receives Events
    .Description
        Receives Events and output from Event Subscriptions.
    .Link
        Send-Event
    .Link
        Watch-Event
    .Example
        Get-EventSource -Subscriber | Receive-Event
    .Example
        Receive-Event -SourceIdentifier * -First 1 # Receives the most recent event with any source identifier.
    #>
    [CmdletBinding(DefaultParameterSetName='Instance')]
    [OutputType([PSObject], [Management.Automation.PSEventArgs])]
    param(
    # The event subscription ID.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='SubscriptionID')]
    [int[]]
    $SubscriptionID,

    # The event ID.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='EventIdentifier')]
    [int[]]
    $EventIdentifier,

    # The event source identifier.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='SourceIdentifier')]
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='SubscriptionID')]
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='EventIdentifier')]
    [string[]]
    $SourceIdentifier,

    # If provided, will return the first N events
    [int]
    $First,

    # If provided, will skip the first N events.
    [int]
    $Skip,

    # The input object.
    # If the Input Object was a job, it will receive the results of the job.
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject,

    # If set, will remove events from the system after they have been returned,
    # and will not keep results from Jobs or Event Handlers.
    [switch]
    $Clear
    )



    begin {
        #region Prepare Accumulation
        # We will accumulate the events we output in case we need to -Clear them.
        $accumulated = [Collections.Arraylist]::new()
        filter accumulate {
            if (-not $skip -or ($accumulated.Count -ge $skip)) {
                $_
            }

            if (-not $First -or ($accumulated.Count -lt ($First + $skip))) {
                $null = $accumulated.Add($_)
            }
        }
        #endregion Prepare Accumulation
    }
    process {
        #region Passthru Events
        if ($PSCmdlet.ParameterSetName -eq 'EventIdentifier' -and 
            $_ -is [Management.Automation.PSEventArgs]) {
            $_ | accumulate # pass events thru and accumulate them for later.
            return
        }
        #endregion PassThru Events
        #region Receiving Events by SourceIdentifier
        if ($PSCmdlet.ParameterSetName -in 'SourceIdentifier', 'EventIdentifier') {
            :nextEvent for ($ec = $PSCmdlet.Events.ReceivedEvents.Count -1 ; $ec -ge 0; $ec--) {
                $evt = $PSCmdlet.Events.ReceivedEvents[$ec]
                if ($SourceIdentifier) {
                    foreach ($sid in $sourceIdentifier) {
                        if ($evt.SourceIdentifier -eq $sid -or $evt.SourceIdentifier -like $sid) {
                            $evt | accumulate                        
                        }
                        if ($First -and $accumulated.Count -ge ($First + $Skip)) {
                            break nextEvent
                        }
                    }
                }
                if ($EventIdentifier) {
                    foreach ($eid in $EventIdentifier) {
                        if ($evt.EventIdentifier -eq $eid) {
                            $evt | accumulate
                        }
                        if ($First -and $accumulated.Count -ge ($First + $Skip)) {
                            break nextEvent
                        }
                    }
                }
            }
            return
        }
        #endregion Receiving Events by SourceIdentifier
        #region Receiving Events by SubscriptionID
        if ($PSCmdlet.ParameterSetName -eq 'SubscriptionID') {
            $SubscriptionID |
                # Find all event subscriptions with that subscription ID
                Get-EventSubscriber -SubscriptionId { $_ } -ErrorAction SilentlyContinue |
                # that have an .Action.
                Where-Object { $_.Action } |
                # Then pipe that action to
                Select-Object -ExpandProperty Action |
                # Receive-Job (-Keep results by default unless -Clear is passed).
                Receive-Job -Keep:(-not $Clear)
            return
        }
        #endregion Receiving Events by SubscriptionID

        #region Receiving Events by InputObject
        if ($InputObject) { # If the input object was a job,
            if ($InputObject -is [Management.Automation.Job]) {
                # Receive-Job (-Keep results by default unless -Clear is passed).
                $InputObject | Receive-Job -Keep:(-not $Clear)
            } else {
                # Otherwise, find event subscribers
                Get-EventSubscriber |
                    # whose source is this input object
                    Where-Object Source -EQ $InputObject |
                    # that have an .Action.
                    Where-Object { $_.Action } |
                    # Then pipe that action to
                    Select-Object -ExpandProperty Action |
                    # Receive-Job (-Keep results by default unless -Clear is passed).
                    Receive-Job -Keep:(-not $Clear)
            }
        }
        #endregion Receiving Events by InputObject
    }

    end {
        #region -Clear accumulation (if requested)
        if ($accumulated.Count -and $Clear) { # If we accumulated events, and said to -Clear them,
            $accumulated | Remove-Event       # remove those events.
        }
        #region -Clear accumulation (if requested)
    }
}
