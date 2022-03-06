function Get-CardanoTransactionMinimumFee {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $MinimumFee = $null
        if($($Transaction | Test-CardanoTransactionHasInputs)){
            Assert-CardanoNodeInSync
            $Transaction | Export-CardanoTransactionBody -Fee 0
            $_args = @(
                'transaction', 'calculate-min-fee'
                '--tx-body-file', $Transaction.BodyFile.FullName
                '--tx-in-count', $($Transaction | Get-CardanoTransactionInputs).Count
                '--tx-out-count', $($Transaction | Get-CardanoTransactionOutputs).Count
                '--witness-count', $($Transaction | Get-CardanoTransactionWitnesses).Count
                '--protocol-params-file', $env:CARDANO_NODE_PROTOCOL_PARAMETERS
                $env:CARDANO_CLI_NETWORK_ARG, $env:CARDANO_CLI_NETWORK_ARG_VALUE
            )
            $MinimumFee = Invoke-CardanoCLI @_args
            $MinimumFee = [Int64]$MinimumFee.TrimEnd(' Lovelace')
        }
    return $MinimumFee
}