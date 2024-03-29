function Test-CardanoTransactionAllocationFeeCovered {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient -or
            $_ -eq $Transaction.ChangeAllocation.Recipient
        })]
        [string]$Recipient
    )
    $feeBalance = Get-CardanoTransactionAllocationFundBalance `
        -Transaction $Transaction `
        -Recipient $Recipient
    return $feeBalance -ge 0
}