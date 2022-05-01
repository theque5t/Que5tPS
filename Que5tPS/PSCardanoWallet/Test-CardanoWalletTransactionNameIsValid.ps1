function Test-CardanoWalletTransactionNameIsValid {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $validSyntax = $Name -match '^[a-zA-Z0-9]+$'
    $nameExists = Test-CardanoWalletTransactionNameExists -Wallet $Wallet -Name $Name
    return $validSyntax -and -not $nameExists
}
