try {
    Write-Output "Installing Que5tPS..."
    Copy-Item -Force -Recurse -Path $PSScriptRoot\* -Destination $(Split-Path -Path $profile)
    Write-Output "Install Complete"
}
catch {
    $_.Exception.Message
    $_.ScriptStackTrace
}
