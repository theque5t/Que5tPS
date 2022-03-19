function Get-CardanoTransactionUnallocatedFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [ValidateSet('String', 'Int')]
        [string]$Transform
    )
    $allocatedFeePercentage = Get-CardanoTransactionAllocatedFeePercentage -Transaction $Transaction
    $unallocatedFeePercentage = 1 - $allocatedFeePercentage
    switch ($Transform) {
        'String' { $unallocatedFeePercentage = $unallocatedFeePercentage.ToString('P') }
        'Int'    { $unallocatedFeePercentage = $unallocatedFeePercentage * 100 }
    }
    return $unallocatedFeePercentage
}
