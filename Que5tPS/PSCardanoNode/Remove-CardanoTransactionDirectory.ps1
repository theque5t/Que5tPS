function Remove-CardanoTransactionDirectory {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    $transactionDir = Get-CardanoTransactionDirectory -Transaction $Transaction
    $transactionDir | Remove-Item -Recurse -Force
}
