function Get-CardanoTransactionUnallocatedFee {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [switch]$Token
    )
    $minimumFee = $Transaction | Get-CardanoTransactionMinimumFee
    $unallocatedFeePercentage = $Transaction | Get-CardanoTransactionUnallocatedFeePercentage
    $unallocatedFee = $minimumFee * $unallocatedFeePercentage
    if($Token){
        $unallocatedFee = New-CardanoToken `
            -PolicyId '' `
            -Name 'lovelace' `
            -Quantity $allocatedFee
    }
    return $unallocatedFee
}
