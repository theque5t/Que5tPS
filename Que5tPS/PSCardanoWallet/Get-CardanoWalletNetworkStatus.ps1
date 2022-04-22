function Get-CardanoWalletNetworkStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    # Network
    #           Network | Node Up | Node Synced |Era     | Epoch | Block    | Slot 
    # wallet1 | testnet | true    | true        | Alonzo | 200   | 231323   | 456487987 |
    # wallet2 | mainnet | false   | false       |    ?   |   ?   |     ?    |  ?        |

    $networkStatus = [PSCustomObject]@{
        'testnet' = [PSCustomObject]@{ 
            NodeUp = $null
            NodeSynced = $null 
            Era = $null
            Epoch = $null
            Block = $null
            Slot = $null
        }
        'mainnet' = [PSCustomObject]@{ 
            NodeUp = $null
            NodeSynced = $null 
            Era = $null
            Epoch = $null
            Block = $null
            Slot = $null
        }
    }
    $walletNetworks = Get-CardanoWalletNetworks -Wallets $Wallets
    $walletNetworks.ForEach({
        $network = $_
        $networkStatus.$network.NodeUp = Test-CardanoNodeIsRunning -Network $network
        $networkStatus.$network.NodeSynced = Test-CardanoNodeInSync -Network $network
        if($networkStatus.$network.NodeUp){
            $nodeTip = Get-CardanoNodeTip -Network $network
            $networkStatus.$network.Era = $nodeTip.era
            $networkStatus.$network.Epoch = $nodeTip.epoch
            $networkStatus.$network.Block = $nodeTip.block
            $networkStatus.$network.Slot = $nodeTip.slot
        }
    })

    $walletNetworkStatus = @()
    $Wallets.ForEach({
        $network = Get-CardanoWalletNetwork -Wallet $_
        $walletNetworkStatus += [PSCustomObject]@{
            Wallet = Get-CardanoWalletName -Wallet $_
            Network = $network
            NodeUp = $networkStatus.$network.NodeUp
            NodeSynced = $networkStatus.$network.NodeSynced
            Era = $networkStatus.$network.Era
            Epoch = $networkStatus.$network.Epoch
            Block = $networkStatus.$network.Block
            Slot = $networkStatus.$network.Slot
        }
    })
    return $walletNetworkStatus
}
