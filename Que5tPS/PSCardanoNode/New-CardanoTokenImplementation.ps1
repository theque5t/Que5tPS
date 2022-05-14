function New-CardanoTokenImplementation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [int64]$Minted,
        [Parameter(Mandatory = $true)]
        [int64]$Burned
    )
    $tokenImplementation = New-Object CardanoTokenImplementation -Property @{
        Name = $Name
        Minted = $Minted
        Burned = $Burned
    }
    return $tokenImplementation
}
