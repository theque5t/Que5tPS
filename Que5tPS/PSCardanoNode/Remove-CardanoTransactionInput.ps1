function Remove-CardanoTransactionInput {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Inputs.Id
        })]
        [string]$Id,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $Transaction.Inputs = $Transaction.Inputs.Where({
        $_.Id -ne $Id
    })
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
