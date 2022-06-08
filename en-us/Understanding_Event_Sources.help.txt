Understanding Event Sources
---------------------------
Event Sources are scripts that produce events.

They are generally named @NameOfSource.ps1.

Events in PowerShell can be produced in two ways:
* .NET Objects can produce events.
* An event can be sent by PowerShell.

An event source script can return any object with events, 
and indicate which events to subscribe to either by addding a 
[Diagnostics.Tracing.EventSource(Name='EventName')] attribute 
or by adding a noteproperty called "EventName" to the return.

Event sources can be found a few places:

* In the current directory
* In any function whose name starts with @
* In the directory where Watch-Event is defined
* In the module root where Watch-Event is defined
* In an .OnQ [Hashtable] within a module manifest's private data

You can see the event sources currently available with:

~~~PowerShell
Get-EventSource
~~~