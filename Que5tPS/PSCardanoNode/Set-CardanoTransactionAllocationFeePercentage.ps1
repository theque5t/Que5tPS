function Set-CardanoTransactionAllocationFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient 
        })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_percentage = $_/100
            $_percentage -ge 0 -and 
            $_percentage -le $(Get-CardanoTransactionUnallocatedFeePercentage -Transaction $Transaction) 
        })]
        [int]$FeePercentage
    )
    $($Transaction.Allocations.Where({
        $_.Recipient -eq $Recipient
    })).FeePercentage = $FeePercentage / 100
}
