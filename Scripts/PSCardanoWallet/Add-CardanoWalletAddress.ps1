function Add-CardanoWalletAddress {
    Assert-CardanoWalletSessionIsOpen
    Write-VerboseLog "Generating wallet address..."

    $walletPath = $(Get-CardanoWallet).FullName
    $walletAddresses = "$walletPath\addresses"
    $walletConfig = Get-CardanoWalletConfig
    $walletAddress = (
        "$walletAddresses\" +
        "$env:CARDANO_NODE_NETWORK$($walletConfig.nextAddressIndex).addr"
    )
    $walletVerificationKey = Get-CardanoWalletKeyFile -Type verification
    $_args = @(
        'address','build'
        '--payment-verification-key-file', $walletVerificationKey
        '--out-file', $walletAddress
        $env:CARDANO_CLI_NETWORK_ARG
        $env:CARDANO_CLI_NETWORK_ARG_VALUE
    )
    Invoke-CardanoCLI @_args

    Set-CardanoWalletConfigKey `
        -Key nextAddressIndex `
        -Value $([int]$($walletConfig.nextAddressIndex)+1)
}
