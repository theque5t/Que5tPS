function Get-CardanoTransactionAllocationFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient 
        })]
        [string]$Recipient,
        [ValidateSet('String', 'Int')]
        [string]$Transform
    )
    $allocation = Get-CardanoTransactionAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient
    $allocationFeePercentage = $allocation.FeePercentage
    switch ($Transform) {
        'String' { $allocationFeePercentage = $allocationFeePercentage.ToString('P') }
        'Int'    { $allocationFeePercentage = $allocationFeePercentage * 100 }
    }
    return $allocationFeePercentage
}
