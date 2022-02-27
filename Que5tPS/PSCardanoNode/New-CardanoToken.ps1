function New-CardanoToken {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyId,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [string]$Quantity
    )
    $token = [CardanoToken]::new()
    $token.PolicyId = $PolicyId
    $token.Name = $Name
    $token.Quantity = $Quantity
    return $token
}
