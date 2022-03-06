function Get-CardanoTransactionChangeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $changeAllocation = [CardanoTransactionAllocation[]]@()
    if($($Transaction | Test-CardanoTransactionHasChangeRecipient) -and 
       $($Transaction | Test-CardanoTransactionHasUnallocatedTokens)){
        $unallocatedTokens = $Transaction | Get-CardanoTransactionUnallocatedTokens
        $changeAllocation += New-CardanoTransactionAllocation `
            -Recipient $Transaction.ChangeRecipient `
            -Value $unallocatedTokens
    }
    return $changeAllocation
}
