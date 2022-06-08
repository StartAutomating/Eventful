#require -Module HelpOut
Push-Location $PSScriptRoot

$EventfulLoaded = Get-Module Eventful
if (-not $EventfulLoaded) {
    $EventfulLoaded = Get-ChildItem -Recurse -Filter "*.psd1" | Where-Object Name -like 'Eventful*' | Import-Module -Name { $_.FullName } -Force -PassThru
}
if ($EventfulLoaded) {
    "::notice title=ModuleLoaded::Eventful Loaded" | Out-Host
} else {
    "::error:: Eventful not loaded" |Out-Host
}

Save-MarkdownHelp -Module Eventful -OutputPath $wikiPath -ScriptPath '@*' -ReplaceScriptName '^@', 
    '\.ps1$' -ReplaceScriptNameWith '',"-EventSource" -SkipCommandType Alias -PassThru |
    Add-Member CommitMessage ScriptProperty { "Updating $($this.Name) [skip ci]" } -Force -PassThru

Pop-Location