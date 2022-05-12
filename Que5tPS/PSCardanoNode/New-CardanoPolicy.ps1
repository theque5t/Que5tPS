function New-CardanoPolicy {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Id,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Script
    )
    $policy = New-Object CardanoPolicy -Property @{
        Id = $PolicyId
        Script = $Script
    }
    return $policy
}
