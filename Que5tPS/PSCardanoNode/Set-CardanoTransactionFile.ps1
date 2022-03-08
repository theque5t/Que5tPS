function Set-CardanoTransactionFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        $File,
        [Parameter(Mandatory = $true, Position = 1)]
        $Parameters
    )
    $_args = [System.Collections.ArrayList]@()
    [void]$_args.Add('transaction')
    [void]$_args.Add('build-raw')
    [void]$_args.Add('--out-file')
    [void]$_args.Add($File)
    $Parameters.ForEach({
        [void]$_args.Add("--$($_.Type)")
        [void]$_args.Add("--$($_.Value)")
    })
    Invoke-CardanoCLI @_args
    Write-VerboseLog "Set transaction file: $File"
}
