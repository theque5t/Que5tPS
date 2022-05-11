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
    [Int64]$SupplyLimit # SupplyLimit is static, supply is dynamic
    # See: https://developers.cardano.org/docs/native-tokens/minting-nfts#metadata-attributes
    $MetaData # Stores value of "policy_name" key below
    # {
    #     "721": {
    #       "{policy_id}": {
    #         "{policy_name}": {
    #           "name": "<required>",
    #           "description": "<optional>",
    #           "sha256": "<required>",
    #           "type": "<required>",
    #           "image": "<required>",
    #           "location": {
    #             "ipfs": "<required>",
    #             "https": "<optional>",
    #             "arweave": "<optional>"
    #           }
    #         }
    #       }
    #     }
    # }
}

class CardanoTokenImplementation {
    [Int64]$Minted #
    [Int64]$Burned # # Both are used to calculate supply
}

class CardanoMintContract {
    [System.IO.DirectoryInfo]$WorkingDir
    $MintContractDir
    [string]$Name
    [string]$Description
    [string]$Network
    [string[]]$Witnesses # hash1, hash2
    [Int64]$WitnessesRequired # 1, 2, 3
    [int64]$TimeLockAfterSlot # 1000
    [int64]$TimeLockBeforeSlot # 1100
    [CardanoTokenSpecification[]]$TokenSpecifications
    [CardanoTokenImplementation[]]$TokenImplementations
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


