Write-Verbose "PSM1"
$ErrorActionPreference = "Stop"
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

foreach($function in @($Public + $Private))
{
    try
    {
        Write-Verbose "Loading $function"
        . $function.fullname
    }
    catch
    {
        Write-Error -Message "Failed to import function $($function.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename -Verbose