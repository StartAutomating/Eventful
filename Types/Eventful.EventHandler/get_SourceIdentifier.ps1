if ($this.Name -match '\.(events|handlers).ps1$') {
    ''
} else {
    $this.Name -replace '^On_' -replace '\.handler' -replace '\.ps1$'
}
