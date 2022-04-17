function Invoke-CardanoCLI {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.IO.FileInfo]$Socket,
        [Parameter(Mandatory=$true)]
        [System.IO.DirectoryInfo]$Path,
        [Parameter(Mandatory=$true)]
        [Array]$Arguments
    )
    try{
        $env:CARDANO_NODE_SOCKET_PATH = $Socket
        $output = &"$Path\cardano-cli.exe" @Arguments 2>&1
        Assert-CommandSuccessful
        return $output
    }
    catch{
        Write-TerminatingError $(@($_.ToString(), $output | Out-String) -join "`n")
    }
    finally{
        Remove-Item env:CARDANO_NODE_SOCKET_PATH
    }
}

Set-Alias -Name cardano-cli -Value Invoke-CardanoCLI
