function Remove-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient 
        })]
        [string]$Recipient
    )
    $Transaction.Allocations = $Transaction.Allocations.Where({
        $_.Recipient -ne $Recipient
    })
}
