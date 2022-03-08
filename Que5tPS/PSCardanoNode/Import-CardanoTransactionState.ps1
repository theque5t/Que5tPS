function Import-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $Transaction.StateFile = Get-Item $Transaction.StateFile
    $Transaction.BodyFile = Get-Item $Transaction.BodyFile
    if($Transaction.StateFile.Length -gt 0){
        $state = Get-Content $Transaction.StateFile | ConvertFrom-Yaml
        $state.Inputs = [array]$state.Inputs
        $state.Allocations = [array]$state.Allocations
        
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
            $Transaction | Add-CardanoTransactionInput -Utxo $utxo
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
            $Transaction | Add-CardanoTransactionAllocation `
                -Allocation $allocation
        })

        if($state.ChangeRecipient){
            $Transaction | Set-CardanoTransactionChangeRecipient `
                -Recipient $state.ChangeRecipient
        }

        $Transaction | Update-CardanoTransactionBody
    }
}
