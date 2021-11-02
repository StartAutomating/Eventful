﻿#requires -Module PSDevOps
New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish -Environment @{    
    NoCoverage = $true
}|
    Set-Content .\.github\workflows\TestAndPublish.yml -Encoding UTF8 -PassThru
