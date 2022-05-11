function New-CardanoMintContract {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$WorkingDir,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [string]$Description,
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $mintContractDir = "$($WorkingDir.FullName)\$Name"
    $mintContract = New-Object CardanoMintContract -Property @{
        WorkingDir = $WorkingDir
        MintContractDir = $mintContractDir
        Name = $Name
        Description = $Description
        Network = $Network
        StateFile = "$mintContractDir\state.yaml"
    }
    Assert-CardanoMintContractDirectoryDoesNotExist -MintContract $mintContract
    New-Item -Path $mintContractDir -ItemType Directory | Out-Null
    Update-CardanoMintContract -MintContract $mintContract
    return $mintContract
}
