function Close-CardanoWalletSession {
    [CmdletBinding()]
    param()
    Assert-CardanoWalletSessionIsOpen

    Write-VerboseLog 'Closing Cardano wallet session...'

    @('CARDANO_WALLET',
      'CARDANO_WALLET_SESSION'
    ).ForEach({ Remove-Item "env:\$_" })
    
    Assert-CardanoWalletSessionIsClosed
    Write-VerboseLog 'Cardano wallet session closed'
}
