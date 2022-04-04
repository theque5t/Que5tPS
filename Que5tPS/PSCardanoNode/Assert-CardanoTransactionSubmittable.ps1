function Assert-CardanoTransactionSubmittable {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    if(-not $(Test-CardanoTransactionSubmittable -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
