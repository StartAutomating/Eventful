<#
.Synopsis
    Signals on UDP 
.Description
    Runs PowerShell in the background.  
    Events are fired on the completion or failure of the PowerShell command.
#>
param(
# The IP Address where UDP packets can originate.  By default, [IPAddress]::Any.
[Parameter(ValueFromPipelineByPropertyName)]
[Net.IPAddress]
$IPAddress = [Net.IPAddress]::Any,

# The Port used to listen for packets.
[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
[int]
$Port,

# The encoding.  If provided, packet content will be decoded.
[Parameter(ValueFromPipelineByPropertyName)]
[Text.Encoding]
$Encoding
)

$startedJob = Start-Job -ScriptBlock {
    param($IPAddress, $port, $encoding)
    
    $udpSvr=  [Net.Sockets.UdpClient]::new()
    $endpoint = [Net.IpEndpoint]::new($IPAddress, $Port)

    try {
        $udpSvr.Client.Bind($endpoint)
    } catch  {
        Write-Error -Message $_.Message -Exception $_
        return
    }
    $eventSourceId = "UDP.${IPAddress}:$port"
    Register-EngineEvent -SourceIdentifier $eventSourceId -Forward
    if ($encoding) {
        $RealEncoding  = [Text.Encoding]::GetEncoding($encoding.BodyName)
        if (-not $RealEncoding) {
            throw "Could not find $($encoding | Out-String)"
        }
    }
    while ($true) {
        $packet = $udpSvr.Receive([ref]$endpoint)

        if ($RealEncoding) {            
            New-Event -Sender $IPAddress -MessageData $RealEncoding.GetString($packet) -SourceIdentifier $eventSourceId |
                Out-Null
        } else {
            New-Event -Sender $IPAddress -MessageData $packet -SourceIdentifier $eventSourceId  | Out-Null
        }
        
    }
} -ArgumentList $IPAddress, $port, $Encoding

@{
    SourceIdentifier = "UDP.${IPAddress}:$port"
}


