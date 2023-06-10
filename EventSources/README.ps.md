This directory contains the built-in EventSources in Eventful.

_Technically speaking_, EventSources can exist in any directory, as long as they are named liked `@*.ps1` and match `^@\w`.

Event sources within Eventful or modules that tag Eventful will be automatically included.

Watch-Event will also check the local directory for event sources.

~~~PipeScript{
    $imported = Import-Module ../ -Global -PassThru
    
    [PSCustomObject]@{
        Table = Get-EventSource |
            .Name {
                "[$($_.Name -replace '\.ps1$')](/docs/$($_.Name -replace '^@' -replace '\.ps1$')-EventSource.md)"
            } .Synopsis
    }
}
~~~


