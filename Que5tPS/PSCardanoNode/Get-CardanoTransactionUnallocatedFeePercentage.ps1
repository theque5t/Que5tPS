function Get-CardanoTransactionUnallocatedFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [ValidateSet('String', 'Int')]
        [string]$Transform
    )
    $allocatedFeePercentage = Get-CardanoTransactionAllocatedFeePercentage -Transaction $Transaction
    $unallocatedFeePercentage = ConvertTo-RoundNumber `
        -Number $(1 - $allocatedFeePercentage) `
        -DecimalPlaces 2
    switch ($Transform) {
        'String' { $unallocatedFeePercentage = $unallocatedFeePercentage.ToString('P') }
        'Int'    { $unallocatedFeePercentage = ConvertTo-IntPercentage -Number $unallocatedFeePercentage }
    }
    return $unallocatedFeePercentage
}
