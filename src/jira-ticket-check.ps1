param (
    [string]$jiraDomain,
    [string]$projectsToFilterTicketsBy,
    [string]$uniqueProposedBuildIdentifier,
    [switch]$skipQaApproval = $false,
    [switch]$deploymentTaskCanBeSubtask = $false
)

$ProjectsFilter = @($projectsToFilterTicketsBy -split "," | ForEach-Object { " OR project=`"$($_.Trim())`"" }) -join ""

$DeploymentTask = $null
$DeploymentTaskKey = $null

$Uri = "https://$jiraDomain/rest/api/2/search?jql=(issuetype=`"Deployment Task`" OR issuetype=`"Deployment Sub-Task`"$ProjectsFilter) AND cf[11902]~`"$uniqueProposedBuildIdentifier`""

Write-Output "Generated url to query jira with: $Uri"

$JiraTickets = Invoke-RestMethod -Method Get -Uri $Uri

# Prefer a Deployment Task if there are multiple issues returned
if ($JiraTickets.total -gt 1) {
    $DeploymentTask = $JiraTickets.issues | Where-Object { $_.fields.issuetype.name -eq "Deployment Task" }
}

# If no issues are found, select the first one
if ($null -eq $DeploymentTask) {
    $DeploymentTask = $JiraTickets.issues[0]
}

if ($null -eq $DeploymentTask) {
    throw "No Deployment task found"
}

# If multiple issues are found, select the first one
if ($DeploymentTask.Count -gt 1) {
    $DeploymentTask = $DeploymentTask[0]
}

$DeploymentTaskKey = $DeploymentTask.key
Write-Output "Found the matching Deployment Task $DeploymentTaskKey"

# Technical Approval
$TechnicalApprovalField = $DeploymentTask.fields.customfield_16323

if ($null -eq $TechnicalApprovalField) {
    throw "Deployment Task $DeploymentTaskKey is NOT Technical Approved"
}

# QA Approval
$QaApprovalField = $DeploymentTask.fields.customfield_11507

if ($null -eq $QaApprovalField -and -not $skipQaApproval) {
    throw "Deployment Task $DeploymentTaskKey is NOT QA Approved"
}

# Stakeholder Approval
$StakeholderApprovalField = $DeploymentTask.fields.customfield_11506

$IssueType = $DeploymentTask.fields.issuetype.name

if ($deploymentTaskCanBeSubtask -And $IssueType -eq "Deployment Sub-Task") {

    $ParentTicketUri = $DeploymentTask.fields.parent.self

    $ParentTicket = Invoke-RestMethod -Method Get -Uri $ParentTicketUri

    $StakeholderApprovalField = $ParentTicket.fields.customfield_11506
}

if ($null -eq $StakeholderApprovalField) {
    throw "Deployment Task $DeploymentTaskKey is NOT Stakeholder Approved"
}
else {
    Write-Output "Deployment Task $DeploymentTaskKey has been Technical Approved, QA Approved, and Stakeholder Approved"
}