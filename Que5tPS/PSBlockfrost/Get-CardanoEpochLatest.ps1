function Get-CardanoEpochLatest {
    return Get-BlockfrostApiResponse -ApiPath 'epochs/latest'
}
