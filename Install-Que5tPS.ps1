try {
    Write-Output "Installing Que5tPS..."
    $profileDirectory = $(Split-Path -Path $profile)
    Get-ChildItem $profileDirectory -exclude 'Modules','Scripts' | 
        Remove-Item -Recurse -Force
    Copy-Item -Force -Recurse -Path $PSScriptRoot\* -Exclude '.git' -Destination $profileDirectory
    Write-Output "Install Complete"
}
catch {
    $_.Exception.Message
    $_.ScriptStackTrace
}
