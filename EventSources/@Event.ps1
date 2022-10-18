<#
.Synopsis
    Watches for new events.
.Description
    Watches for any new events.
    
    Subscribing to this event will preempt all other events.
#>
[Diagnostics.Tracing.EventSource(Name='PSEventReceived')]
param()

process {
    ,$([Runspace]::DefaultRunspace.Events.ReceivedEvents)
}