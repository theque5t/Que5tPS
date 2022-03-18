function Import-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    Assert-CardanoTransactionStateFileExists -Transaction $Transaction
    $Transaction.StateFile = Get-Item $Transaction.StateFile
    if($Transaction.StateFile.Length -gt 0){
        $state = Get-Content $Transaction.StateFile | ConvertFrom-Yaml
        $state.Inputs = [array]$state.Inputs
        $state.Allocations = [array]$state.Allocations
        $state.FeeAllocations = [array]$state.FeeAllocations
        
        $Transaction.Inputs = [CardanoUtxo[]]@()
        $state.Inputs.ForEach({
            $utxo = New-CardanoUtxo -Id $_.Id -Address $_.Address -Data $_.Data
            $_.Value.GetEnumerator().ForEach({
                $utxo | Add-CardanoUtxoToken -Token $(
                    New-CardanoToken `
                        -PolicyId $_.PolicyId `
                        -Name $_.Name `
                        -Quantity $_.Quantity
                )
            })
            Add-CardanoTransactionInput -Transaction $Transaction -Utxo $utxo
        })
        
        $Transaction.Allocations = [CardanoTransactionAllocation[]]@()
        $state.Allocations.ForEach({
            $_tokens = [CardanoToken[]]@()
            $_.Value.GetEnumerator().ForEach({
                $_tokens += New-CardanoToken `
                    -PolicyId $_.PolicyId `
                    -Name $_.Name `
                    -Quantity $_.Quantity
            })
            $allocation = New-CardanoTransactionAllocation `
                -Recipient $_.Recipient `
                -Value $_tokens
            Add-CardanoTransactionAllocation -Transaction $Transaction `
                -Allocation $allocation
        })

        $Transaction.FeeAllocations = [CardanoTransactionFeeAllocation[]]@()
        $state.FeeAllocations.ForEach({
            $feeAllocation = New-CardanoTransactionFeeAllocation `
                -Recipient $_.Recipient `
                -Percentage $_.Percentage
            Add-CardanoTransactionFeeAllocation -Transaction $Transaction `
                -FeeAllocation $feeAllocation
        })

        if($state.ChangeRecipient){
            Set-CardanoTransactionChangeRecipient -Transaction $Transaction `
                -Recipient $state.ChangeRecipient
        }
    }
}
