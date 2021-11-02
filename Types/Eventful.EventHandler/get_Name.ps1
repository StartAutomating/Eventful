$realName = $this.GetType().GetProperty("Name").GetGetMethod().Invoke($this, 'Instance,Public', $null, $null, $null)
if ($realName -match '\.(events|handlers).ps1$') {
    $realName -replace '\.(events|handlers).ps1$'
} else {
    $realName -replace '^On_' -replace '\.handler' -replace '\.ps1$'
}

