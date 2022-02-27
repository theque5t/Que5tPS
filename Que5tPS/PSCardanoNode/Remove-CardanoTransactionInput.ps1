function Remove-CardanoTransactionInput {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [ValidateScript({ 
            $_ -in $Transaction.Inputs.Id
        })]
        [string]$Id
    )
    $Transaction.Inputs = $Transaction.Inputs.Where({
        $_.Id -ne $Id
    })
}
