function Export-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    [ordered]@{ 
        WitnessQuantity = Get-CardanoTransactionWitnessQuantity -Transaction $Transaction
        Inputs = Get-CardanoTransactionInputs -Transaction $Transaction
        Allocations = Get-CardanoTransactionAllocations -Transaction $Transaction
        ChangeAllocation = Get-CardanoTransactionChangeAllocation -Transaction $Transaction -State
        Fee = Get-CardanoTransactionMinimumFee -Transaction $Transaction
        SignedStateHash = Get-CardanoTransactionSignedStateHash -Transaction $Transaction
        Submitted = Get-CardanoTransactionSubmissionState -Transaction $Transaction
    } | ConvertTo-Yaml -Options EmitDefaults -OutFile $Transaction.StateFile -Force
}
