<#
.Synopsis
    Watches for Module loads and unloads.
.Description
    Polls the current set of globally imported PowerShell modules.

    When this changes, one of two events will be generated:

    PowerShell.Module.Loaded will be sent when one or more modules is loaded
    PowerShell.Module.Unloaded will be sent when one or more modules is unloaded

    Only one event if each will be sent per polling interval.
#>
param(
# The frequency to check for a module load.
[Timespan]
$PollingInterval = [Timespan]::FromMilliseconds(7037)
)

process {
    $eventSubscriber = Get-EventSubscriber -SourceIdentifier "ModuleLoaded_Check" -ErrorAction SilentlyContinue
    if ($eventSubscriber) {
        $eventSubscriber | Unregister-Event
    }

    $timer = [Timers.Timer]::new()
    $timer.AutoReset = $true
    $timer.Interval = $PollingInterval.TotalMilliseconds
    $timer.Start()
    Register-ObjectEvent -SourceIdentifier "ModuleLoaded_Check" -InputObject $timer -EventName Elapsed -Action {
        $loadedModules = Get-Module
        if ($script:ModuleLoadedList) {
            $Compared = Compare-Object -ReferenceObject $script:ModuleLoadedList -DifferenceObject $loadedModules

            $newModules     = $compared | Where-Object SideIndicator -eq '=>' | Select-Object -ExpandProperty InputObject
            $removedModules = $compared | Where-Object SideIndicator -eq '<=' | Select-Object -ExpandProperty InputObject
            if ($newModules) {
                New-Event -SourceIdentifier "PowerShell.Module.Loaded" -EventArguments $newModules -MessageData $newModules
            }
            if ($removedModules) {
                New-Event -SourceIdentifier "PowerShell.Module.Unloaded" -EventArguments $removedModules -MessageData $removedModules
            }
        }
        $script:ModuleLoadedList = $loadedModules
    } | Out-Null
    [PSCustomObject]@{
         SourceIdentifier = "PowerShell.Module.Loaded","PowerShell.Module.Unloaded"
    }
}
