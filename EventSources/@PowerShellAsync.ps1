<#
.Synopsis
    Runs PowerShell asynchronously
.Description
    Runs PowerShell in the background.  
    Events are fired on the completion or failure of the PowerShell command.
#>
[ComponentModel.InitializationEvent({
    # Because of the potential for a "narrow window" timing issue,
    # this event source needs to return a script to run in order to start it.
    # $this is whatever object is returned.  
    # If multiple objects are returned, this will be run multiple times.
    $Global:PowerAsyncResults[$this.InstanceID] = $this.BeginInvoke()
})]
[CmdletBinding(PositionalBinding=$false)]
param(
# The scripts you would like to run.  Each script block will be counted as a distinct statement.
[Parameter(Mandatory,Position=0)]
[ScriptBlock[]]
$ScriptBlock,

# The named parameters passed to each script.
[Collections.IDictionary[]]
[Alias('Parameters')]
$Parameter,

# If provided, will run in a specified runspace.  The Runspace must already be open.
[Management.Automation.Runspaces.Runspace]
$Runspace,

# If provided, will run in a runspace pool.  The RunspacePool must already be open.
[Management.Automation.Runspaces.RunspacePool]
$RunspacePool
)

process {
    $psAsync = [PowerShell]::Create()
    $null = for ($n =0; $n -lt $ScriptBlock.Length;$n++) {        
        $psAsync.AddStatement()
        $psAsync.AddScript($ScriptBlock[$n])
        if ($parameter -and $Parameter[$n]) {
            $psAsync.AddParameters($Parameter[$n])
        }
    }
    foreach ($cmd in $psAsync.Commands) {
        foreach ($ce in $cmd.Commands) {
            $ce.MergeMyResults("All", "Output")
        }
    }
    if (-not $Global:PowerAsyncResults) {
        $Global:PowerAsyncResults = @{}
    }

    if ($Runspace) {        
        $psAsync.Runspace = $Runspace
    } 
    elseif ($RunspacePool) {
        $psAsync.RunspacePool = $RunspacePool
    }

    $onFinishedSubscriber = 
        Register-ObjectEvent -InputObject $psAsync -EventName InvocationStateChanged -Action {
            $psAsyncCmd = $event.Sender
            if ($psAsyncCmd.InvocationStateInfo.State -notin 'Completed', 'Failed', 'Stopped') {
                return
            }
            if ($Global:PowerAsyncResults[$psAsyncCmd.InstanceID]) {
                $asyncResults = $event.Sender.EndInvoke($Global:PowerAsyncResults[$psAsyncCmd.InstanceID])
                $Global:PowerAsyncResults.Remove($psAsyncCmd.InstanceID)
                New-Event -SourceIdentifier "PowerShell.Async.$($psAsyncCmd.InstanceID)" -Sender $event.Sender -MessageData $asyncResults -EventArguments $event.SourceEventArgs
            }
            
            if ($psAsyncCmd.InvocationStateInfo.Reason) {
                New-Event -SourceIdentifier "PowerShell.Async.Failed.$($psAsyncCmd.InstanceID)" -Sender $psAsyncCmd -MessageData $psAsyncCmd.InvocationStateInfo.Reason
            }
            Get-EventSubscriber | 
                Where-Object SourceObject -EQ $psAsyncCmd |
                Unregister-Event

            $psAsyncCmd.Dispose()
        }

    $psAsync |
        Add-Member NoteProperty SourceIdentifier @(
            "PowerShell.Async.$($psAsync.InstanceID)","PowerShell.Async.Failed.$($psAsync.InstanceID)"
        ) -Force -PassThru 
    
    return
}