function Set-CardanoTransactionSubmissionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [parameter(Mandatory = $true)]
        [bool]$State,
        [bool]$UpdateState = $true
    )
    $Transaction.Submitted = $State
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
