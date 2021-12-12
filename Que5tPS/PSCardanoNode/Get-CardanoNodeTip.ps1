function Get-CardanoNodeTip {
    try{
        $_args = @(
            'query', 'tip'
            $env:CARDANO_CLI_NETWORK_ARG
            $env:CARDANO_CLI_NETWORK_ARG_VALUE
        )
        $query = Invoke-CardanoCLI @_args
        return $($query | ConvertFrom-Json)
    }
    catch{}
}
