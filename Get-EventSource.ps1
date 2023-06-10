function Get-EventSource
{
    <#
    .Synopsis
        Gets Event Sources
    .Description
        Gets Event Sources.

        Event sources are commands or script blocks that can generate events.

        Event sources can be implemented in:
        * A .PS1 file starting with @
        * An in-memory scriptblock variable starting with @
        * A module command referenced within a PrivateData.OnQ section of the module manifest.
    .Example
        Get-EventSource
    .Example
        Get-EventSource -Subscription
    .Link
        Watch-Event
    #>
    [OutputType('Eventful.EventSource',
        [Management.Automation.CommandInfo],
        [Management.Automation.PSEventSubscriber],
        [PSObject])]
    param(
    # The name of the event source.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Name,

    # If set, will get subscriptions related to event sources.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Subscription,

    # If set, will get source objects from the subscriptions related to event sources.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $SourceObject,

    # If set, will get full help for each event source.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Help
    )
    begin {
        #region Discover Event Sources
        $atFunctions = $ExecutionContext.SessionState.InvokeCommand.GetCommands('@*', 'Function',$true) -match '^@\w'

        # Save a pointer to the method for terseness and speed.
        $getCmd    = $ExecutionContext.SessionState.InvokeCommand.GetCommand

        $myInv = $MyInvocation

        $lookInDirectory = @(
            "$pwd"
            $myRoot =  $myInv.MyCommand.ScriptBlock.File | Split-Path -ErrorAction SilentlyContinue
            "$myRoot"
            if ($myInv.MyCommand.Module) { # Assuming, of course, we have a module.
                $MyModuleRoot = $myInv.MyCommand.Module | Split-Path -ErrorAction SilentlyContinue
                if ($MyModuleRoot -ne $myRoot) { "$MyModuleRoot" }
            }
        ) | Select-Object -Unique

        $atScripts = $lookInDirectory |
            Get-Item |
            Get-ChildItem -Filter '@*.ps1' -Recurse |
            & { process {
                if ($_.Name -notmatch '^\@\w') { return }
                $getCmd.Invoke($_.Fullname,'ExternalScript')
            } }

        # If we had a module, and we still don't have a match, we'll look for extensions.

        $loadedModules = @(Get-Module)

        if ($loadedModules -notcontains $myInv.MyCommand.Module) {
            $loadedModules = @($myInv.MyCommand.Module) + $loadedModules
        }
        $myModuleName = $myInv.MyCommand.Module.Name
        $extendedCommands =

            foreach ($loadedModule in $loadedModules) { # Walk over all modules.
                if ( # If the module has PrivateData keyed to this module
                    $loadedModule.PrivateData.$myModuleName
                ) {
                    # Determine the root of the module with private data.
                    $thisModuleRoot = [IO.Path]::GetDirectoryName($loadedModule.Path)
                    # and get the extension data
                    $extensionData = $loadedModule.PrivateData.$myModuleName
                    if ($extensionData -is [Hashtable]) { # If it was a hashtable
                        foreach ($ed in $extensionData.GetEnumerator()) { # walk each key

                            $extensionCmd =
                                if ($ed.Value -like '*.ps1') { # If the key was a .ps1 file
                                    $getCmd.Invoke( # treat it as a relative path to the .ps1
                                        [IO.Path]::Combine($thisModuleRoot, $ed.Value),
                                        'ExternalScript'
                                    )
                                } else { # Otherwise, treat it as the name of an exported command.
                                    $loadedModule.ExportedCommands[$ed.Value]
                                }
                            if ($extensionCmd) { # If we've found a valid extension command
                                $extensionCmd    # return it.
                            }
                        }
                    }
                }
                elseif ($loadedModule.Tags -contains $myModuleName) {
                    foreach ($matchingFile in @(Get-ChildItem (Split-Path $loadedModule.Path) -Recurse) -match '\@\w' -match '\.ps1$') {
                        if ($matchingFile.Name -match '^\@\w' ) {
                            $getCmd.Invoke($matchingFile.FullName, 'ExternalScript')
                        }
                    }
                }
            }
        $allSources = @() + $atFunctions + $atScripts + $extendedCommands

        $allSources = $allSources | Select-Object -Unique
        #endregion Discover Event Sources
    }

    process {
        foreach ($src in $allSources) {
            if ($Name) {

                $ok =
                    foreach ($n in $Name) {
                        $src.Name -like "$n" -or
                        $src.Name -replace '^@' -replace '\.ps1$' -like "$n"
                    }

                if (-not $ok) {
                    continue
                }
            }



            if ($Subscription -or $SourceObject) {
                if (-not  $script:SubscriptionsByEventSource) { continue }
                $eventSourceKey = # Then, if the event source was a script,
                    if ($src -is [Management.Automation.ExternalScriptInfo]) {
                        $src.Path # the key is the path.
                    } elseif ($src.Module) { # If it was from a module
                        $src.Module + '\' + $eventSource.Name # it's the module qualified name.
                    } else {
                        $src.Name # Otherwise, it's just the function name.
                    }
                if (-not  $script:SubscriptionsByEventSource[$eventSourceKey]) { continue }
                if ($Subscription) {
                    $script:SubscriptionsByEventSource[$eventSourceKey] |
                        Where-Object {
                            [Runspace]::DefaultRunspace.Events.Subscribers -contains $_
                        }
                } else {
                    if ($script:SubscriptionsByEventSource[$eventSourceKey].SourceObject) {
                        $script:SubscriptionsByEventSource[$eventSourceKey].SourceObject
                    } else {
                        $jobName = $script:SubscriptionsByEventSource[$eventSourceKey].Name
                        Get-EventSubscriber -SourceIdentifier $jobName -ErrorAction SilentlyContinue |
                            Select-Object -ExpandProperty SourceObject -ErrorAction SilentlyContinue
                    }

                }
                continue
            }



            $src.pstypenames.clear()
            $src.pstypenames.add('Eventful.EventSource')
            if ($Help -and -not $Parameter) {
                Get-Help $src.EventSourceID -Full
                continue
            }
            $src
        }
    }
}
