function Export-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    [ordered]@{ 
        Inputs = $Transaction | Get-CardanoTransactionInputs
        Allocations = $Transaction | Get-CardanoTransactionAllocations
        ChangeRecipient = $Transaction | Get-CardanoTransactionChangeRecipient
    } | ConvertTo-Yaml -OutFile $Transaction.StateFile -Force
}