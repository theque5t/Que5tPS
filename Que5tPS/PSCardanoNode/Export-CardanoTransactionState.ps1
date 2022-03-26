function Export-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    [ordered]@{ 
        Inputs = Get-CardanoTransactionInputs -Transaction $Transaction
        Allocations = Get-CardanoTransactionAllocations -Transaction $Transaction
        ChangeAllocation = Get-CardanoTransactionChangeAllocation -Transaction $Transaction -State
    } | ConvertTo-Yaml -Options EmitDefaults -OutFile $Transaction.StateFile -Force
}
