function Get-CardanoTransactionMinimumFee {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $MinimumFee = $null
        if($Transaction.HasInputs()){
            Assert-CardanoNodeInSync
            $Transaction | Export-CardanoTransactionBody -Fee 0
            $_args = @(
                'transaction', 'calculate-min-fee'
                '--tx-body-file', $Transaction.BodyFile.FullName
                '--tx-in-count', $(Get-CardanoTransactionInputs $Transaction).Count
                '--tx-out-count', $(Get-CardanoTransactionOutputs $Transaction).Count
                '--witness-count', $(Get-CardanoTransactionWitnesses $Transaction).Count
                '--protocol-params-file', $env:CARDANO_NODE_PROTOCOL_PARAMETERS
                $env:CARDANO_CLI_NETWORK_ARG, $env:CARDANO_CLI_NETWORK_ARG_VALUE
            )
            $MinimumFee = Invoke-CardanoCLI @_args
            $MinimumFee = [Int64]$MinimumFee.TrimEnd(' Lovelace')
        }
    return $MinimumFee
}