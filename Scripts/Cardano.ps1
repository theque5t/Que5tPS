function ConvertTo-ADA{
    param(
        [parameter(ValueFromPipeline)]
        $Amount,
        [ValidateSet('Lovelace')]
        $From = 'Lovelace',
        [switch]$WithSymbol = $True
    )
    switch ($From) {
        'Lovelace' { 
            if($Amount.unit -eq 'lovelace'){
                $Amount = $Amount.where({$_.unit -eq 'lovelace'}).quantity
            }
            $ada = $Amount/1000000 }
    }

    if($WithSymbol){
        $ada = "₳ $ada"
    }
    return $ada
}

function Get-BlockfrostApiResponse {
    param(
        $Method = 'Get',
        $ApiHost = 'cardano-mainnet.blockfrost.io',
        $ApiVersion = 'v0',
        $ApiPath,
        $BlockfrostApiKey = $env:BLOCKFROST_API_KEY
    )
    try{
        $uri = "https://$ApiHost/api/$ApiVersion/$ApiPath"

        $headers = @{
            'project_id' = $BlockfrostApiKey
        }

        Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers
    }
    catch {
        $_.Exception.Message
        $_.ScriptStackTrace
    }
}

function Get-CardanoEpochLatest {
    return Get-BlockfrostApiResponse -ApiPath 'epochs/latest'
}

function Get-CardanoEpoch {
    param(
        [Parameter(Mandatory=$true)]
        $Epoch
    )
    return Get-BlockfrostApiResponse -ApiPath "epochs/$Epoch"
}

function Get-CardanoBlockLatest {
    return Get-BlockfrostApiResponse -ApiPath 'blocks/latest'
}

function Get-CardanoBlock {
    param(
        [Parameter(Mandatory=$true)]
        $Block
    )
    return Get-BlockfrostApiResponse -ApiPath "blocks/$Block"
}

function Get-CardanoBlockTransactions {
    param(
        [Parameter(Mandatory=$true)]
        $Block
    )
    return Get-BlockfrostApiResponse -ApiPath "blocks/$Block/txs"
}

function Get-CardanoTransaction {
    param(
        [Parameter(Mandatory=$true)]
        $Hash
    )
    return Get-BlockfrostApiResponse -ApiPath "txs/$Hash"
}

function Get-CardanoTransactionUtxos {
    param(
        [Parameter(Mandatory=$true)]
        $Hash
    )
    return Get-BlockfrostApiResponse -ApiPath "txs/$Hash/utxos"
}

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

function Get-CardanoNodeProcess {
    $process = $(Get-Process -Verbose:$false).Where({ 
        $_.Name -eq 'cardano-node' -and
        $_.Path -eq "$env:DEADALUS_HOME\cardano-node.exe"
    })

    return $process
}

function Get-DeadalusProcess {
    $process = $(Get-Process -Verbose:$false).Where({
        $_.Path -like "$env:DEADALUS_HOME\Daedalus*"
    })

    return $process
}

function Test-CardanoNodeIsRunning {
    $process = Get-CardanoNodeProcess

    return $process.Count -gt 0
}

function Set-CardanoNodeProcessRunning{
    [CmdletBinding()]
    param()
    if(-not $(Test-CardanoNodeIsRunning)){
        Write-VerboseLog 'Starting Cardano node process...'
        Start-Process `
            -FilePath "$env:DEADALUS_HOME\cardano-launcher.exe" `
            -WorkingDirectory $env:DEADALUS_HOME
        
        while(-not $(Test-CardanoNodeIsRunning)){
            Write-VerboseLog 'Waiting for Cardano node to start...'
            Start-Sleep -Seconds 5
        }

        Write-VerboseLog 'Cardano node process started'
    }
}

function Set-CardanoNodeProcessStopped{
    [CmdletBinding()]
    param()
    if($(Test-CardanoNodeIsRunning)){
        Write-VerboseLog 'Stopping Cardano node process...'
        Get-DeadalusProcess | Stop-Process
        Write-VerboseLog 'Cardano node process stopped'
    }   
}

function Get-CardanoNodeTip {
    try{
        $Network = $env:CARDANO_NODE_NETWORK
        $NetworkMagicId = $env:CARDANO_NODE_NETWORK_MAGIC_ID
        switch ($Network) {
            'testnet' {
                $Network = "$Network-magic"
            }
        }

        $query = Invoke-CardanoCLI query tip --$Network $NetworkMagicId
        return $($query | ConvertFrom-Json)
    }
    catch{}
}

function Set-CardanoNodeSocketPath {
    [CmdletBinding()]
    param()
    if(-not $env:CARDANO_NODE_SOCKET_PATH){
        $process = Get-CardanoNodeProcess
        $pattern = '--socket-path\s(?<socket_path>.*?)\s-'
        $process.CommandLine -match $pattern | Out-Null
        $env:CARDANO_NODE_SOCKET_PATH = $Matches.socket_path
        Write-VerboseLog `
            "Set Cardano node socket path to $env:CARDANO_NODE_SOCKET_PATH"
    }
}

function Test-CardanoNodeSessionIsOpen {
    return Test-Path env:CARDANO_NODE_SESSION
}

function Assert-CardanoNodeSessionIsOpen {
    if(-not $(Test-CardanoNodeSessionIsOpen)){
        Write-FalseAssertionError
    }
}

function Assert-CardanoNodeSessionIsClosed {
    if($(Test-CardanoNodeSessionIsOpen)){
        Write-FalseAssertionError
    }
}

function Open-CardanoNodeSession {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    Assert-CardanoNodeSessionIsClosed

    Write-VerboseLog 'Opening Cardano node session...'
    
    $env:DEADALUS_HOME = "C:\Program Files\Daedalus $Network"
    $env:CARDANO_NODE_NETWORK = $Network
    switch ($Network) {
        'mainnet' {
            $env:CARDANO_NODE_NETWORK_MAGIC_ID = '' 
        }
        'testnet' {
            $env:CARDANO_NODE_NETWORK_MAGIC_ID = 1097911063 
        }
    }

    Set-CardanoNodeProcessRunning
    Set-CardanoNodeSocketPath

    do{
        Write-VerboseLog 'Waiting for Cardano node to respond...'
        Start-Sleep -Seconds 5
    }
    while(-not $(Get-CardanoNodeTip))

    $env:CARDANO_NODE_SESSION = $true

    Assert-CardanoNodeSessionIsOpen
    Write-VerboseLog 'Cardano node session opened'
}

function Close-CardanoNodeSession {
    [CmdletBinding()]
    param()
    Assert-CardanoNodeSessionIsOpen

    Write-VerboseLog 'Closing Cardano node session...'
    
    Set-CardanoNodeProcessStopped
    @('DEADALUS_HOME',
      'CARDANO_NODE_NETWORK',
      'CARDANO_NODE_NETWORK_MAGIC_ID',
      'CARDANO_NODE_SESSION'
      'CARDANO_NODE_SOCKET_PATH'
    ).ForEach({ Remove-Item "env:\$_" })
    
    Assert-CardanoNodeSessionIsClosed
    Write-VerboseLog 'Cardano node session closed'
}

function Test-CardanoNodeInSync {
    return $(Get-CardanoNodeTip).syncProgress -eq '100.00'
}

function Sync-CardanoNode {
    [CmdletBinding()]
    param()
    Assert-CardanoNodeSessionIsOpen

    do{
        Write-VerboseLog "Sync percentage: $($(Get-CardanoNodeTip).syncProgress)"
        Start-Sleep -Seconds 5
    }
    while(-not $(Test-CardanoNodeInSync))
}

function Assert-CardanoNodeInSync {
    Assert-CardanoNodeSessionIsOpen
    if(-not $(Test-CardanoNodeInSync)){
        Write-FalseAssertionError
    }
}

function Test-CardanoHomeExists {
    return Test-Path env:CARDANO_HOME
}

function Assert-CardanoHomeExists {
    if(-not $(Test-CardanoHomeExists)){
        Write-FalseAssertionError
    }
}

function Add-CardanoWalletFileSet {
    param(
        $Name
    )
    Assert-CardanoHomeExists
    $walletPath = "$env:CARDANO_HOME\$Name"
    $walletConfig = "$walletPath\.config"
    $walletKeys = "$walletPath\keys"
    $walletAddresses = "$walletPath\addresses"
    Write-VerboseLog "Creating wallet file set..."
    @($walletPath,
      $walletConfig,
      $walletKeys,
      $walletAddresses
    ).ForEach({
        New-Item $_ -ItemType Directory | Out-Null
    })
    Assert-CardanoWalletExists $Name
}

function Remove-CardanoWalletFileSet {
    param(
        $Name
    )
    Assert-CardanoWalletExists $Name
    Write-VerboseLog "Removing wallet file set..."
    Get-CardanoWallet $Name | Remove-Item -Recurse
    Assert-CardanoWalletDoesNotExist $Name
}

function Get-CardanoWallet {
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByName', Position=0)]
        $Name,
        [Parameter(Mandatory, ParameterSetName = 'All')]
        [switch]$All
    )
    Assert-CardanoHomeExists
    $wallets = Get-ChildItem "$env:CARDANO_HOME"
    switch ($PsCmdlet.ParameterSetName) {
        'ByName' { $wallets = $wallets.Where({ $_.Name -eq $Name }) }
    }
    return $wallets
}

function Get-CardanoWalletKeyFile {
    param(
        [Parameter(Mandatory, Position=0)]
        $Name,
        [Parameter(Mandatory, ParameterSetName = 'ByType')]
        [ValidateSet('signing','verification')]
        $Type,
        [Parameter(Mandatory, ParameterSetName = 'All')]
        [switch]$All
    )
    Assert-CardanoWalletExists $Name
    $walletPath = $(Get-CardanoWallet $Name).FullName
    $walletKeys = Get-ChildItem $walletPath\keys
    switch ($PsCmdlet.ParameterSetName) {
        'ByType' { 
            $types = @{ signing = 'skey'; verification = 'vkey' }
            $walletKeys = $walletKeys.Where({ 
                $_.Name -eq "$Name.$($types[$type])"
            })
        }
    }
    return $walletKeys
}

function Test-CardanoWalletExists {
    param(
        [Parameter(Mandatory=$true)]
        $Name
    )
    return $null -ne $(Get-CardanoWallet $Name)
}

function Assert-CardanoWalletExists {
    param(
        [Parameter(Mandatory=$true)]
        $Name
    )
    if(-not $(Test-CardanoWalletExists $Name)){
        Write-FalseAssertionError
    }
}

function Assert-CardanoWalletDoesNotExist {
    param(
        [Parameter(Mandatory=$true)]
        $Name
    )
    if($(Test-CardanoWalletExists $Name)){
        Write-FalseAssertionError
    }
}


function Set-CardanoWalletConfigKey {
    param(
        $Name,
        $Key,
        $Value
    )
    $walletPath = $(Get-CardanoWallet $Name).FullName
    $walletConfig = "$walletPath\.config"
    Write-VerboseLog `
        "Setting config key $Key value $Value to $Name wallet..."
    Set-Content "$walletConfig\$Key" -Value "$Value" | Out-Null
}

function Get-CardanoWalletConfig {
    param(
        $Name
    )
    $walletConfigHashtable = @{}
    $walletPath = $(Get-CardanoWallet $Name).FullName
    $walletConfig = "$walletPath\.config"
    $(Get-ChildItem $walletConfig).ForEach({
        $key = $_
        $value = Get-Content $key
        $walletConfigHashtable[$key.Name] = $value
    })
    return $walletConfigHashtable
}

function Test-CardanoWalletSigningKeyFileExists {
    param(
        $Name
    )
    $null -ne $(Get-CardanoWalletKeyFile $Name -Type signing)
}

function Assert-CardanoWalletSigningKeyFileDoesNotExist {
    param(
        $Name
    )
    if($(Test-CardanoWalletSigningKeyFileExists $Name)){
        Write-FalseAssertionError
    }
}

function Remove-CardanoWalletSigningKeyFile {
    param(
        $Name
    )
    if($(Test-CardanoWalletSigningKeyFileExists $Name)){
        $signingKey = Get-CardanoWalletKeyFile $Name -Type signing
        Remove-Item $signingKey
    }
    Assert-CardanoWalletSigningKeyFileDoesNotExist $Name
}

function New-CardanoWalletKeys {
    param(
        $Name
    )
    Assert-CardanoWalletExists $Name
    Write-VerboseLog "Generating wallet keys..."
    $walletPath = $(Get-CardanoWallet $Name).FullName
    $walletKeys = "$walletPath\keys"
    $verificationKey = "$walletKeys\$Name.vkey"
    $signingKey = "$walletKeys\$Name.skey"
    Invoke-CardanoCLI address key-gen `
        --verification-key-file $verificationKey `
        --signing-key-file $signingKey
}

function Get-CardanoWalletAddressFile {
    param(
        $Name
    )
    Assert-CardanoWalletExists $Name
    $walletPath = $(Get-CardanoWallet $Name).FullName
    $walletAddresses = Get-ChildItem $walletPath\addresses
    return $walletAddresses
}

function Get-CardanoWalletAddress {
    Param(
        $Name,
        [ValidateScript({
            Get-CardanoWalletAddressFile $Name
        })]
        $Address
    )
}

function Add-CardanoWalletAddress {
    param(
        $Name
    )
    Assert-CardanoNodeInSync
    Assert-CardanoWalletExists $Name
    Write-VerboseLog "Generating wallet address..."

    $Network = $env:CARDANO_NODE_NETWORK
    $NetworkMagicId = $env:CARDANO_NODE_NETWORK_MAGIC_ID
    switch ($Network) {
        'testnet' {
            $Network = "$Network-magic"
        }
    }

    $walletPath = $(Get-CardanoWallet $Name).FullName
    $walletAddresses = "$walletPath\addresses"
    $walletConfig = Get-CardanoWalletConfig $Name
    $walletAddress = "$walletAddresses\$Name-$($walletConfig.nextAddressIndex).addr"
    $walletVerificationKey = Get-CardanoWalletKeyFile $Name -Type verification
    Invoke-CardanoCLI address build `
        --payment-verification-key-file $walletVerificationKey `
        --out-file $walletAddress `
        --$Network $NetworkMagicId

    Set-CardanoWalletConfigKey `
        -Name $Name `
        -Key nextAddressIndex `
        -Value $([int]$($walletConfig.nextAddressIndex)+1)
}

function Get-CardanoWalletAddressUtxo {
    param(
        $Name,
        $Address
    )
    Assert-CardanoNodeInSync
    Assert-CardanoWalletExists $Name
    Write-VerboseLog "Getting wallet address utxo..."

    $Network = $env:CARDANO_NODE_NETWORK
    $NetworkMagicId = $env:CARDANO_NODE_NETWORK_MAGIC_ID
    switch ($Network) {
        'testnet' {
            $Network = "$Network-magic"
        }
    }

    $query = Invoke-CardanoCLI query utxo `
        --$Network $NetworkMagicId `
        --address $Address

    return $query
}

function Add-CardanoWallet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Name,
        [Parameter(Mandatory=$true)]
        [ValidateSet('plaintext','secret')]
        $SigningKeyType
    )
    DynamicParam {        
        switch ($SigningKeyType) {
            'secret' { 
                DynamicParameterDictionary (
                    (
                        DynamicParameter `
                        -Name RegisterVault `
                        -Attributes @{ 
                            Mandatory = $true
                            ParameterSetName = 'RegisterVault' } `
                        -Type switch
                    ),
                    (
                        DynamicParameter `
                        -Name UseVault `
                        -Attributes @{ 
                            Mandatory = $true
                            ParameterSetName = 'UseVault' } `
                        -Type string
                    )
                )
            }
        }
    }
    process {
        Assert-CardanoNodeInSync
        Assert-CardanoWalletDoesNotExist $Name
        
        Write-VerboseLog "Adding wallet $Name..."
        
        Add-CardanoWalletFileSet $Name
        New-CardanoWalletKeys $Name

        switch ($SigningKeyType) {
            'secret' {
                Set-CardanoWalletConfigKey `
                    -Name $Name `
                    -Key SigningKeyType `
                    -Value $_
                $walletVault = $Name
                switch ($PsCmdlet.ParameterSetName) {
                    'RegisterVault' { 
                        Write-VerboseLog `
                            "Registering wallet vault $walletVault..."
                        Set-CardanoWalletConfigKey `
                            -Name $Name `
                            -Key RegisteredVault `
                            -Value $true
                        Register-SecretVault `
                            -Name $walletVault `
                            -ModuleName Microsoft.PowerShell.SecretStore `
                            -DefaultVault:$false
                    }
                    'UseVault' {
                        Set-CardanoWalletConfigKey `
                            -Name $Name `
                            -Key RegisteredVault `
                            -Value $false
                        $walletVault = $PSBoundParameters.UseVault
                    }
                }
                
                Set-CardanoWalletConfigKey `
                    -Name $Name `
                    -Key WalletVault `
                    -Value $walletVault
                
                $secretName = New-Guid
                $secretValue = $(
                    Get-CardanoWalletKeyFile $Name -Type signing | 
                    Get-Content | 
                    ConvertFrom-Json -AsHashtable
                )
                Set-Secret `
                    -Name $secretName `
                    -Secret $secretValue `
                    -Vault $walletVault `
                    -Metadata @{ 
                        createdBy = 'PSCardano'
                        wallet = $Name 
                        keyType = 'signing'
                    } `
                    -NoClobber
                Remove-CardanoWalletSigningKeyFile $Name
                Assert-CardanoWalletSigningKeyFileDoesNotExist $Name
                Write-VerboseLog (
                    "Saved signing key as secret $secretName " +
                    "to wallet vault $walletVault..."
                )
            }
            'plaintext' {
                Set-CardanoWalletConfigKey -Name $Name -Key SigningKeyType -Value $_
                Write-VerboseLog `
                    "Saved signing key as plain text in file $signingKey..."
            }
        }

        Set-CardanoWalletConfigKey $Name -Key nextAddressIndex -Value 0

        Assert-CardanoWalletExists $Name
        Write-VerboseLog "Wallet $Name added"
    }
}

function Remove-CardanoWallet {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        $Name
    )
    if($PSCmdlet.ShouldProcess($Name)){
        Assert-CardanoWalletExists $Name
        
        Write-VerboseLog "Removing wallet $Name..."
        
        $walletConfig = Get-CardanoWalletConfig $Name

        switch ($walletConfig.SigningKeyType) {
            'secret' { 
                $signingKeySecret = $(
                    Get-SecretInfo -Vault $walletConfig.WalletVault
                ).Where({
                    $_.Metadata.wallet -eq $Name -and
                    $_.Metadata.keyType -eq 'signing'
                }) 
                $signingKeySecret | Remove-Secret
                
                Write-VerboseLog (
                    "Removed signing key secret $($signingKeySecret.Name) " +
                    "from wallet vault $($signingKeySecret.VaultName)..."
                )
                
                if($walletConfig.RegisteredVault -eq $true){
                    $walletVault = $Name
                    Write-VerboseLog "Unregistering wallet vault $walletVault..."
                    Unregister-SecretVault -Name $walletVault
                }
            }
        }

        Remove-CardanoWalletFileSet $Name

        Assert-CardanoWalletDoesNotExist $Name
        Write-VerboseLog "Wallet $Name removed"
    }
}

function Test-CardanoWalletSessionIsOpen {
    return Test-Path env:CARDANO_WALLET_SESSION
}

function Assert-CardanoWalletSessionIsOpen {
    if(-not $(Test-CardanoWalletSessionIsOpen)){
        Write-FalseAssertionError
    }
}

function Assert-CardanoWalletSessionIsClosed {
    if($(Test-CardanoWalletSessionIsOpen)){
        Write-FalseAssertionError
    }
}

function Open-CardanoWalletSession {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Name
    )
    Assert-CardanoWalletSessionIsClosed
    Assert-CardanoNodeSessionIsOpen

    Write-VerboseLog 'Opening Cardano wallet session...'
    $env:CARDANO_WALLET = $Name
    $env:CARDANO_WALLET_SESSION = $true

    Assert-CardanoWalletSessionIsOpen
    Write-VerboseLog 'Cardano wallet session opened'
}

function Close-CardanoWalletSession {
    [CmdletBinding()]
    param()
    Assert-CardanoWalletSessionIsOpen

    Write-VerboseLog 'Closing Cardano wallet session...'

    @('CARDANO_WALLET',
      'CARDANO_WALLET_SESSION'
    ).ForEach({ Remove-Item "env:\$_" })
    
    Assert-CardanoWalletSessionIsClosed
    Write-VerboseLog 'Cardano wallet session closed'
}


function Get-CardanoWalletTransactions {}

function New-CardanoTransaction {}

function Set-CardanoTransaction {}

function Submit-CardanoTransaction {}
