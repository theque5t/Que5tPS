function Get-CardanoTransactionStateHash {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    $state = Get-Content $Transaction.StateFile | 
             Select-String -Pattern SignedStateHash -NotMatch |
             Select-String -Pattern Submitted -NotMatch
    $stateStream = [IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes($state))
    $stateHash = $(Get-FileHash -InputStream $stateStream).Hash
    return $stateHash
}
