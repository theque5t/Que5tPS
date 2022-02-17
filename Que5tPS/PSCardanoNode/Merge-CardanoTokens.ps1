function Merge-CardanoTokens{
    param(
        [CardanoToken[]]$Tokens
    )
    $mergedTokens = [CardanoToken[]]@()
    $tokenGroups = $Tokens | Group-Object -Property PolicyId, Name
    $tokenGroups.ForEach({
        $mergedTokens += [CardanoToken]::new(
            $_.Group[0].PolicyId,
            $_.Group[0].Name,
            $($($_.Group).Quantity | Measure-Object -Sum).Sum
        )
    })
    return $mergedTokens
}
