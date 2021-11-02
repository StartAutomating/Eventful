function Get-EventHandler
{
    <#
    .Synopsis
        Gets Event Handlers
    .Description
        Gets files that act as Event Handlers.

        These files can be named a few ways:

        * On_[EventName].ps1  / [EventName].handler.ps1 (These handle a single event)
        * [Name].handlers.ps1 / [Name].events.ps1       (These handle multiple events)
    #>
    param(

    # The path to the handler file(s)
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $HandlerPath
    )

    begin {
        $namingConvention = "On_(?<Name>.+)\.ps1$", "(?<Name>.+)\.handler\.ps1$", "(?<Name>.+)\.handlers\.ps1$", "(?<Name>.+)\.events\.ps1$"
        $namingConvention = "(?>$($namingConvention -join '|'))"
    }
    process {
        if (-not $HandlerPath) { # If we don't have a handler path
            $HandlerPath = $PWD  # assume the current directory
        }

        foreach ($path in $HandlerPath) {
            Get-ChildItem -Path $path |
                Where-Object Name -Match $namingConvention |
                ForEach-Object {
                    $cmd = $ExecutionContext.InvokeCommand.GetCommand($_.FullName, 'ExternalScript')
                    $cmd.pstypenames.clear()
                    $cmd.pstypenames.add('Eventful.EventHandler')
                    $cmd
                }

        }
    }
}
