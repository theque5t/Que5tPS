function Export-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    [ordered]@{ 
        Inputs = Get-CardanoTransactionInputs -Transaction $Transaction
        Allocations = Get-CardanoTransactionAllocations -Transaction $Transaction
        FeeAllocations = Get-CardanoTransactionFeeAllocations -Transaction $Transaction
        ChangeRecipient = Get-CardanoTransactionChangeRecipient -Transaction $Transaction
    } | ConvertTo-Yaml -OutFile $Transaction.StateFile -Force
}