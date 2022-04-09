function Update-CardanoTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = $(Get-CardanoTransactionMinimumFee -Transaction $Transaction),
        [securestring[]]$SigningKeys,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    Update-CardanoTransactionState -Transaction $Transaction
    Update-CardanoTransactionBody -Transaction $Transaction -Fee $Fee
    Update-CardanoTransactionSigned -Transaction $Transaction -SigningKeys $SigningKeys
}
