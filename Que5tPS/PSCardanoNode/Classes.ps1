class CardanoScriptBlock {
    [string]$Key
    [string]$Value
}

class CardanoScript {
    [CardanoScriptBlock[]]$Scripts
    [string]$Type
}

class CardanoPolicy {
    [string]$Id
    [CardanoScript]$Script
}

class CardanoToken {
    [string]$PolicyId
    [string]$Name
    [Int64]$Quantity
}

class CardanoTokenSpecification {
    [string]$Name
    [Int64]$Supply
}

class CardanoMintContract {
    [System.IO.DirectoryInfo]$WorkingDir
    $MintContractDir
    [string]$Name
    [string]$Description
    [string]$Network
    [string[]]$Witnesses
    [CardanoTokenSpecification[]]$TokenSpecs
    $StateFile
    $StateFileContent
}

class CardanoMintAction {

}

class CardanoUtxo {
    [string]$Id
    [string]$TxHash
    [Int64]$Index
    [CardanoToken[]]$Value
    [string]$Address
    [string]$Data
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
    $TransactionDir
    [string]$Name
    [string]$Description
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
    [CardanoMintAction[]]$Mint
    [CardanoMintAction[]]$Burn
    [CardanoUtxo[]]$Inputs
    [CardanoTransactionAllocation[]]$Allocations
    [CardanoTransactionChangeAllocation]$ChangeAllocation
    [Int64]$Fee
    [Int64]$WitnessQuantity
    [bool]$Submitted
}


