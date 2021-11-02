<#
.Synopsis
    Watches a PowerShell Job's State.
.Description
    Watches a PowerShell Job's StateChange event.

    This will send an event when a job finishes.
#>
param(
[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
[Alias('ID')]
[int]
$JobID)

if ($_ -is [Management.Automation.Job]) {
    $_
} else {
    Get-Job -Id $JobID -ErrorAction SilentlyContinue
}

