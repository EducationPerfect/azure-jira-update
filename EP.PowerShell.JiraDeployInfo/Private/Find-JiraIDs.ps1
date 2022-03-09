function Find-JiraIDs {
    param (
        $message
    )

    Write-Verbose ("Message being parsed for ids:" + ($message | ConvertTo-Json -Depth 100))

    $pattern = '\w{2,10}-\d{1,4}'
    $values = [regex]::Matches($message, $pattern) | Select-Object value 
    Write-Verbose ("[JIRA IDs] " + $values)
    $values
}
