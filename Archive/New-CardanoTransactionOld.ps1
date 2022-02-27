function New-CardanoTransactionOld {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        $WorkingDir,

        [string[]]$Addresses,

        [Parameter(Mandatory = $true)]
        [ArgumentCompleter({ 
            param($Command, $Param, $Input, $AST, $ParamState)
            $workingDir = Get-BoundValueElseDefaultValue `
                            WorkingDir `
                            $ParamState `
                            $Command
            $addresses = Get-BoundValueElseDefaultValue `
                            Addresses `
                            $ParamState `
                            $Command
            $utxos = Get-CardanoAddressUtxos -Address $Addresses -WorkingDir $WorkingDir
            
            $availableUtxos = @{ 'AvailableUtxos' = [System.Collections.ArrayList]@() }
            $Utxos.Utxos.ForEach({
                $availableUtxos.AvailableUtxos.Add(@{ 'Spend' = '<true|false>'; 'Utxo' = $_; }) | Out-Null
            })
            "$($availableUtxos | ConvertTo-Yaml)"
        })]
        $Utxos,

        [Parameter(Mandatory = $true)]
        [ArgumentCompleter({ 
            param($Command, $Param, $Input, $AST, $ParamState)
            $Utxos = Get-BoundValueElseDefaultValue `
                                Utxos `
                                $ParamState `
                                $Command
            
            $Utxos
            # $Utxos | ConvertTo-Json -Depth 10
            # $Utxos.AvailableUtxos.Where( $_.Spend -eq $true ) | ConvertTo-Json -Depth 10
        })]
        $SelectedUtxos
        # [CardanoUtxo[]]$Utxos
        
        # $Outputs,
        # $OutputFile
    )
    # DynamicParam {
    #     $dynamicParams = DynamicParameterDictionary

    #     # 1. get quantity of recipients
    #     # 2. create a recipient parameter set for each, using Recipient parameter (collects address), Send parameter (collects what to send)
    #     # 3. send parameter could be a argument completer that shows how to fill out a hashtable where they specify quantity for each token to send, defaulting to zero 
    #     # (or perhaps difference in quantity left based on previous parameter input states)

    #     # ? What should the primary input be? Help them figure out UTXOs or they supply utxos?
    #         # - If we do it for them, we could have 1 Funds parameter where we return an argument completer that provides a hashtable of all the UTXOs,
    #         #  and then they specify which ones to use, and this hashtable can show the tokens in the utxos
    #         # - Additionally, they can supply UTXOs as input, instead of us helping them to find the UTXOs; so they have the flexibility of either way

    #     # return Utxos for all address supplied
    #     # create 1 Input parameter for each Utxo counted (Input 1 being the only mandatory input)
    #     $_list = $Addresses -split ','
    #     $_list.ForEach({
    #         $Name = "Input$_" 
    #         $_dynamicParam = DynamicParameter `
    #             -Name $Name `
    #             -ValidateSet (
    #                 "3789d7b06cb0a30ddb4fc926f92c34676096c03a2bdc0676851b24f2b4eb2bd1#0",
    #                 "3789d7b06cb0a30ddb4fc926f92c34676096c03a2bdc0676851b24f2b4eb2bd1#1"
    #             ) `
    #             -Type string
    #         $dynamicParams.Add($Name, $_dynamicParam)
    #     })
    #     return $dynamicParams
    # }
    # begin {
    #     # $Name = $PSBoundParameters.Name
    # }
    process{
        Assert-CardanoNodeInSync
        Write-VerboseLog "Getting protocol parameters..."

        [System.Collections.ArrayList]$_args = @(
            'transaction','build-raw'
            '--fee', 0
            '--out-file', $outputFile
        )

        $Inputs.Id.ForEach({
            $_args.Add('--tx-in')
            $_args.Add($_)
        })

        return $_args
        # Invoke-CardanoCLI @_args
    }
}

Syntax
--tx-in TX-IN            TxId#TxIx
[--tx-out ADDRESS VALUE [--tx-out-datum-hash HASH]]
--tx-out ADDRESS VALUE   The transaction output as Address+Lovelace where
                           Address is the Bech32-encoded address followed by the
                           amount in Lovelace.

Simple Transaction
cardano-cli transaction build-raw \
--tx-in cf3cf4850c8862f2d698b2ece926578b3815795c9e38d2f907280f02f577cf85#0 \
--tx-out $(cat $HOME/cardano/keys/payment2.addr)+0 \
--tx-out $(cat $HOME/cardano/keys/payment1.addr)+0 \
--fee 0 \
--out-file $HOME/cardano/tx.draft

Multi-witness Transaction
cardano-cli transaction build-raw \
--tx-in b73b7503576412219241731230b5b7dd3b64eed62ccfc3ce69eb86822f1db251#0 \
--tx-in b73b7503576412219241731230b5b7dd3b64eed62ccfc3ce69eb86822f1db251#1 \
--tx-out $(cat ../keys/store-owner.addr)+0 \
--fee 0 \
--out-file tx2.draft

https://developers.cardano.org/docs/native-tokens/minting#sending-token-to-a-wallet
Send tokens
$ fee="0"
$ receiver="addr_test1qp0al5v8mvwv9mzn77ls0tev3t838yp9ghvgxf9t5qa4sqlua2ywcygl3d356c34576elq5mcacg88gaevceyc5tulwsmk7s8v"
$ receiver_output="10000000"
$ txhash="d82e82776b3588c1a2c75245a20a9703f971145d1ca9fba4ad11f50803a43190"
$ txix="0"
$ funds="999824071"

cardano-cli transaction build-raw  \
--fee $fee  \
--tx-in $txhash#$txix  \
--tx-out $receiver+$receiver_output+"2 $policyid.$tokenname1"  \
--tx-out $address+$output+"9999998 $policyid.$tokenname1 + 10000000 $policyid.$tokenname2"  \
--out-file rec_matx.raw

FT Mint Transaction
To mint the tokens, we will make a transaction using our previously generated and funded address.
Build the raw transaction to send to oneself

tokenname1="Testtoken"
tokenname2="SecondTesttoken"
tokenamount="10000000"
output="0"
txhash="b35a4ba9ef3ce21adcd6879d08553642224304704d206c74d3ffb3e6eed3ca28"
txix="0"
funds="1000000000"
policyid=$(cat policy/policyID)
fee="300000"
cardano-cli transaction build-raw \
 --fee $fee \
 --tx-in $txhash#$txix \
 --tx-out $address+$output+"$tokenamount $policyid.$tokenname1 + $tokenamount $policyid.$tokenname2" \
 --mint="$tokenamount $policyid.$tokenname1 + $tokenamount $policyid.$tokenname2" \
 --minting-script-file policy/policy.script \
 --out-file matx.raw

NFT Mint Transaction
To mint the tokens, we will make a transaction using our previously generated and funded address.
Build the raw transaction to send to oneself

cardano-cli transaction build \
--mainnet \
--alonzo-era \
--tx-in $txhash#$txix \
--tx-out $address+$output+"$tokenamount $policyid.$tokenname" \
--change-address $address \
--mint="$tokenamount $policyid.$tokenname" \
--minting-script-file $script \
--metadata-json-file metadata.json  \
--invalid-hereafter $slotnumber \
--witness-override 2 \
--out-file matx.raw
