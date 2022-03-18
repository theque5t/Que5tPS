function Import-CardanoTransactionBody {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    Assert-CardanoTransactionBodyFileExists -Transaction $Transaction
    $Transaction.BodyFile = Get-Item $Transaction.BodyFile
    $Transaction.BodyFileContent = Get-Content $Transaction.BodyFile
    $Transaction.BodyFileObject = if($Transaction.BodyFileContent){ 
        $Transaction.BodyFileContent | ConvertFrom-Json  
    }
    $Transaction.BodyFileView = if($Transaction.BodyFileContent){ 
        Invoke-CardanoCLI transaction view --tx-body-file $Transaction.BodyFile
    }
    $Transaction.BodyFileViewObject = if($Transaction.BodyFileView) { 
        $Transaction.BodyFileView | ConvertFrom-Yaml 
    }
}
