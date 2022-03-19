function Get-CardanoTransactionAllocation {
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
    $allocations = Get-CardanoTransactionAllocations -Transaction $Transaction -ChangeAllocation
    $allocation = $allocations.Where({ $_.Recipient -eq $Recipient })
    return $allocation
}
