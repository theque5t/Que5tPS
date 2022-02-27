function Import-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
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
            $utxo = [CardanoUtxo]::new($_.Id, $_.Address, $_.Data)
            $_.Value.GetEnumerator().ForEach({
                $utxo | Add-CardanoUtxoToken $_.PolicyId $_.Name $_.Quantity
            })
            $Transaction | Add-CardanoTransactionInput $utxo
        })
        
        $Transaction.Allocations = [CardanoTransactionAllocation[]]@()
        $state.Allocations.ForEach({
            $_tokens = [CardanoToken[]]@()
            $_.Value.GetEnumerator().ForEach({
                $_tokens += ([CardanoToken]::new($_.PolicyId, $_.Name, $_.Quantity))
            })
            $allocation = [CardanoTransactionAllocation]::new($_.Recipient, $_tokens)
            $Transaction | Add-CardanoTransactionAllocation $allocation
        })

        $Transaction | Set-CardanoTransactionChangeRecipient $state.ChangeRecipient

        $Transaction | Update-CardanoTransactionBody
    }
}
