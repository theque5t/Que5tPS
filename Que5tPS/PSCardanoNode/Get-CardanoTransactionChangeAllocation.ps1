function Get-CardanoTransactionChangeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $changeAllocation = [CardanoTransactionAllocation[]]@()
    if($(Test-CardanoTransactionHasChangeRecipient -Transaction $Transaction) -and 
       $(Test-CardanoTransactionHasUnallocatedTokens -Transaction $Transaction)){
        $unallocatedTokens = Get-CardanoTransactionUnallocatedTokens -Transaction $Transaction
        $changeAllocation += New-CardanoTransactionAllocation `
            -Recipient $Transaction.ChangeRecipient `
            -Value $unallocatedTokens
    }
    return $changeAllocation
}
