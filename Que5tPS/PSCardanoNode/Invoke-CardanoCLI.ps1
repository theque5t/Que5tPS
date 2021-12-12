# The following commands assume the Deadulus Wallet (comes with full node and cli) is setup.
# If necessary, the commands could be modified to use different node setups, but for now 
# Deadalus is the only option.
# https://docs.cardano.org/cardano-components/daedalus-wallet
# https://daedaluswallet.io/

function Invoke-CardanoCLI {
    try{
        $output = &"$env:DEADALUS_HOME\cardano-cli.exe" @args 2>&1
        Assert-CommandSuccessful
        return $output
    }
    catch{
        $_
        Write-Output $output
    }
}

Set-Alias -Name cardano-cli -Value Invoke-CardanoCLI
