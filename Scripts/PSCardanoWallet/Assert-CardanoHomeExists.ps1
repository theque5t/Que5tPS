function Assert-CardanoHomeExists {
    if(-not $(Test-CardanoHomeExists)){
        Write-FalseAssertionError
    }
}
