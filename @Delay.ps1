<#
.Synopsis
    Send an event after a delay.
.Description
    Send an event after waiting an arbitrary [Timespan]
.Example
    On Delay "00:00:01" -Then { "In a second!" | Out-Host }
#>

param(
# The amount of time to wait
[Parameter(Mandatory,Position=0,ParameterSetName='Delay',ValueFromPipelineByPropertyName=$true)]
[Alias('Delay', 'In')]
[Timespan]
$Wait
)

process {
    $timer = New-Object Timers.Timer -Property @{Interval=$Wait.TotalMilliseconds;AutoReset=$false}
    $timer.Start()
    $timer | Add-Member NoteProperty EventName Elapsed -PassThru
}