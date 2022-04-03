function Import-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    Assert-CardanoTransactionStateFileExists -Transaction $Transaction
    $Transaction.StateFile = Get-Item $Transaction.StateFile
    $Transaction.StateFileContent = Get-Content $Transaction.StateFile
    if($Transaction.StateFileContent){
        $state = Get-Content $Transaction.StateFile | ConvertFrom-Yaml
        $state.Inputs = [array]$state.Inputs
        $state.Allocations = [array]$state.Allocations
        
        Set-CardanoTransactionWitnessQuantity `
            -Transaction $Transaction `
            -Quantity $state.WitnessQuantity

        $Transaction.Inputs = [CardanoUtxo[]]@()
        $state.Inputs.ForEach({
            $utxo = New-CardanoUtxo -Id $_.Id -Address $_.Address -Data $_.Data
            $_.Value.GetEnumerator().ForEach({
                Add-CardanoUtxoToken `
                    -Utxo $utxo `
                    -Token $(
                        New-CardanoToken `
                            -PolicyId $_.PolicyId `
                            -Name $_.Name `
                            -Quantity $_.Quantity
                    ) `
                    -UpdateState $False
            })
            Add-CardanoTransactionInput `
                -Transaction $Transaction `
                -Utxo $utxo `
                -UpdateState $False
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
            Add-CardanoTransactionAllocation `
                -Transaction $Transaction `
                -Recipient $_.Recipient `
                -Value $_tokens `
                -FeePercentage $(
                    ConvertTo-IntPercentage -Number $_.FeePercentage
                ) `
                -UpdateState $False
        })

        Set-CardanoTransactionChangeAllocation `
            -Transaction $Transaction `
            -Recipient $state.ChangeAllocation.Recipient `
            -FeePercentage $(
                ConvertTo-IntPercentage -Number `
                    $state.ChangeAllocation.FeePercentage
            ) `
            -UpdateState $False

        $Transaction.Fee = $state.Fee
        $Transaction.SignedStateHash = $state.SignedStateHash
    }
}
