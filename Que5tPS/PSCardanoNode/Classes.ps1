class CardanoToken {
    [string]$PolicyId
    [string]$Name
    [Int64]$Quantity
}

class CardanoUtxo {
    [string]$Id
    [string]$TxHash
    [Int64]$Index
    [CardanoToken[]]$Value
    [string]$Address
    [string]$Data

    [void]AddToken($_policyId, $_name, $_quantity){
        $this | Add-CardanoUtxoToken $_policyId $_name $_quantity
    }
}

class CardanoTransactionAllocation {
    [string]$Recipient
    [CardanoToken[]]$Value
}

class CardanoTransactionOutput {
    [string]$Address
    [CardanoToken[]]$Value
}

class CardanoTransaction {
    [System.IO.DirectoryInfo]$WorkingDir
    $StateFile
    $BodyFile
    $BodyFileContent
    $BodyFileObject
    $BodyFileView
    $BodyFileViewObject
    [CardanoUtxo[]]$Inputs
    [CardanoTransactionAllocation[]]$Allocations
    [string]$ChangeRecipient

    [void]ImportState(){
        $this | Import-CardanoTransactionState
    }

    [void]ExportState(){
        $this | Export-CardanoTransactionState
    }

    [void]UpdateState(){
        $this | Update-CardanoTransactionState
    }

    [void]ImportBody(){
        $this | Import-CardanoTransactionBody
    }

    [void]ExportBody([Int64]$Fee){
        $this | Export-CardanoTransactionBody $Fee
    }

    [void]ExportBody(){
        $this | Export-CardanoTransactionBody -Fee 0
    }

    [void]UpdateBody([Int64]$Fee){
        $this | Update-CardanoTransactionBody $Fee
    }
    
    [void]UpdateBody(){
        $this | Update-CardanoTransactionBody -Fee 0
    }

    [void] AddInput([CardanoUtxo]$Utxo){ 
        $this | Add-CardanoTransactionInput $Utxo
    }

    [void] RemoveInput([string]$Id){
        $this | Remove-CardanoTransactionInput $Id
    }

    [void] AddAllocation([CardanoTransactionAllocation]$Allocation){
        $this | Add-CardanoTransactionAllocation $Allocation
    }

    [void] RemoveAllocation([string]$Recipient){ 
        $this | Remove-CardanoTransactionAllocation $Recipient
    }

    [void] FormatTransactionSummary(){
        Format-CardanoTransactionSummary $this
    }

    [void] Minting(){
        Write-Host TODO
    }

    [CardanoUtxo[]]GetInputs(){
        return $this | Get-CardanoTransactionInputs
    }

    [CardanoToken[]] GetInputTokens(){
        return $this | Get-CardanoTransactionInputTokens
    }

    [bool] HasInputs(){
        return [bool]$($this | Get-CardanoTransactionInputs).Count
    }

    [CardanoTransactionAllocation[]] GetAllocations(){
        return $this | Get-CardanoTransactionAllocations
    }

    [CardanoToken[]] GetAllocatedTokens(){
        return $this | Get-CardanoTransactionAllocatedTokens
    }

    [bool] HasAllocations(){
        return [bool]$($this | Get-CardanoTransactionAllocations).Count
    }

    [bool] HasAllocatedTokens(){
        return [bool]$($this | Get-CardanoTransactionAllocatedTokens).Count
    }

    [CardanoToken[]] GetTokenBalances(){
        return $this | Get-CardanoTransactionTokenBalances
    }

    [CardanoToken[]] GetUnallocatedTokens(){
        return $this | Get-CardanoTransactionUnallocatedTokens
    }

    [bool] HasUnallocatedTokens(){
        return [bool]$($this | Get-CardanoTransactionUnallocatedTokens).Count
    }

    [string] GetChangeRecipient(){
        return $this | Get-CardanoTransactionChangeRecipient
    }

    [void] SetChangeRecipient([string]$Recipient){
        $this | Set-CardanoTransactionChangeRecipient $Recipient
    }

    [void] ClearChangeRecipient(){
        $this | Clear-CardanoTransactionChangeRecipient
    }

    [bool] HasChangeRecipient(){
        return [bool]$($this | Get-CardanoTransactionChangeRecipient).Count
    }

    [CardanoTransactionAllocation[]] GetChangeAllocation(){
        return $this | Get-CardanoTransactionChangeAllocation
    }

    [bool] HasChangeAllocation(){
        return [bool]$($this | Get-CardanoTransactionChangeAllocation).Count
    }

    [CardanoTransactionOutput[]]GetOutputs(){
        return $this | Get-CardanoTransactionOutputs
    }

    [CardanoToken[]] GetOutputTokens(){
        return $this | Get-CardanoTransactionOutputTokens
    }

    [bool] HasOutputs(){
        return [bool]$($this | Get-CardanoTransactionOutputs).Count
    }

    [string[]]GetWitnesses(){
        return $this | Get-CardanoTransactionWitnesses
    }

    [System.Object]GetMinimumFee(){
       return $this | Get-CardanoTransactionMinimumFee
    }

    [bool] IsBalanced(){ 
        $outputTokens = $this | Get-CardanoTransactionOutputTokens
        $outputTokens.ForEach({ $_.Quantity = -$_.Quantity })
        $inputTokens = $this | Get-CardanoTransactionInputTokens
        $inputOutputTokensDifference = $(
            Merge-CardanoTokens $($inputTokens + $outputTokens 
        )).Where({ $_.Quantity -gt 0 }).Count
        return -not $inputOutputTokensDifference
    }

    [bool] IsSigned(){ return $false }

    [bool] IsSubmitted(){ return $false }

    [void] SetInteractively(){
        $this | Set-CardanoTransaction -Interactive
    }
}


