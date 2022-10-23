<#
.Synopsis
    Sends events when a command is not found.
.Description
    Sends events when a command is not found.
    
    Handling this event can resolve any unknown command.    
.EXAMPLE
    On@CommandNotFound
.EXAMPLE
    On@CommandNotFound  -Then  { $event | Out-Host } 
#>
param()

process {
    $global:ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction = {
        New-Event -SourceIdentifier "PowerShell.CommandNotFound"  -MessageData $notFoundArgs -Sender $global:ExecutionContext -EventArguments $notFoundArgs
    }

    [PSCustomObject]@{
        SourceIdentifier = "PowerShell.CommandNotFound"
    }    
}