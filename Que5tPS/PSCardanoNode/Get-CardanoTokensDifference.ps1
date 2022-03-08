function Get-CardanoTokensDifference {
    param(
        [parameter(Mandatory = $true)]
        [AllowNull()]
        [CardanoToken[]]$Set1,
        [parameter(Mandatory = $true)]
        [AllowNull()]
        [CardanoToken[]]$Set2
    )
    $set2Copy = Copy-Object $Set2
    $set2Copy.ForEach({ $_.Quantity = -$_.Quantity })
    $tokensDifference = Merge-CardanoTokens -Tokens $($Set1 + $set2Copy)
    return $tokensDifference
}
