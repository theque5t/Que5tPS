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

    $network = Get-CardanoTransactionNetwork -Transaction $Transaction
    $socket = Get-CardanoNodeSocket -Network $network
    $nodePath = Get-CardanoNodePath -Network $network
    $networkArgs = Get-CardanoNodeNetworkArg -Network $network
    $_args = [System.Collections.ArrayList]@(
        'transaction', 'submit'
        '--tx-file', $Transaction.SignedFile.FullName
        $networkArgs
    )

    # Invoke-CardanoCLI `
    #     -Socket $socket `
    #     -Path $nodePath `
    #     -Arguments $_args

    Set-CardanoTransactionSubmissionState `
        -Transaction $Transaction `
        -State $true `
        -ROProtection $false
}
