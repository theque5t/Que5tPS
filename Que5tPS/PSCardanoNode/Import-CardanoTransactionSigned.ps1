function Import-CardanoTransactionSigned {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    Assert-CardanoTransactionSignedFileExists -Transaction $Transaction
    $Transaction.SignedFile = Get-Item $Transaction.SignedFile
    $Transaction.SignedFileContent = Get-Content $Transaction.SignedFile
}
