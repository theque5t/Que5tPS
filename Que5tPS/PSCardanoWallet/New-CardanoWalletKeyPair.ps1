function New-CardanoWalletKeyPair {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$Name,
        [parameter(Mandatory = $true)]
        [string]$Description,
        [parameter(Mandatory = $true)]
        [string]$VerificationKey,
        [parameter(Mandatory = $true)]
        [string]$SigningKey
    )
    $keyPair = New-Object CardanoWalletKeyPair -Property @{
        Name = $Name
        Description = $Description
        VerificationKey = $VerificationKey
        SigningKey = $SigningKey
    }
    return $keyPair
}
