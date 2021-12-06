function Get-CardanoBlockLatest {
    return Get-BlockfrostApiResponse -ApiPath 'blocks/latest'
}
