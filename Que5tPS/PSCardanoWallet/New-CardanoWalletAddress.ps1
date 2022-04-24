function New-CardanoWalletAddress {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$Name,
        [parameter(Mandatory = $true)]
        [string]$Description,
        [parameter(Mandatory = $true)]
        [string]$Hash,
        [parameter(Mandatory = $true)]
        [string]$KeyPairName
    )
    $address = New-Object CardanoWalletAddress -Property @{
        Name = $Name
        Description = $Description
        Hash = $Hash
        KeyPairName = $KeyPairName
    }
    return $address
}
