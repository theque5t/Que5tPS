function Get-CardanoWalletTokens {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(ParameterSetName = 'Filter')]
        [ValidateSet('Include','Exclude')]
        [string]$Filter,
        [Parameter(ParameterSetName = 'Filter')]
        [AllowEmptyString()]
        [string]$PolicyId,
        [Parameter(ParameterSetName = 'Filter')]
        [string]$Name
    )
    $utxos = Get-CardanoWalletUtxos -Wallet $Wallet
    $tokens = Merge-CardanoTokens -Tokens $utxos.Value
    switch($Filter){
        'Include'{
            $tokens = $tokens.Where({
                $_.PolicyId -eq $PolicyId -and
                $_.Name -eq $Name
            })
        }
        'Exclude'{
            $tokens = $tokens.Where({
                $_.PolicyId -ne $PolicyId -and
                $_.Name -ne $Name
            })
        }
    }
    return $tokens
}
