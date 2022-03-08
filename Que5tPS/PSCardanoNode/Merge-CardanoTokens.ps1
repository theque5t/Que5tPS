function Merge-CardanoTokens{
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        [CardanoToken[]]$Tokens
    )
    $mergedTokens = [CardanoToken[]]@()
    $tokenGroups = $Tokens | Group-Object -Property PolicyId, Name
    $tokenGroups.ForEach({
        $mergedTokens += New-CardanoToken `
            -PolicyId $_.Group[0].PolicyId `
            -Name $_.Group[0].Name `
            -Quantity $($($_.Group).Quantity | Measure-Object -Sum).Sum
    })
    return $mergedTokens
}
