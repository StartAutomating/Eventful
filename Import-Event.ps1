function Import-Event
{
    <#
    .SYNOPSIS
        Imports Events        
    .DESCRIPTION
        Imports Events from a file on disk.
    .EXAMPLE
        Import-Event .\Events.clixml
    .LINK
        Export-Event
    #>
    param(
    # The input path.  This file should be created using Export-Event
    [ValidateScript({
        $extension = @($_ -split '\.')[-1]
        $importer = $ExecutionContext.SessionState.InvokeCommand.GetCommand(
            "Import-$Extension",
            "Function,Alias,Cmdlet"
        )
        if (-not $importer) {
            throw "Import-$Extension does not exist.  Cannot import .$Extension"
        }
        return $true
    })]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string]
    $InputPath,

    # If set, will resend events.
    # Only events sent with New-Event or Send-Event will be resent.
    [Alias('Replay')]
    [switch]
    $Resend
    )

    process {
        if (-not (Test-Path $InputPath)) {
            return
        }

        $extension = @($InputPath -split '\.')[-1]
        $importer = $ExecutionContext.SessionState.InvokeCommand.GetCommand(
            "Import-$Extension",
            "Function,Alias,Cmdlet"
        )

        if ($resend) {
            & $importer $inputPath | 
                & { process {
                    $evt = $_
                    if ($evt.SourceIdentifier) {
                        $evt | Send-Event
                    }
                    $evt
                } }
        } else {
            & $importer $inputPath
        }        
    }
}
