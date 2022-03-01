function Get-CardanoTransactionChangeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $changeAllocation = [CardanoTransactionAllocation[]]@()
    if($Transaction.HasChangeRecipient() -and $Transaction.HasUnallocatedTokens()){
        $unallocatedTokens = $Transaction | Get-CardanoTransactionUnallocatedTokens
        $changeAllocation += New-CardanoTransactionAllocation `
            -Recipient $Transaction.ChangeRecipient `
            -Value $unallocatedTokens
    }
    return $changeAllocation
}
