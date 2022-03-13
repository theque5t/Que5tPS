function Get-CardanoTransactionAllocatedFee {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [switch]$Token
    )
    $minimumFee = $Transaction | Get-CardanoTransactionMinimumFee
    $allocatedFeePercentage = $Transaction | Get-CardanoTransactionAllocatedFeePercentage
    $allocatedFee = $minimumFee * $allocatedFeePercentage
    if($Token){
        $allocatedFee = New-CardanoToken `
            -PolicyId '' `
            -Name 'lovelace' `
            -Quantity $allocatedFee
    }
    return $allocatedFee
}
