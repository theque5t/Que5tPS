function Set-CardanoTransactionAllocation {
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
    Remove-CardanoTransactionAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient `
        -UpdateState $False

    Add-CardanoTransactionAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient `
        -Value $Value `
        -FeePercentage $FeePercentage `
        -UpdateState $False

    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
