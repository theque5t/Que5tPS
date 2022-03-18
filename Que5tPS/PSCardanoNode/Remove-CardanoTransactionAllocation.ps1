function Remove-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient
    )
    $Transaction.Allocations = $Transaction.Allocations.Where({
        $_.Recipient -ne $Recipient
    })
}
