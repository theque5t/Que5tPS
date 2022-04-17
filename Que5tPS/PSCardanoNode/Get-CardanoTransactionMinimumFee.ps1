function Get-CardanoTransactionMinimumFee {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [switch]$Token    
    )
    $MinimumFee = 0
    if($(Test-CardanoTransactionIsReadOnly -Transaction $Transaction)){
        $MinimumFee = $Transaction.Fee
    }
    elseif($(Test-CardanoTransactionHasInputs -Transaction $Transaction)){
        $network = Get-CardanoTransactionNetwork -Transaction $Transaction
        Assert-CardanoNodeInSync -Network $network
        Export-CardanoTransactionBody -Transaction $Transaction -Fee 0
        $socket = Get-CardanoNodeSocket -Network $network
        $nodePath = Get-CardanoNodePath -Network $network
        $protocolParams = Get-CardanoNodeProtocolParameters -Network $network
        $networkArgs = Get-CardanoNodeNetworkArg -Network $network
        $_args = @(
            'transaction', 'calculate-min-fee'
            '--tx-body-file', $Transaction.BodyFile.FullName
            '--tx-in-count', $(Get-CardanoTransactionInputsQuantity -Transaction $Transaction)
            '--tx-out-count', $(Get-CardanoTransactionOutputsQuantity -Transaction $Transaction -Fee 0)
            '--witness-count', $(Get-CardanoTransactionWitnessQuantity -Transaction $Transaction)
            '--protocol-params-file', $protocolParams
            $networkArgs
        )
        $MinimumFee = Invoke-CardanoCLI `
            -Socket $socket `
            -Path $nodePath `
            -Arguments $_args
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