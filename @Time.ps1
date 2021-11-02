<#
.Synopsis
    Sends an event at a specific time.
.Description
    Sends an event at a specific date and time.
.Example
    On Time "5:00 PM" { "EOD!" | Out-Host }
#>
[Diagnostics.Tracing.EventSource(Name='Elapsed')]
param(
[Parameter(Mandatory,Position=0,ParameterSetName='SpecificTime')]
[DateTime]
$DateTime
)

process {
    if ($DateTime -lt [DateTime]::Now) {
        Write-Error "-DateTime '$DateTime' must be in the future"
        return
    }

    $timer =
        New-Object Timers.Timer -Property @{Interval=($DateTime - [DateTime]::Now).TotalMilliseconds;AutoReset=$false}

    if (-not $timer) { return }
    $timer.Start()
    return $timer
}
