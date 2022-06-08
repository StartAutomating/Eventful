#require -Module HelpOut
Push-Location $PSScriptRoot

Save-MarkdownHelp -Module Eventful -OutputPath $wikiPath -ScriptPath '@*' -ReplaceScriptName '^@', 
    '\.ps1$' -ReplaceScriptNameWith '',"-EventSource" -SkipCommandType Alias

Pop-Location