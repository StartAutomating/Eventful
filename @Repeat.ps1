<#
.Synopsis
    Send events on repeat.
.Description
    Sends events on repeat, at a given [Timespan] -Interval.
.Example
    On Interval "00:01:00" { "Every minute" | Out-Host }
#>
[Diagnostics.Tracing.EventSource(Name='Elapsed')]
param(
# The amount of time to wait between sending events.
[Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName=$true)]
[Alias('Every')]
[Timespan]
$Interval
)

process {
    $timer = New-Object Timers.Timer -Property @{Interval=$Interval.TotalMilliseconds;AutoReset=$true}
    $timer.Start()
    $timer
}