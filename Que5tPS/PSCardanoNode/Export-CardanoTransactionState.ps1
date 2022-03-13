function Export-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    [ordered]@{ 
        Inputs = $Transaction | Get-CardanoTransactionInputs
        Allocations = $Transaction | Get-CardanoTransactionAllocations
        FeeAllocations = $Transaction | Get-CardanoTransactionFeeAllocations
        ChangeRecipient = $Transaction | Get-CardanoTransactionChangeRecipient
    } | ConvertTo-Yaml -OutFile $Transaction.StateFile -Force
}