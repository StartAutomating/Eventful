<#
.Synopsis
    Watches for new events.
.Description
    
#>
[Diagnostics.Tracing.EventSource(Name='PSEventReceived')]
param()

process {
    ,$([Runspace]::DefaultRunspace.Events.ReceivedEvents)
}