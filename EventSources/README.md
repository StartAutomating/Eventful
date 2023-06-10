This directory contains the built-in EventSources in Eventful.

_Technically speaking_, EventSources can exist in any directory, as long as they are named liked `@*.ps1` and match `^@\w`.

Event sources within Eventful or modules that tag Eventful will be automatically included.

Watch-Event will also check the local directory for event sources.


|Name                                                    |Synopsis                                      |
|--------------------------------------------------------|----------------------------------------------|
|[@CommandNotFound](/docs/CommandNotFound-EventSource.md)|Sends events when a command is not found.<br/>|
|[@Delay](/docs/Delay-EventSource.md)                    |Send an event after a delay.<br/>             |
|[@Event](/docs/Event-EventSource.md)                    |Watches for new events.<br/>                  |
|[@FileChange](/docs/FileChange-EventSource.md)          |Watches for File Changes.<br/>                |
|[@HttpResponse](/docs/HttpResponse-EventSource.md)      |Sends events on HTTP Responses.<br/>          |
|[@Job](/docs/Job-EventSource.md)                        |Watches a PowerShell Job's State.<br/>        |
|[@LocationChanged](/docs/LocationChanged-EventSource.md)|Sends events when the directory changes.<br/> |
|[@ModuleChanged](/docs/ModuleChanged-EventSource.md)    |Watches for Module loads and unloads.<br/>    |
|[@PowerShellAsync](/docs/PowerShellAsync-EventSource.md)|Runs PowerShell asynchronously<br/>           |
|[@Process](/docs/Process-EventSource.md)                |Watches a process.<br/>                       |
|[@Repeat](/docs/Repeat-EventSource.md)                  |Send events on repeat.<br/>                   |
|[@Time](/docs/Time-EventSource.md)                      |Sends an event at a specific time.<br/>       |
|[@UDP](/docs/UDP-EventSource.md)                        |Signals on UDP <br/>                          |
|[@VariableSet](/docs/VariableSet-EventSource.md)        |Watches for variable sets.<br/>               |





