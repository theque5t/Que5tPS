function Get-CardanoTransactionChangeAllocationFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [ValidateSet('String', 'Int')]
        [string]$Transform   
    )
    $changeAllocationFeePercentage = ConvertTo-RoundNumber `
        -Number $Transaction.ChangeAllocation.FeePercentage `
        -DecimalPlaces 2
    switch ($Transform) {
        'String' { $changeAllocationFeePercentage = $changeAllocationFeePercentage.ToString('P') }
        'Int'    { $changeAllocationFeePercentage = $changeAllocationFeePercentage * 100 }
    }
    return $changeAllocationFeePercentage
}
