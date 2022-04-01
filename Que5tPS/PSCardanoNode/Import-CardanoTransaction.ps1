function Import-CardanoTransaction {
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
        SignedFile = "$($WorkingDir.FullName)\$Name.tx.signed"
    }
    Import-CardanoTransactionState -Transaction $Transaction
    Import-CardanoTransactionBody -Transaction $Transaction
    Import-CardanoTransactionSigned -Transaction $Transaction
    return $transaction
}
