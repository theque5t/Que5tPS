function Get-CardanoTransactionChangeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [switch]$State
    )
    if($State){
        return $Transaction.ChangeAllocation
    }
    else{
        $changeAllocation = [CardanoTransactionAllocation[]]@()
        if($(Test-CardanoTransactionHasChangeAllocationRecipient -Transaction $Transaction) -and 
           $(Test-CardanoTransactionHasUnallocatedTokens -Transaction $Transaction)){
            $unallocatedTokens = Get-CardanoTransactionUnallocatedTokens -Transaction $Transaction
            $changeRecipient = Get-CardanoTransactionChangeAllocationRecipient -Transaction $Transaction
            $changeAllocation += New-CardanoTransactionAllocation `
                -Recipient $changeRecipient `
                -Value $unallocatedTokens
        }
        return $changeAllocation
    }
}
