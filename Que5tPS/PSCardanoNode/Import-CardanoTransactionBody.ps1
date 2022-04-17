function Import-CardanoTransactionBody {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $network = Get-CardanoTransactionNetwork -Transaction $Transaction
    Assert-CardanoNodeSessionIsOpen -Network $network
    Assert-CardanoTransactionBodyFileExists -Transaction $Transaction
    $Transaction.BodyFile = Get-Item $Transaction.BodyFile
    $Transaction.BodyFileContent = Get-Content $Transaction.BodyFile
    $Transaction.BodyFileObject = if($Transaction.BodyFileContent){ 
        $Transaction.BodyFileContent | ConvertFrom-Json  
    }
    $Transaction.BodyFileView = if($Transaction.BodyFileContent){ 
        $socket = Get-CardanoNodeSocket -Network $network
        $nodePath = Get-CardanoNodePath -Network $network
        $_args = @(
            'transaction', 'view'
            '--tx-body-file', $Transaction.BodyFile
        )
        Invoke-CardanoCLI `
            -Socket $socket `
            -Path $nodePath `
            -Arguments $_args
    }
    $Transaction.BodyFileViewObject = if($Transaction.BodyFileView) { 
        $Transaction.BodyFileView | ConvertFrom-Yaml 
    }
}
