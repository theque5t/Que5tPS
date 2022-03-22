function Get-CardanoTransactionTokenBalance {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$PolicyId,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $tokenBalance = $(
        Get-CardanoTransactionTokenBalances -Transaction $Transaction
    ).Where({
        $_.PolicyId -eq $PolicyId -and
        $_.Name -eq $Name
    })
    return $tokenBalance
}
