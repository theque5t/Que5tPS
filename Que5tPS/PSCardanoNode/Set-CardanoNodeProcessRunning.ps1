function Set-CardanoNodeProcessRunning{
    [CmdletBinding()]
    param()
    if(-not $(Test-CardanoNodeIsRunning)){
        Write-VerboseLog 'Starting Cardano node process...'
        Start-Process `
            -FilePath "$env:DEADALUS_HOME\cardano-launcher.exe" `
            -WorkingDirectory $env:DEADALUS_HOME
        
        while(-not $(Test-CardanoNodeIsRunning)){
            Write-VerboseLog 'Waiting for Cardano node to start...'
            Start-Sleep -Seconds 5
        }

        Write-VerboseLog 'Cardano node process started'
    }
}
