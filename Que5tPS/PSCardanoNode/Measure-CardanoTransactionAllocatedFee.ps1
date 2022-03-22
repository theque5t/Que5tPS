function Measure-CardanoTransactionAllocatedFee {
    param(
        [Int64]$Fee,
        [float]$Percentage
    )
    return ConvertTo-RoundNumber -Number $($Fee * $Percentage)
}
