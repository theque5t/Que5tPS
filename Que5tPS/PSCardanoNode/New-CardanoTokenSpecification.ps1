function New-CardanoTokenSpecification {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [Int64]$SupplyLimit,
        [Parameter(Mandatory = $true)]
        $MetaData
    )
    $tokenSpecification = New-Object CardanoToken -Property @{
        Name = $Name
        SupplyLimit = $SupplyLimit
        MetaData = $MetaData
    }
    return $tokenSpecification
}
