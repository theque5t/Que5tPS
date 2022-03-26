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
        
        $Transaction.Inputs = [CardanoUtxo[]]@()
        $state.Inputs.ForEach({
            $utxo = New-CardanoUtxo -Id $_.Id -Address $_.Address -Data $_.Data
            $_.Value.GetEnumerator().ForEach({
                Add-CardanoUtxoToken -Utxo $utxo -Token $(
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
            Add-CardanoTransactionAllocation `
                -Transaction $Transaction `
                -Recipient $_.Recipient `
                -Value $_tokens `
                -FeePercentage $(
                    ConvertTo-IntPercentage -Number $_.FeePercentage
                )
        })

        Set-CardanoTransactionChangeAllocation `
            -Transaction $Transaction `
            -Recipient $state.ChangeAllocation.Recipient `
            -FeePercentage $(
                ConvertTo-IntPercentage -Number `
                    $state.ChangeAllocation.FeePercentage
            )
    }
}
