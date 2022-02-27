function New-CardanoTransaction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$WorkingDir,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $transaction = [CardanoToken]::new()
    $transaction.WorkingDir = $WorkingDir
    $transaction.StateFile = "$($WorkingDir.FullName)\$Name.state.yaml"
    $transaction.BodyFile = "$($WorkingDir.FullName)\$Name.tx.json"
    if(-not (Test-Path $transaction.StateFile)){ New-Item $transaction.StateFile }
    if(-not (Test-Path $transaction.BodyFile)){ New-Item $transaction.BodyFile }
    $transaction | Import-CardanoTransactionState
    $transaction | Update-CardanoTransactionState
    return $transaction
}
