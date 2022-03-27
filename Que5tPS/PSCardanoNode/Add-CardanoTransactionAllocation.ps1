function Add-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [CardanoToken[]]$Value,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ -ge 0 -and $_ -le 100 })]
        [int]$FeePercentage,
        [bool]$UpdateState = $true
    )
    $Transaction.Allocations += New-CardanoTransactionAllocation `
        -Recipient $recipient `
        -Value $Value `
        -FeePercentage $FeePercentage
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
