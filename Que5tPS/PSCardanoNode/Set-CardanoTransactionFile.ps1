function Set-CardanoTransactionFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        $File,
        [Parameter(Mandatory = $true, Position = 1)]
        $Parameters
    )
    $_args = [System.Collections.ArrayList]@()
    $_args.Add('transaction')
    $_args.Add('build-raw')
    $_args.Add('--out-file')
    $_args.Add($File)
    $Parameters.ForEach({
        $_args.Add("--$($_.Type)")
        $_args.Add("--$($_.Value)")
    })
    Invoke-CardanoCLI @_args
    Write-VerboseLog "Set transaction file: $File"
}
