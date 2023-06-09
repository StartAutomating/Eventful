#requires -Module PSDevOps
Import-BuildStep -Module Eventful
New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, BuildEventful -Environment @{
    NoCoverage = $true
} -OutputPath (
    Join-Path $PSScriptRoot .github\workflows\TestAndPublish.yml
)

New-GitHubWorkflow -On Issue, Demand -Job RunGitPub -Name OnIssueChanged -OutputPath (
    Join-Path $PSScriptRoot .github\workflows\OnIssue.yml
)

