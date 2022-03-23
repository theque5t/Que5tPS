function Get-CardanoTransactionAllocationValue {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient -or
            $_ -eq $Transaction.ChangeAllocation.Recipient
        })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$PolicyId,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $allocation = Get-CardanoTransactionAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient
    $value = $allocation.Value.Where({
        $_.PolicyId -eq $PolicyId -and
        $_.Name -eq $Name
    })
    return $value
}
