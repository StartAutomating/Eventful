<#
.Synopsis
    Watches for File Changes.
.Description
    Uses the [IO.FileSystemWatcher] to watch for changes to files.

    Because some applications and frameworks write to files differently, 
    you may see more than one event for a given change.
#>
param(
# The path to the file or directory
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Fullname')]
[string]
$FilePath = "$pwd",

# A wildcard filter describing the names of files to watch
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$FileFilter,

# A notify filter describing the file changes that should raise events.
[Parameter(ValueFromPipelineByPropertyName)]
[IO.NotifyFilters[]]
$NotifyFilter = @("FileName", "DirectoryName", "LastWrite"),

# If set, will include subdirectories in the watcher.
[Alias('InludeSubsdirectory','InludeSubsdirectories')]
[switch]
$Recurse,

# The names of the file change events to watch.
# By default, watches for Changed, Created, Deleted, or Renamed
[ValidateSet('Changed','Created','Deleted','Renamed')]
[string[]]
$EventName = @('Changed','Created','Deleted','Renamed')
)

process {
    $resolvedFilePath = try {
        $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($FilePath)
    } catch {
        Write-Error "Could not resolve path '$FilePath'"
        return
    }

    if ([IO.File]::Exists("$resolvedFilePath")) { # If we're passed a path to a specific file
        $fileInfo = ([IO.FileInfo]"$resolvedFilePath")   
        $filePath = $fileInfo.Directory.FullName  # we need to watch the directory
        $FileFilter = $fileInfo.Name              # and then filter based off of the file name.
    } elseif ([IO.Directory]::Exists("$resolvedFilePath")) {
        $filePath = "$resolvedFilePath"
    }

    $fileSystemWatcher = [IO.FileSystemWatcher]::new($FilePath) # Create the watcher
    $fileSystemWatcher.IncludeSubdirectories = $Recurse         # include subdirectories if -Recurse was passed
    $fileSystemWatcher.EnableRaisingEvents = $true              # Enable raising events
    if ($FileFilter) {
        $fileSystemWatcher.Filter = $FileFilter
    } else {
        $fileSystemWatcher.Filter = "*"
    }
    $combinedNotifyFilter = 0
    foreach ($n in $NotifyFilter) {
        $combinedNotifyFilter = $combinedNotifyFilter -bor $n
    }
    $fileSystemWatcher.NotifyFilter = $combinedNotifyFilter
    $fileSystemWatcher | 
        Add-Member NoteProperty EventName $EventName -Force -PassThru
}
