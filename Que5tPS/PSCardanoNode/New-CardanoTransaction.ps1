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
        Name = $Name
        StateFile = "$($WorkingDir.FullName)\$Name.state.yaml"
        BodyFile = "$($WorkingDir.FullName)\$Name.tx.body.json"
        SignedFile = "$($WorkingDir.FullName)\$Name.tx.signed.json"
        ChangeAllocation = New-CardanoTransactionChangeAllocation `
            -Recipient '' `
            -FeePercentage 0
        Submitted = $false
    }
    Assert-CardanoTransactionStateFileDoesNotExist -Transaction $transaction
    Assert-CardanoTransactionBodyFileDoesNotExist -Transaction $transaction
    Assert-CardanoTransactionSignedFileDoesNotExist -Transaction $transaction
    Update-CardanoTransaction -Transaction $transaction
    return $transaction
}
