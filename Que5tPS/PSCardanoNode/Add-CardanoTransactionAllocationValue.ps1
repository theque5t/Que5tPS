function Add-CardanoTransactionAllocationValue {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient 
        })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [string]$PolicyId,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [string]$Quantity
    )
    $Transaction.Allocations.Where({
        $_.Recipient -ne $Recipient
    }).Value += New-CardanoToken `
        -PolicyId $PolicyId `
        -Name $Name `
        -Quantity $Quantity
}
