function Clear-EventSource
{
    <#
    .Synopsis
        Clears event source subscriptions
    .Description
        Clears any active subscriptions for any event source.
    .Example
        Clear-EventSource
    .Link
        Get-EventSource
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([nullable])]
    param(
    # The name of the event source.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Name)

    process {
        #region Determine Event Sources
        $parameterCopy = @{} + $PSBoundParameters
        $null = $parameterCopy.Remove('WhatIf')
        $eventSources = Get-EventSource @parameterCopy -Subscription
        if ($WhatIfPreference) {
            $eventSources
            return
        }
        #endregion Determine Event Sources
        #region Unregister
        if ($PSCmdlet.ShouldProcess("Clear event sources $($Name -join ',')")) {
            $eventSources | Unregister-Event
        }
        #endregion Unregister
    }
}
