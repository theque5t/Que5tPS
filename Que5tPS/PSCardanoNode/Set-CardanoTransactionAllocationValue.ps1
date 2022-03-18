function Set-CardanoTransactionAllocationValue {
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
        [AllowEmptyString()]
        [string]$PolicyId,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [string]$Quantity
    )
    $($Transaction.Allocations.Where({
        $_.Recipient -eq $Recipient
    }).Value.Where({
        $_.PolicyId -eq $PolicyId -and
        $_.Name -eq $Name
    })).Quantity = $Quantity
}
