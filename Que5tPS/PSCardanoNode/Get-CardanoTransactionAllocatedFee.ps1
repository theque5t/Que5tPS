function Get-CardanoTransactionAllocatedFee {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [switch]$Token
    )
    $minimumFee = Get-CardanoTransactionMinimumFee -Transaction $Transaction
    $allocatedFeePercentage = Get-CardanoTransactionAllocatedFeePercentage -Transaction $Transaction
    $allocatedFee = $minimumFee * $allocatedFeePercentage
    if($Token){
        $allocatedFee = New-CardanoToken `
            -PolicyId '' `
            -Name 'lovelace' `
            -Quantity $allocatedFee
    }
    return $allocatedFee
}
