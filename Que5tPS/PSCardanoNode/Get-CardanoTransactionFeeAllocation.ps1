function Get-CardanoTransactionFeeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.FeeAllocations.Recipient 
        })]
        [string]$Recipient
    )
    $feeAllocations = Get-CardanoTransactionFeeAllocations -Transaction $Transaction
    $feeAllocation = $feeAllocations.Where({ $_.Recipient -eq $Recipient })
    return $feeAllocation
}