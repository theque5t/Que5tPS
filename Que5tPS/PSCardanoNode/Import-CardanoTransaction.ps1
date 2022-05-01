function Import-CardanoTransaction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'UsingName')]
        [System.IO.DirectoryInfo]$WorkingDir,
        [Parameter(Mandatory = $true, ParameterSetName = 'UsingName')]
        [string]$Name,
        [Parameter(Mandatory = $true, ParameterSetName = 'UsingStateFile')]
        [System.IO.FileInfo]
        $StateFile
    )
    switch ($PsCmdlet.ParameterSetName) {
        'UsingName' {
            $transactionDir = Get-Item -Path "$($WorkingDir.FullName)\$Name"
            $transaction = New-Object CardanoTransaction -Property @{
                WorkingDir = $WorkingDir
                TransactionDir = $transactionDir
                StateFile = "$($transactionDir.FullName)\state.yaml"
                BodyFile = "$($transactionDir.FullName)\tx.body.json"
                SignedFile = "$($transactionDir.FullName)\tx.signed.json"
            }
        }
        'UsingStateFile'{
            $workingDir = $StateFile.Directory.Parent
            $transactionDir = $StateFile.Directory
            $transaction = New-Object CardanoTransaction -Property @{
                WorkingDir = $WorkingDir
                TransactionDir = $transactionDir
                StateFile = $StateFile
                BodyFile = "$($transactionDir.FullName)\tx.body.json"
                SignedFile = "$($transactionDir.FullName)\tx.signed.json"
            }
        }
    }
    Import-CardanoTransactionState -Transaction $Transaction
    Import-CardanoTransactionBody -Transaction $Transaction
    Import-CardanoTransactionSigned -Transaction $Transaction
    return $transaction
}
