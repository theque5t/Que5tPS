function Set-CardanoNodeProcessStopped{
    [CmdletBinding()]
    param()
    if($(Test-CardanoNodeIsRunning)){
        Write-VerboseLog 'Stopping Cardano node process...'
        Get-DeadalusProcess | Stop-Process
        Write-VerboseLog 'Cardano node process stopped'
    }   
}
