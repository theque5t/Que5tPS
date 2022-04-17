function Import-CardanoTransactionSigned {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $network = Get-CardanoTransactionNetwork -Transaction $Transaction
    Assert-CardanoNodeSessionIsOpen -Network $network
    Assert-CardanoTransactionSignedFileExists -Transaction $Transaction
    $Transaction.SignedFile = Get-Item $Transaction.SignedFile
    $Transaction.SignedFileContent = Get-Content $Transaction.SignedFile
    $Transaction.SignedFileObject = if($Transaction.SignedFileContent){ 
        $Transaction.SignedFileContent | ConvertFrom-Json  
    }
    $Transaction.SignedFileView = if($Transaction.SignedFileContent){
        $socket = Get-CardanoNodeSocket -Network $network
        $nodePath = Get-CardanoNodePath -Network $network
        $_args = @(
            'transaction', 'view'
            '--tx-file', $Transaction.SignedFile
        )
        Invoke-CardanoCLI `
            -Socket $socket `
            -Path $nodePath `
            -Arguments $_args
    }
    $Transaction.SignedFileViewObject = if($Transaction.SignedFileView) { 
        $Transaction.SignedFileView | ConvertFrom-Yaml 
    }
}
