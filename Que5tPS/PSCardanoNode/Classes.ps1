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
        Add-CardanoUtxoToken -Transaction $this -Token $Token
    }
}

class CardanoTransactionAllocation {
    [string]$Recipient
    [CardanoToken[]]$Value
    [float]$FeePercentage
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
        Import-CardanoTransactionState -Transaction $this
    }

    [void]ExportState(){
        Export-CardanoTransactionState -Transaction $this
    }

    [void]UpdateState(){
        Update-CardanoTransactionState -Transaction $this
    }

    [void]ImportBody(){
        Import-CardanoTransactionBody -Transaction $this
    }

    [void]ExportBody([Int64]$Fee){
        Export-CardanoTransactionBody -Transaction $this -Fee $Fee
    }

    [void]ExportBody(){
        Export-CardanoTransactionBody -Transaction $this -Fee 0
    }

    [void]UpdateBody([Int64]$Fee){
        Update-CardanoTransactionBody -Transaction $this -Fee $Fee
    }
    
    [void]UpdateBody(){
        Update-CardanoTransactionBody -Transaction $this -Fee 0
    }

    [void] AddInput([CardanoUtxo]$Utxo){ 
        Add-CardanoTransactionInput -Transaction $this -Utxo $Utxo
    }

    [void] RemoveInput([string]$Id){
        Remove-CardanoTransactionInput -Transaction $this -Id $Id
    }

    [void] AddAllocation([CardanoTransactionAllocation]$Allocation){
        Add-CardanoTransactionAllocation -Transaction $this -Allocation $Allocation
    }

    [void] RemoveAllocation([string]$Recipient){ 
        Remove-CardanoTransactionAllocation -Transaction $this -Recipient $Recipient
    }

    [void] FormatTransactionSummary(){
        Format-CardanoTransactionSummary -Transaction $this 
    }

    [void] Minting(){
        Write-Host TODO
    }

    [CardanoUtxo[]]GetInputs(){
        return Get-CardanoTransactionInputs -Transaction $this
    }

    [CardanoToken[]] GetInputTokens(){
        return Get-CardanoTransactionInputTokens -Transaction $this
    }

    [bool] HasInputs(){
        return Test-CardanoTransactionHasInputs -Transaction $this
    }

    [CardanoTransactionAllocation[]] GetAllocations([bool]$ChangeAllocation){
        return Get-CardanoTransactionAllocations -Transaction $this `
            -ChangeAllocation:$ChangeAllocation
    }

    [CardanoTransactionAllocation[]] GetAllocations(){
        return $this.GetAllocations($false)
    }

    [CardanoToken[]] GetAllocatedTokens(){
        return Get-CardanoTransactionAllocatedTokens -Transaction $this
    }

    [bool] HasAllocations(){
        return Test-CardanoTransactionHasAllocations -Transaction $this
    }

    [bool] HasAllocatedTokens(){
        return Test-CardanoTransactionHasAllocatedTokens -Transaction $this
    }

    [CardanoToken[]] GetTokenBalances(){
        return Get-CardanoTransactionTokenBalances -Transaction $this
    }

    [CardanoToken[]] GetUnallocatedTokens(){
        return Get-CardanoTransactionUnallocatedTokens -Transaction $this
    }

    [bool] HasUnallocatedTokens(){
        return Test-CardanoTransactionHasUnallocatedTokens -Transaction $this
    }

    [string] GetChangeRecipient(){
        return Get-CardanoTransactionChangeRecipient -Transaction $this
    }

    [void] SetChangeRecipient([string]$Recipient){
        Set-CardanoTransactionChangeRecipient -Transaction $this -Recipient $Recipient
    }

    [void] ClearChangeRecipient(){
        Clear-CardanoTransactionChangeRecipient -Transaction $this
    }

    [bool] HasChangeRecipient(){
        return Test-CardanoTransactionHasChangeRecipient -Transaction $this
    }

    [CardanoTransactionAllocation[]] GetChangeAllocation(){
        return Get-CardanoTransactionChangeAllocation -Transaction $this
    }

    [bool] HasChangeAllocation(){
        return Test-CardanoTransactionHasChangeAllocation -Transaction $this
    }

    [CardanoTransactionOutput[]]GetOutputs(){
        return Get-CardanoTransactionOutputs -Transaction $this
    }

    [CardanoToken[]] GetOutputTokens(){
        return Get-CardanoTransactionOutputTokens -Transaction $this
    }

    [bool] HasOutputs(){
        return Test-CardanoTransactionHasOutputs -Transaction $this
    }

    [string[]]GetWitnesses(){
        return Get-CardanoTransactionWitnesses -Transaction $this
    }

    [System.Object]GetMinimumFee(){
       return Get-CardanoTransactionMinimumFee -Transaction $this
    }

    [bool] IsBalanced(){ 
        return Test-CardanoTransactionIsBalanced -Transaction $this
    }

    [bool] IsSigned(){ 
        return Test-CardanoTransactionIsSigned -Transaction $this
    }

    [bool] IsSubmitted(){ 
        return Test-CardanoTransactionIsSubmitted -Transaction $this
    }

    [void] SetInteractively(){
        Set-CardanoTransaction -Transaction $this -Interactive
    }
}


