function Test-CardanoTransactionAllocationFeeCovered {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient 
        })]
        [string]$Recipient
    )
    $feeBalance = Get-CardanoTransactionAllocationFeeBalance `
        -Transaction $Transaction `
        -Recipient $Recipient
    return $feeBalance -ge 0
}