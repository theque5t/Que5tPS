function New-CardanoTransaction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$WorkingDir,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $transactionDir = "$($WorkingDir.FullName)\$Name"
    $transaction = New-Object CardanoTransaction -Property @{
        WorkingDir = $WorkingDir
        TransactionDir = $transactionDir
        Name = $Name
        Network = $Network
        StateFile = "$transactionDir\state.yaml"
        BodyFile = "$transactionDir\tx.body.json"
        SignedFile = "$transactionDir\tx.signed.json"
        ChangeAllocation = New-CardanoTransactionChangeAllocation `
            -Recipient '' `
            -FeePercentage 0
        Submitted = $false
    }
    Assert-CardanoTransactionDirectoryDoesNotExist -Transaction $transaction
    New-Item -Path $transactionDir -ItemType Directory | Out-Null
    Update-CardanoTransaction -Transaction $transaction
    return $transaction
}
