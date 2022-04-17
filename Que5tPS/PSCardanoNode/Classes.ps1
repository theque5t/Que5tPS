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

class CardanoTransactionChangeAllocation {
    [string]$Recipient
    [float]$FeePercentage
}

class CardanoTransactionOutput {
    [string]$Address
    [CardanoToken[]]$Value
}

class CardanoTransaction {
    [System.IO.DirectoryInfo]$WorkingDir
    [string]$Name
    [string]$Network
    $BodyFile
    $BodyFileContent
    $BodyFileObject
    $BodyFileView
    $BodyFileViewObject
    $SignedStateHash
    $SignedFile
    $SignedFileContent
    $SignedFileObject
    $SignedFileView
    $SignedFileViewObject
    $StateFile
    $StateFileContent
    [CardanoUtxo[]]$Inputs
    [CardanoTransactionAllocation[]]$Allocations
    [CardanoTransactionChangeAllocation]$ChangeAllocation
    [Int64]$Fee
    [Int64]$WitnessQuantity
    [bool]$Submitted
}


