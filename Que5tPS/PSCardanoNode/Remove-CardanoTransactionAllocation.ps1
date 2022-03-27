function Remove-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [bool]$UpdateState = $true
    )
    $Transaction.Allocations = $Transaction.Allocations.Where({
        $_.Recipient -ne $Recipient
    })
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
