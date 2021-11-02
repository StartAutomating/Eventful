if ($this -is [Management.Automation.ExternalScriptInfo]) {
    $this.Path # the key is the path.
} elseif ($this.Module) { # If it was from a module
    $this.Module + '\' + $this.Name # it's the module qualified name.
} else {
    $this.Name # Otherwise, it's just the function name.
}
