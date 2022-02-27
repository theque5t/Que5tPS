function Get-CardanoTransactionChangeAllocation {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $changeAllocation = [CardanoTransactionAllocation[]]@()
    if($Transaction.HasChangeRecipient() -and $Transaction.HasUnallocatedTokens()){
        $unallocatedTokens = $Transaction | Get-CardanoTransactionUnallocatedTokens
        $changeAllocation += [CardanoTransactionAllocation]::new(
            $Transaction.ChangeRecipient,
            $unallocatedTokens
        )
    }
    return $changeAllocation
}
