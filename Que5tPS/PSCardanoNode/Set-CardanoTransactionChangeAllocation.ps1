function Set-CardanoTransactionChangeAllocation {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ -ge 0 -and $_ -le 100 })]
        [int]$FeePercentage,
        [bool]$UpdateState = $true
    )
    $Transaction.ChangeAllocation = New-CardanoTransactionChangeAllocation `
        -Recipient $Recipient `
        -FeePercentage $FeePercentage
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
