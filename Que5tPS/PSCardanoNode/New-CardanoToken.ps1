function New-CardanoToken {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$PolicyId,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [Int64]$Quantity
    )
    $token = New-Object CardanoToken -Property @{
        PolicyId = $PolicyId
        Name = $Name
        Quantity = $Quantity
    }
    return $token
}
