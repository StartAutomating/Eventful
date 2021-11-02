foreach ($file in Get-ChildItem -LiteralPath $PSScriptRoot -Filter *-*.ps1) {
    . $file.Fullname
}


Set-Alias -Name On -Value Watch-Event
Set-Alias -Name Send -Value Send-Event
Set-Alias -Name Receive -Value Receive-Event


$eventSources = Get-EventSource 

foreach ($es in $eventSources) {
    Set-Alias "On@$($es.Name -replace '^@' -replace '\.ps1$')" -Value Watch-Event
}

Export-ModuleMember -Alias * -Function *