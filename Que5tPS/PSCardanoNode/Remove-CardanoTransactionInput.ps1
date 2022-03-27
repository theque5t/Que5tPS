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
        [bool]$UpdateState = $true
    )
    $Transaction.Inputs = $Transaction.Inputs.Where({
        $_.Id -ne $Id
    })
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
