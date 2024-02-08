function Find-JiraIDs {
    param (
        $message
    )
    $pattern = '\b[A-Za-z][A-Za-z0-9_]+-[1-9][0-9]*\b'
    $values = [regex]::Matches($message, $pattern) | Select-Object value 
    Write-Debug ("[JIRA IDs] " + $values)
    $values
}
