function Get-CardanoTransactionMinimumFee{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        $File,
        [Parameter(Mandatory = $true, Position = 1)]
        $InputsCount,
        [Parameter(Mandatory = $true, Position = 2)]
        $OutputsCount,
        [Parameter(Mandatory = $true, Position = 3)]
        $WitnessCount
    )
    $_args = @(
            'transaction', 'calculate-min-fee'
            '--tx-in-count', $InputsCount
            '--tx-out-count', $OutputsCount
            '--witness-count', $WitnessCount
    )
    $mininumFee = Invoke-CardanoCLI @_args
    return $mininumFee
}
