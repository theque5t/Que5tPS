function Get-CardanoWalletToken {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$PolicyId,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $token = Get-CardanoWalletTokens `
        -Wallet $Wallet `
        -Filter Include `
        -PolicyId $PolicyId `
        -Name $Name
    return $token
}
