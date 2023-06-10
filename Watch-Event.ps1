function Watch-Event {
    <#
    .Synopsis
        Watches Events
    .Description
        Watches Events by SourceIdentifier, or using an EventSource script.
    .Example
        Watch-Event -SourceIdentifier MySignal -Then {"fire!" | Out-Host }
    .Example
        On MySignal { "fire!" | Out-host }

        New-Event MySignal
    .Link
        Get-EventSource
    .Link
        Register-ObjectEvent
    .Link
        Register-EngineEvent
    .Link
        Get-EventSubscriber
    .Link
        Unregister-Event
    #>
    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([nullable],[PSObject])]
    param()

    dynamicParam {
        #region Handle Input Dynamically
        # Watch-Event is written in an unusually flexible way:
        # It has no real parameters, only dynamic ones.
        $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()

        # The first step of our challenge is going to be determining the Event Source.
        $eventSource = $null
        # Since we only want to make one pass,
        # we also want to start tracking the maximum position we've found for a parameter.
        $maxPosition = -1
        # We also might want to know if we created the SourceIdentifier parameter yet.
        $SourceIDParameterCreated = $false

        #region Prepare to Add SourceID Parameter
        # Since we might add SourceID at a couple of different points in the code below,
        # we'll declare a [ScriptBlock] to add the source parameter whenever we want.
        $AddSourceIdParameter = {
            $SourceIDParameterCreated = $true # The -SourceIdentifier
            $sourceIdParameter = [Management.Automation.ParameterAttribute]::new()
            $sourceIdParameter.Mandatory = $true       # will be mandatory
            $sourceIdParameter.Position = 0  # and will be first.
            # Add the dynamic parameter whenever this is called
            $DynamicParameters.Add("SourceIdentifier",
                            [Management.Automation.RuntimeDefinedParameter]::new(
                                "SourceIdentifier", [string[]], $sourceIdParameter))
            $maxPosition = 0 # and set MaxPosition to 0 for the next parameter.
        }
        #endregion Prepare to  Add SourceID Parameter

        #region Find the Event Source and Map Dynamic Parameters

        #region Determine Invocation Name
        # In order to find the event source, we need to use information about how we were called.
        # This information is stored in $myInvocation, which can change.  So we capture it's value right now.
        $myInv = $MyInvocation
        $InvocationName = '' # Our challenge is to determine the final $invocationName to use throughout the script.


        if ($myInv.InvocationName -ne $myInv.MyCommand.Name) { # If we're calling this command with an alias
            $invocationName = @($myInv.InvocationName -split '@', 2)[1] # the invocationname is what's after @.
        }


        if (-not $invocationName) { # If we don't have an invocation name,
            # we can peek at how we are being called (by looking at the $myInvocation.Line).
            $index = $myInv.Line.IndexOf($myInv.InvocationName)

            if ($index -ge 0) { # If our command is in the line,
                $myLine = $myInv.Line.Substring($index) # we can use some regex
                # to "peek" at positional parameters before the parameter even exists.

                # In this case, that regex is currently
                # the invocation name, followed by whitespace and a SourceIdentifier.
                if ($myLine -match "\s{0,}$($myInv.InvocationName)\s{1,}(?<SourceIdentifier>\w+)") {

                    $invocationName = $Matches.SourceIdentifier
                    # If we match, use that as the $invocationName
                    # and add the sourceID parameter (so the positional parameter exists).
                    . $AddSourceIdParameter
                }
            }
        }

        if (-not $InvocationName) {
            $InvocationName= $myInv.MyCommand.Name
        }

        #endregion Determine Invocation Name
        if ($invocationName -ne $myInv.MyCommand.Name) {
            #region Find Event Source

            # If we're being called with a smart alias, determine what the underlying command is.
            # But first, let's save a pointer to $executionContext.SessionState.InvokeCommand.GetCommand
            $getCmd    = $ExecutionContext.SessionState.InvokeCommand.GetCommand

            # We want the next code to match quickly and not try too many codepaths,
            # so we'll run this in a [ScriptBlock]
            $eventSource =
                . {


                    # Our first possibility is that we have an @Function or Alias.
                    # Such a function would have to be defined using the provider syntax
                    # (e.g. ${function:@EventSource} = {}) so this is _very_ unlikely to happen by mistake.
                    $atFunction = $getCmd.Invoke("@$invocationName", 'Function,Alias')
                    if ($atFunction) {
                        if ($atFunction.ResolvedCommand) {
                            return $atFunction.ResolvedCommand
                        } else {
                            return $atFunction
                        }
                    }


                    # The next possibility is an @.ps1 script.
                    $atFile = "@$($invocationName).ps1"
                    # This could be in a few places: the current directory first,
                    foreach ($foundFile in ($pwd, $myRoot | 
                        Get-ChildItem -Recurse |
                        & { process {
                            if ($_.Name -eq $atFile) { $_ }
                        } })) {
                            
                        $foundCmd = $getCmd.Invoke($foundFile.FullName, 'ExternalScript')
                        if ($foundCmd) { return $foundCmd}
                    }

                    if ($myInv.MyCommand.Module) { # then the module root
                        $MyModuleRoot = $myInv.MyCommand.Module | Split-Path -ErrorAction SilentlyContinue
                        if ($MyModule -ne $myRoot) { # (if different from $myroot).
                            $atModuleRootCmd =
                                $getCmd.Invoke(
                                    (Get-ChildItem -LiteralPath $MyModuleRoot -Filter $atFile).FullName, 'ExternalScript')
                            if ($atModuleRootCmd) { $atModuleRootCmd; continue }
                        }



                        # Last, we want to look for extensions.
                        $myModuleName = $myInv.MyCommand.Module.Name
                        foreach ($loadedModule in Get-Module) { #
                            if ( # If a module has a [Hashtable]PrivateData for this module
                                $loadedModule.PrivateData.$myModuleName
                            ) {
                                $thisModuleRoot = [IO.Path]::GetDirectoryName($loadedModule.Path)
                                $extensionData = $loadedModule.PrivateData.$myModuleName
                                if ($extensionData -is [Hashtable]) { # that is a [Hashtable]
                                    foreach ($ed in $extensionData.GetEnumerator()) { # walk thru the hashtable
                                        if ($invocationName -eq $ed.Key) { # find out event source name
                                            $extensionCmd =
                                                if ($ed.Value -like '*.ps1') { # and map it to a script or command.
                                                    $getCmd.Invoke(
                                                        (Join-Path $thisModuleRoot $ed.Value),
                                                        'ExternalScript'
                                                    )
                                                } else {
                                                    $loadedModule.ExportedCommands[$ed.Value]
                                                }

                                            # If we could map it, return it before we keep looking thru modules.
                                            if ($extensionCmd) {
                                                return $extensionCmd
                                            }
                                        }
                                    }
                                }
                            }
                            elseif ($loadedModule.Tags -contains $myModuleName) {                                
                                foreach ($matchingFile in @(Get-ChildItem (Split-Path $loadedModule.Path) -Recurse) -match '\@\w' -match '\.ps1$') {
                                    if ($matchingFile.Name -eq $atFile) {
                                        return $getCmd.Invoke($matchingFile.FullName, 'ExternalScript')
                                    }
                                }
                            }
                        }
                    }


                }
            #endregion Find Event Source
            #region Map Dynamic Parameters
            if ($eventSource) {
                # We only need to map dynamic parameters if there is an event source.
                $eventSourceMetaData = [Management.Automation.CommandMetaData]$eventSource
                # Determine if we need to offset positional parameters,
                $positionOffset = [int]$SourceIDParameterCreated
                # then walk over the parameters from that event source.
                foreach ($kv in $eventSourceMetaData.Parameters.GetEnumerator()) {

                    $attributes =
                        if ($positionOffset) { # If we had to offset the position of a parameter
                            @(foreach ($attr in $kv.value.attributes) {
                                if ($attr -isnot [Management.Automation.ParameterAttribute] -or
                                    $attr.Position -lt 0
                                ) {
                                    # we can passthru any non-parameter attributes and parameter attributes without position,
                                    $attr
                                } else {
                                    # but parameter attributes with position need to copied and offset.
                                    $attrCopy = [Management.Automation.ParameterAttribute]::new()
                                    # (Side note: without a .Clone, copying is tedious.)
                                    foreach ($prop in $attrCopy.GetType().GetProperties('Instance,Public')) {
                                        if (-not $prop.CanWrite) { continue }
                                        if ($null -ne $attr.($prop.Name)) {
                                            $attrCopy.($prop.Name) = $attr.($prop.Name)
                                        }
                                    }


                                    # Once we have  a parameter copy, offset it's position.
                                    $attrCopy.Position+=$positionOffset
                                    $pos = $attrCopy.Position
                                    $attrCopy
                                }
                            })
                        } else {
                            $pos = foreach ($a in $kv.value.attributes) {
                                if ($a.position -ge 0) { $a.position ; break }
                            }
                            $kv.Value.Attributes
                        }

                    # Add the parameter and it's potentially modified attributes.
                    $DynamicParameters.Add($kv.Key,
                        [Management.Automation.RuntimeDefinedParameter]::new(
                            $kv.Value.Name, $kv.Value.ParameterType, $attributes
                        )
                    )
                    # If the parameter position was bigger than maxPosition, update maxPosition.
                    if ($pos -ge 0 -and $pos -gt $maxPosition) { $maxPosition = $pos }
                }
            }
            #endregion Map Dynamic Parameters
        }

        #endregion Find the Event Source and Map Dynamic Parameters


        

        #region Optionally Add Source Identifier
        # If we don't have an Event Source at this point and we haven't already,
        if (-not $eventSource -and -not $SourceIDParameterCreated) { # add the SourceIdentifier parameter.
            . $addSourceIdParameter
        }
        #endregion Optionally Add Source Identifier

        #region Optionally Add InputObject Parameter
        # Also, if we don't have an event source
        if (-not $eventSource) {
            # then we can add an InputObject parameter.
            $inputObjectParameter = [Management.Automation.ParameterAttribute]::new()
            $inputObjectParameter.ValueFromPipeline = $true
            $DynamicParameters.Add("InputObject",
                    [Management.Automation.RuntimeDefinedParameter]::new(
                        "InputObject", [PSObject], $inputObjectParameter
                    )
                )

        }
        #endregion Optionally Add InputObject Parameter

        #region Add Common Parameters
        # All calls will always have two additional parameters:        
        $thenParam = [Management.Automation.ParameterAttribute]::new()
        $thenParam.Mandatory = $false #* [ScriptBlock]$then
        $thenParam.Position = ++$maxPosition
        $thenActionAlias = [Management.Automation.AliasAttribute]::new("Action")
        $DynamicParameters.Add("Then",
                        [Management.Automation.RuntimeDefinedParameter]::new(
                            "Then", [ScriptBlock], @($thenParam, $thenActionAlias)
                        )
                    )
        
        $WhenParam = [Management.Automation.ParameterAttribute]::new()
        $whenParam.Position = ++$maxPosition #* [ScriptBlock]$when
        $DynamicParameters.Add("When",
                        [Management.Automation.RuntimeDefinedParameter]::new(
                            "When", [ScriptBlock], $WhenParam
                        )
                    )
        
        $MessageDataParam = [Management.Automation.ParameterAttribute]::new()
        $MessageDataParam.Position = ++$maxPosition #* [ScriptBlock]$when
        $DynamicParameters.Add("MessageData",
                        [Management.Automation.RuntimeDefinedParameter]::new(
                            "MessageData", [PSObject], $MessageDataParam
                        )
                    )
        
        $maxTriggerParam = [Management.Automation.ParameterAttribute]::new()
        $maxTriggerParam.Position = ++$maxPosition #* [int]$MaxTriggerCount
        $DynamicParameters.Add("MaxTriggerCount",
            [Management.Automation.RuntimeDefinedParameter]::new(
                "MaxTriggerCount", [int], @(
                    $maxTriggerParam,
                    [Management.Automation.AliasAttribute]::new("Max"),
                    [Management.Automation.AliasAttribute]::new("Count")
                )
            )
        )
        #endregion Add Common Parameters


        # Now that we've got all of the dynamic parameters ready
        $DynamicParameterNames = $DynamicParameters.Keys -as [string[]]
        return $DynamicParameters # return them.
        #endregion Handle Input Dynamically
    }



    process {

        $in = $_
        $registerCmd = $null
        $registerParams = @{}
        $parameterCopy = @{}  + $PSBoundParameters
        if ($DebugPreference -ne 'silentlycontinue') {
            Write-Debug @"
Watch-Event:
Dynamic Parameters: $DynamicParameterNames
Bound   Parameters:
$($parameterCopy | Out-String)
"@
        }

        #region Run Event Source and Map Parameters
        if ($eventSource) { # If we have an Event Source, now's the time to run it.
            $eventSourceParameter = [Ordered]@{} + $PSBoundParameters # Copy whatever parameters we have
            foreach ($toRemove in 'Then','When','SourceIdentifier','MessageData','MaxTriggerCount') {
                $eventSourceParameter.Remove($toRemove)
            }            
            $eventSourceOutput = & $eventSource @eventSourceParameter # Then run the generator.
            $null = $PSBoundParameters.Remove('SourceIdentifier')

            if ($eventSourceOutput.MessageData) {
                $registerParams['MessageData'] = $eventSourceOutput.MessageData
            }
            $eventSourceMaxTriggerCount = $eventSourceOutput.MaxTriggerCount,$eventSourceOutput.Max,$eventSourceOutput.TriggerCount -as [int[]] -gt 0
            
            if ($eventSourceMaxTriggerCount) {
                $registerParams['MaxTriggerCount'] = $eventSourceMaxTriggerCount[0]
            }

            if (-not $eventSourceOutput) { # If it didn't output,
                # we're gonna assume it it's gonna by signal by name.
                # Set it up so that later code will subscribe to this SourceIdentifier.
                $PSBoundParameters["SourceIdentifier"] = $eventSource.Name -replace
                    '^@' -replace '\.event\.ps1$' -replace '\.ps1$'
            }
            elseif ($eventSourceOutput.SourceIdentifier)
            {

                # If the eventSource said what SourceIdentifier(s) it will send, we will listen.
                $PSBoundParameters["SourceIdentifier"] = $eventSourceOutput.SourceIdentifier
            } else {
                # Otherwise, let's see if the eventSource returned an eventName
                $eventName = $eventSourceOutput.EventName

                if (-not $eventName) { # If it didn't,
                    $eventName =
                        # Look at the generator script block's attibutes
                        foreach ($attr in $eventSource.ScriptBlock.Attributes) {
                            if ($attr.TypeId.Name -eq 'EventSourceAttribute') {
                                # Return any [Diagnostics.Tracing.EventSource(Name='Value')]
                                $attr.Name
                            }
                        }
                }


                if (-not $eventName) { # If we still don't have an event name.
                    # check the output for events.
                    $eventNames = @(foreach ($prop in $eventSourceOutput.psobject.members) {
                        if ($prop.MemberType -eq 'event') {
                            $prop.Name
                        }
                    })

                    # If there was more than one
                    if ($eventNames.Count -gt 1) {
                        # Error out (but output the generator's output, in case that helps).
                        $eventSourceOutput
                        Write-Error "Source produced an object with multiple events, but did not specify a '[Diagnostics.Tracing.EventSource(Name=)]'."
                        return
                    }


                    $eventName = $eventNames[0]
                }

                # Default the Register- command to Register-ObjectEvent.
                $registerCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Register-ObjectEvent','Cmdlet')
                $registerParams['InputObject']= $eventSourceOutput # Map the InputObject
                $registerParams['EventName']  = $eventName            # and the EventName.
            }
        }
        #endregion Run Event Source and Map Parameters

        #region Handle -SourceIdentifier and -InputObject
        if ($PSBoundParameters['SourceIdentifier']) { # If we have a -SourceIdentifier
            if ($PSBoundParameters['InputObject'] -and -not $eventSource) { # and an -InputObject (but not not an eventsource)
                # then the register command is Register-ObjectEvent.
                $registerCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Register-ObjectEvent','Cmdlet')

                # We map our -SourceIdentifier to Register-ObjectEvent's -EventName,
                $registerParams['EventName'] = $PSBoundParameters['SourceIdentifier']
                # and Register-ObjectEvent's InputObject to -InputObject
                $registerParams['InputObject'] = $PSBoundParameters['InputObject']
            }
            else # If we have a -SourceIdentifier, but no -InputObject
            {
                # the register command is Register-EngineEvent.
                $registerCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Register-EngineEvent','Cmdlet')
                # and we map our -SourceIdentifier parameter to Register-EngineEvent's -SourceIdentifier.
                $registerParams['SourceIdentifier'] = $PSBoundParameters['SourceIdentifier']
            }
        }
        #endregion Handle -SourceIdentifier and -InputObject

        #region Handle When and Then
        # Assign When and Then for simplicity.
        $Then = $PSBoundParameters['Then']
        $when = $PSBoundParameters['When']

        if ($When) { # If -When was provided
            if ($when -is [ScriptBlock]) { # and it was a script
                # Rewrite -Then to include -When (this prevents debugging).
                # Run -When in a subexpression so it can return from the event handler (not itself)
                $then = [ScriptBlock]::Create(@"
`$shouldHandle = `$(
    $when
)
if (-not `$shouldHandle) { return }
$then
"@)
            }
        }

        if ("$then" -replace '\s') { # If -Then is not blank.
            $registerParams["Action"] = $Then # this maps to the -Action parameter the Register- comamnd.
        }
        #endregion Handle When and Then

        #region Handle MaxTriggerCount and MessageData
        if ($parameterCopy['MaxTriggerCount']) {
            $registerParams['MaxTriggerCount'] = $parameterCopy['MaxTriggerCount']
        }

        if ($parameterCopy['MessageData']) {
            $registerParams['MessageData'] = $parameterCopy['MessageData']
        }
        #endregion

        #region Subscribe to Event

        # Now we create the event subscription.
        $eventSubscription =


            # If there's a Register- command.
            if ($registerCmd) {
                if ($registerParams["EventName"]) { # and we have -EventName
                    $evtNames = $registerParams["EventName"]
                    $registerParams.Remove('EventName')

                    # Call Register-Object event once
                    foreach ($evtName in $evtNames) { # for each event name (
                        # give it a logical SourceIdentifier.
                        $sourceId = $registerParams["InputObject"].GetType().FullName + ".$evtName"
                        $existingSubscribers = @(Get-EventSubscriber -SourceIdentifier "${sourceID}*")
                        if ($existingSubscribers) { # (If subscribers exist, increment the source ID))
                            $maxSourceId = 0
                            foreach ($es in $existingSubscribers) {
                                if ($es.SourceIdentifier -match '\.\d+$') {
                                    $esId = [int]($matches.0 -replace '\.')
                                    if ($esId -gt $maxSourceId) {
                                        $maxSourceId = $esId
                                    }
                                }
                            }
                            $sourceID = $sourceId + ".$($maxSourceId + 1)"
                        }

                        # Then call Register-ObjectEvent
                        & $registerCmd @registerParams -EventName $evtName -SourceIdentifier $sourceId
                    }
                }
                elseif ($registerParams["SourceIdentifier"])  #
                {
                    $sourceIdList = $registerParams["SourceIdentifier"]
                    $null = $registerParams.Remove('SourceIdentifier')
                    # If we don't have an action, don't run anything (this will let the events "bubble up" to the runspace).
                    if ($registerParams.Action) {
                        # If we do have an action, call Register-Engine event with each source identifier.
                        foreach ($sourceId in $sourceIdList) {
                            & $registerCmd @registerParams -SourceIdentifier $sourceId
                        }
                    }
                }
            }
        #endregion Subscribe to Event


        #region Keep track of Subscriptions by EventSource
        # Before we're done, let's track what we subscribed to.

        if ($eventSource) {
            # Make sure a cache exists.
            if (-not $script:SubscriptionsByEventSource) {
                $script:SubscriptionsByEventSource = @{}
            }
            $eventSourceKey = # Then, if the event source was a script,
                if ($eventSource -is [Management.Automation.ExternalScriptInfo]) {
                    $eventSource.Path # the key is the path.
                } elseif ($eventSource.Module) { # If it was from a module
                    $eventSource.Module.ToString() + '\' + $eventSource.Name # it's the module qualified name.
                } else {
                    $eventSource.Name # Otherwise, it's just the function name.
                }
            $script:SubscriptionsByEventSource[$eventSourceKey] =
                if ($eventSubscription -is [Management.Automation.Job]) {
                    Get-EventSubscriber -SourceIdentifier $eventSubscription.Name -ErrorAction SilentlyContinue
                } else {
                    $eventSubscription
                }

            $eventSourceInitializeAttribute= $eventSource.ScriptBlock.Attributes |
                Where-Object TypeID -EQ ([ComponentModel.InitializationEventAttribute])
            if ($eventSourceOutput.InitializeEvent -and $eventSourceOutput.InitializeEvent -is [string]) {
                $eventSourceOutput.$($eventSourceOutput.InitializeEvent).Invoke()
            }
            elseif ($eventSourceOutput.InitializeEvent -and $eventSourceOutput.InitializeEvent -is [ScriptBlock]) {
                $this = $sender = $eventSourceOutput
                & ([ScriptBlock]::Create($eventSourceInitializeAttribute.EventName))
            }
            elseif ($eventSourceInitializeAttribute.EventName -match '^[\w\-]+$') {
                $eventSourceOutput.($eventSourceInitializeAttribute.EventName).Invoke()
            } else {
                $this = $sender = $eventSourceOutput
                & ([ScriptBlock]::Create($eventSourceInitializeAttribute.EventName))
            }
        }

        #endregion Keep track of Subscription


        #region Passthru if needed
        if ($myInv.PipelinePosition -lt $myInv.PipelineLength) { # If this is not the last step of the pipeline
            $in # pass down the original object.  (This would let one set of arguments pipe to multiple calls)
        }
        else {

        }
        #endregion Passthru if needed
    }
}
