function Get-CardanoNodeProcess {
    $process = $(Get-Process -Verbose:$false).Where({ 
        $_.Name -eq 'cardano-node' -and
        $_.Path -eq "$env:DEADALUS_HOME\cardano-node.exe"
    })

    return $process
}
