param (
    [string]$jiraDomain,
    [string]$projectsToFilterTicketsBy,
    [string]$fieldsToCheck,
    [string]$jiraTicket,
    [switch]$checkParentTask = $false
)

$Fields = $fieldsToCheck -split "," | ForEach-Object { $_.Trim() }

$JiraTask = $null
$JiraTaskKey = $null

$Uri = "https://$jiraDomain/rest/api/2/search?jql=(project='$projectsToFilterTicketsBy' AND key='$jiraTicket' AND status in ('Deployed', 'Technical Reviewed'))"
$AllPossibleFields = Invoke-RestMethod -Method Get -Uri "https://$jiraDomain/rest/api/2/field"

Write-Output "Generated url to query jira with: $Uri"

$JiraTickets = Invoke-RestMethod -Method Get -Uri $Uri

$JiraTask = $JiraTickets.issues[0]

if ($null -eq $JiraTask) {
    throw "No Jira task found. Check if the Jira task has the status of Deployed or Technical Reviewed"
}

# If multiple issues are found, select the first one
if ($JiraTask.Count -gt 1) {
    $JiraTask = $JiraTask[0]
}

$JiraTaskKey = $JiraTask.key
Write-Output "Found the matching Jira Task $JiraTaskKey"

foreach ($field in $Fields) {
    $FoundField = $AllPossibleFields | Where-Object { $_.id -eq $field }

    if ($null -eq $FoundField) {
        throw "The field id $field is not a valid field id."
    }

    $FieldName = $FoundField.name
    Write-Output "`nChecking Field: $FieldName"

    $FieldValue = $JiraTask.fields.$field

    if ($checkParentTask -And $null -eq $FieldValue) {
        $ParentTicketUri = $JiraTask.fields.parent.self

        $ParentTicket = Invoke-RestMethod -Method Get -Uri $ParentTicketUri

        $FieldValue = $ParentTicket.fields.$field
    }

    if ($null -eq $FieldValue) {
        throw "Jira Task $JiraTaskKey does not have a value for $FieldName"
    }

    Write-Output "$FieldName was provided by $($FieldValue.displayName) on ticket $JiraTaskKey"
}

Write-Output "`nJira Task $JiraTaskKey has all of the specified fields set`n"