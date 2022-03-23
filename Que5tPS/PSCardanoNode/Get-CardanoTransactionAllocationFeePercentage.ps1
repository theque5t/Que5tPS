function Get-CardanoTransactionAllocationFeePercentage {
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
        [ValidateSet('String', 'Int')]
        [string]$Transform
    )
    $allocation = Get-CardanoTransactionAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient
    $allocationFeePercentage = ConvertTo-RoundNumber `
        -Number $allocation.FeePercentage `
        -DecimalPlaces 2
    switch ($Transform) {
        'String' { $allocationFeePercentage = $allocationFeePercentage.ToString('P') }
        'Int'    { $allocationFeePercentage = $allocationFeePercentage * 100 }
    }
    return $allocationFeePercentage
}
