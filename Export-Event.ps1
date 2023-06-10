function Export-Event
{
    <#
    .Synopsis
        Exports events
    .Description
        Exports events to a file for long term storage.
    .Example
        Export-Event -OutputPath .\Events.clixml -SourceIdentifier *
    .LINK
        Import-Event
    .Link
        Receive-Event
    #>
    param(
        # The Output Path for the exported events.        
        [ValidateScript({
            $extension = @($_ -split '\.')[-1]
            $exporter = $ExecutionContext.SessionState.InvokeCommand.GetCommand(
                "Export-$Extension",
                "Function,Alias,Cmdlet"
            )
            if (-not $exporter) {
                throw "Export-$Extension does not exist.  Cannot export .$Extension"
            }
            return $true
        })]
        [Parameter(Mandatory)]
        [string]
        $OutputPath,

        # The source identifier.  If not provided, all unhandled events will be exported.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]
        $SourceIdentifier,
    
        # If provided, will return the first N events
        [int]
        $First,
    
        # If provided, will skip the first N events.
        [int]
        $Skip,

        # If set, will overwrite existing files.
        # If not set, existing files will be read in, and events will be appeneded.
        [switch]
        $Force
    )
    
    begin {
        $accumulatedEvents = [Collections.Queue]::new()
    }
    process {
        if ($_ -is [Management.Automation.PSEvent]) {
            $accumulatedEvents.Enqueue($_)
            return
        }

        $receiveSplat = @{} + $PSBoundParameters
        $receiveSplat.Remove('OutputPath')
        $receiveSplat.Remove('Force')
        if (-not $receiveSplat.SourceIdentifier) {
            $receiveSplat.SourceIdentifier = '*'
        }        
        foreach ($eventInfo in Receive-Event @receiveSplat) {
            $accumulatedEvents.Enqueue($eventInfo)
        }
        
        if (-not $accumulatedEvents.Count) {
            Write-Verbose "No Events Received.  Nothing to export."
            return
        }
    }


    end {
        $outputPathExists = Test-Path $OutputPath

        # try to find an exporter
        $exporter = $ExecutionContext.SessionState.InvokeCommand.GetCommand(
            # (by looking for any Export-Command that shares a name with the extension)
            "Export-$(@($OutputPath -split '\.')[-1])",
            'Function,Alias,Cmdlet'
        )

        if (-not $exporter) {
            Write-Error "No Exporter found for $OutputPath"
            return
        }

        if ($outputPathExists -and -not $force) {
            $importer = $ExecutionContext.SessionState.InvokeCommand.GetCommand(
                # (by looking for any Import-Command that shares a name with the extension)
                "Import-$(@($OutputPath -split '\.')[-1])",
                'Function,Alias,Cmdlet'
            )
            $receivedEvents = @() + @(& $importer $OutputPath) + $accumulatedEvents.ToArray()
        } else {
            $receivedEvents = $accumulatedEvents.ToArray()
        }

        $receivedEvents | & $exporter $OutputPath

        if ($?) {
            Get-Item $OutputPath
        }
    }
}
