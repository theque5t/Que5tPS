function New-CardanoTransaction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$WorkingDir,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $transaction = New-Object CardanoTransaction -Property @{
        WorkingDir = $WorkingDir
        StateFile = "$($WorkingDir.FullName)\$Name.state.yaml"
        BodyFile = "$($WorkingDir.FullName)\$Name.tx.json"
    }
    @($transaction.StateFile, $transaction.BodyFile).ForEach({
        if(-not (Test-Path $_)){ New-Item $_ | Out-Null }
    })
    $transaction | Import-CardanoTransactionState
    $transaction | Update-CardanoTransactionState
    return $transaction
}
