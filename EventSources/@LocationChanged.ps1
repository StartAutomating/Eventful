<#
.Synopsis
    Sends events when the directory changes.
.Description
    Sends events when the PowerShell current directory changes.
.EXAMPLE
    On@LocationChanged
.EXAMPLE
    On@LocationChanged  -Then  { $event | Out-Host } 
#>
param()

process {
    $global:ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = {
        param($LocationChangedArgs)

        New-Event -SourceIdentifier "PowerShell.LocationChanged" $LocationChangedArgs -Sender $ExecutionContext
    }
    [PSCustomObject]@{
        SourceIdentifier = "PowerShell.LocationChanged"
    }
}
