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

    [void]AddToken([CardanoToken]$Token){
        $this | Add-CardanoUtxoToken -Token $Token
    }
}

class CardanoTransactionAllocation {
    [string]$Recipient
    [CardanoToken[]]$Value
}

class CardanoTransactionFeeAllocation {
    [string]$Recipient
    [int]$Percentage
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
    [CardanoTransactionFeeAllocation[]]$FeeAllocations
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
        $this | Export-CardanoTransactionBody -Fee $Fee
    }

    [void]ExportBody(){
        $this | Export-CardanoTransactionBody -Fee 0
    }

    [void]UpdateBody([Int64]$Fee){
        $this | Update-CardanoTransactionBody -Fee $Fee
    }
    
    [void]UpdateBody(){
        $this | Update-CardanoTransactionBody -Fee 0
    }

    [void] AddInput([CardanoUtxo]$Utxo){ 
        $this | Add-CardanoTransactionInput -Utxo $Utxo
    }

    [void] RemoveInput([string]$Id){
        $this | Remove-CardanoTransactionInput -Id $Id
    }

    [void] AddAllocation([CardanoTransactionAllocation]$Allocation){
        $this | Add-CardanoTransactionAllocation -Allocation $Allocation
    }

    [void] RemoveAllocation([string]$Recipient){ 
        $this | Remove-CardanoTransactionAllocation -Recipient $Recipient
    }

    [void] FormatTransactionSummary(){
        $this | Format-CardanoTransactionSummary 
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
        return $this | Test-CardanoTransactionHasInputs
    }

    [CardanoTransactionAllocation[]] GetAllocations([bool]$ChangeAllocation){
        return $this | Get-CardanoTransactionAllocations `
            -ChangeAllocation:$ChangeAllocation
    }

    [CardanoTransactionAllocation[]] GetAllocations(){
        return $this.GetAllocations($false)
    }

    [CardanoToken[]] GetAllocatedTokens(){
        return $this | Get-CardanoTransactionAllocatedTokens
    }

    [bool] HasAllocations(){
        return $this | Test-CardanoTransactionHasAllocations
    }

    [bool] HasAllocatedTokens(){
        return $this | Test-CardanoTransactionHasAllocatedTokens
    }

    [CardanoToken[]] GetTokenBalances(){
        return $this | Get-CardanoTransactionTokenBalances
    }

    [CardanoToken[]] GetUnallocatedTokens(){
        return $this | Get-CardanoTransactionUnallocatedTokens
    }

    [bool] HasUnallocatedTokens(){
        return $this | Test-CardanoTransactionHasUnallocatedTokens
    }

    [string] GetChangeRecipient(){
        return $this | Get-CardanoTransactionChangeRecipient
    }

    [void] SetChangeRecipient([string]$Recipient){
        $this | Set-CardanoTransactionChangeRecipient -Recipient $Recipient
    }

    [void] ClearChangeRecipient(){
        $this | Clear-CardanoTransactionChangeRecipient
    }

    [bool] HasChangeRecipient(){
        return $this | Test-CardanoTransactionHasChangeRecipient
    }

    [CardanoTransactionAllocation[]] GetChangeAllocation(){
        return $this | Get-CardanoTransactionChangeAllocation
    }

    [bool] HasChangeAllocation(){
        return $this | Test-CardanoTransactionHasChangeAllocation
    }

    [CardanoTransactionOutput[]]GetOutputs(){
        return $this | Get-CardanoTransactionOutputs
    }

    [CardanoToken[]] GetOutputTokens(){
        return $this | Get-CardanoTransactionOutputTokens
    }

    [bool] HasOutputs(){
        return $this | Test-CardanoTransactionHasOutputs
    }

    [string[]]GetWitnesses(){
        return $this | Get-CardanoTransactionWitnesses
    }

    [System.Object]GetMinimumFee(){
       return $this | Get-CardanoTransactionMinimumFee
    }

    [bool] IsBalanced(){ 
        return $this | Test-CardanoTransactionIsBalanced
    }

    [bool] IsSigned(){ 
        return $this | Test-CardanoTransactionIsSigned
    }

    [bool] IsSubmitted(){ 
        return $this | Test-CardanoTransactionIsSubmitted
    }

    [void] SetInteractively(){
        $this | Set-CardanoTransaction -Interactive
    }
}


