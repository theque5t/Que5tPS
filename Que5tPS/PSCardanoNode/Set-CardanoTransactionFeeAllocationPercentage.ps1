function Set-CardanoTransactionFeeAllocationPercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.FeeAllocations.Recipient 
        })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -ge 0 -and $_ -le $(Get-CardanoTransactionUnallocatedFeePercentage -Transaction $Transaction) 
        })]
        [int]$Percentage
    )
    $Transaction.FeeAllocations.Where({
        $_.Recipient -eq $Recipient
    }).Percentage = $Percentage / 100
}
