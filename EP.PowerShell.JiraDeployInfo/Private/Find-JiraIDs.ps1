function Find-JiraIDs {
    param (
        $message
    )
    $pattern = '[A-Z]{2,}+-\d{1,10}'
    $values = [regex]::Matches($message, $pattern) | Select-Object value 
    Write-Debug ("[JIRA IDs] " + $values)
    $values
}
