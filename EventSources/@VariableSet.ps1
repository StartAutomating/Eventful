<#
.Synopsis
    Watches for variable sets.
.Description
    Watches for assignments to a variable.  
    
    Events are sent directly after the variable is set.
    
    The -Sender is the callstack, The -MessageData is the value of the variable.
#>
param(
# The name of the variable
[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
[string]
$VariableName
)

process {
    Get-PSBreakpoint | Where-Object Variable -eq $VariableName | Remove-PSBreakpoint

    $raiseEvent = [ScriptBlock]::Create(@"
New-Event -SourceIdentifier 'VariableSet.$variableName' -MessageData `$$variableName -Sender (Get-PSCallstack)
continue
"@)
    Set-PSBreakpoint -Variable $VariableName -Action $raiseEvent | Out-Null

    [PSCustomObject]@{SourceIdentifier="VariableSet.$variableName"}
}
