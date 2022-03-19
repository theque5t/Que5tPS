function Export-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    [ordered]@{ 
        Inputs = Get-CardanoTransactionInputs -Transaction $Transaction
        Allocations = Get-CardanoTransactionAllocations -Transaction $Transaction
        ChangeRecipient = Get-CardanoTransactionChangeRecipient -Transaction $Transaction
    } | ConvertTo-Yaml -OutFile $Transaction.StateFile -Force
}
