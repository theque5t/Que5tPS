function Get-CardanoMintContracts {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$Path
    )
    $mintContracts = [CardanoMintContract[]]@()
    $mintContractStateFiles = Get-ChildItem `
        -Path $Path `
        -File state.yaml `
        -Recurse
    $mintContractStateFiles.ForEach({
        $mintContracts += [CardanoMintContract]$(
            Import-CardanoMintContract -StateFile $_
        )
    })
    return $mintContracts
}
