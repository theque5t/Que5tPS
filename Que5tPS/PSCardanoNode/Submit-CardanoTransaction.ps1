function Submit-CardanoTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    Assert-CardanoTransactionSubmittable -Transaction $Transaction

    $_args = [System.Collections.ArrayList]@(
        'transaction', 'submit'
        '--tx-file', $Transaction.SignedFile.FullName
        $env:CARDANO_CLI_NETWORK_ARG, $env:CARDANO_CLI_NETWORK_ARG_VALUE
    )

    # Invoke-CardanoCLI @_args

    Set-CardanoTransactionSubmissionState `
        -Transaction $Transaction `
        -State $true
}
