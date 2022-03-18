function Get-CardanoTransactionUnallocatedFee {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [switch]$Token
    )
    $minimumFee = Get-CardanoTransactionMinimumFee -Transaction $Transaction
    $unallocatedFeePercentage = Get-CardanoTransactionUnallocatedFeePercentage -Transaction $Transaction
    $unallocatedFee = $minimumFee * $unallocatedFeePercentage
    if($Token){
        $unallocatedFee = New-CardanoToken `
            -PolicyId '' `
            -Name 'lovelace' `
            -Quantity $allocatedFee
    }
    return $unallocatedFee
}
