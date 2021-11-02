<#
.Synopsis
    Watches a process.
.Description
    Watches a process.

    If -Exit is passed, watches for process exit.

    If -Output is passed, watches for process output

    If -Error is passed, watched for process error
#>
param(
# The process identifier
[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
[Alias('ID')]
[int]
$ProcessID,

# If set, will watch for process exit.  This is the default unless -StandardError or -StandardOutput are passed.
[switch]
$Exit,

# If set, will watch for new standard output.
[switch]
$StandardOutput,

# If set, will watch for new standard erorr.
[switch]
$StandardError
)

process {
    $eventNames = @(
        if ($Exit) {
            "Exited"
        }
        if ($StandardOutput) {
            "OutputDataReceived"
        }
        if ($StandardError) {
            "ErrorDataReceived"
        }
    )

    if ($eventNames) {
        Get-Process -Id $ProcessID |
            Add-Member EventName $eventNames -Force -PassThru
    } else {
        Get-Process -Id $ProcessID |
            Add-Member EventName "Exited" -Force -PassThru
    }

}