class CardanoWalletKeyPair {
    [string]$Name
    [string]$Description
    [string]$VerificationKey
    [string]$SigningKey
}

class CardanoWalletAddress {
    [string]$Name
    [string]$Description
    [string]$Hash
    [string]$KeyPairName
}

class CardanoWallet {
    [System.IO.DirectoryInfo]$WorkingDir
    $WalletDir
    $TransactionsDir
    [string]$Name
    [string]$Description
    [string]$Network
    [CardanoWalletKeyPair[]]$KeyPairs
    [CardanoWalletAddress[]]$Addresses
    $StateFile
    $StateFileContent
}
