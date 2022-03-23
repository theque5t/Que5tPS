function New-CardanoTransaction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$WorkingDir,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $transaction = New-Object CardanoTransaction -Property @{
        WorkingDir = $WorkingDir
        StateFile = "$($WorkingDir.FullName)\$Name.state.yaml"
        BodyFile = "$($WorkingDir.FullName)\$Name.tx.json"
        ChangeAllocation = New-CardanoTransactionChangeAllocation `
            -Recipient '' `
            -FeePercentage 0
    }
    Assert-CardanoTransactionStateFileDoesNotExist -Transaction $Transaction
    Assert-CardanoTransactionBodyFileDoesNotExist -Transaction $Transaction
    Update-CardanoTransaction -Transaction $Transaction
    return $transaction
}
