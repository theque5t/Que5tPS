function Get-CardanoTransactionMinimumFee {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [switch]$Token    
    )
    $MinimumFee = 0
    if($(Test-CardanoTransactionHasInputs -Transaction $Transaction)){
        Assert-CardanoNodeInSync
        Export-CardanoTransactionBody -Transaction $Transaction -Fee 0
        $_args = @(
            'transaction', 'calculate-min-fee'
            '--tx-body-file', $Transaction.BodyFile.FullName
            '--tx-in-count', $(Get-CardanoTransactionInputs -Transaction $Transaction).Count
            '--tx-out-count', $(Get-CardanoTransactionOutputs -Transaction $Transaction -Fee 0).Count
            '--witness-count', $(Get-CardanoTransactionWitnesses -Transaction $Transaction).Count
            '--protocol-params-file', $env:CARDANO_NODE_PROTOCOL_PARAMETERS
            $env:CARDANO_CLI_NETWORK_ARG, $env:CARDANO_CLI_NETWORK_ARG_VALUE
        )
        $MinimumFee = Invoke-CardanoCLI @_args
        $MinimumFee = [Int64]$MinimumFee.TrimEnd(' Lovelace')
    }
    if($Token){
        $MinimumFee = New-CardanoToken `
            -PolicyId '' `
            -Name 'lovelace' `
            -Quantity $MinimumFee
    }
    return $MinimumFee
}