function Import-CardanoTransactionSigned {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    Assert-CardanoTransactionSignedFileExists -Transaction $Transaction
    $Transaction.SignedFile = Get-Item $Transaction.SignedFile
    $Transaction.SignedFileContent = Get-Content $Transaction.SignedFile
    $Transaction.SignedFileObject = if($Transaction.SignedFileContent){ 
        $Transaction.SignedFileContent | ConvertFrom-Json  
    }
    $Transaction.SignedFileView = if($Transaction.SignedFileContent){ 
        Invoke-CardanoCLI transaction view --tx-file $Transaction.SignedFile
    }
    $Transaction.SignedFileViewObject = if($Transaction.SignedFileView) { 
        $Transaction.SignedFileView | ConvertFrom-Yaml 
    }
}
