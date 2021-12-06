function Test-CardanoNodeIsRunning {
    $process = Get-CardanoNodeProcess

    return $process.Count -gt 0
}
