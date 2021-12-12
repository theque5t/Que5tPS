class CardanoUtxoList {
    [CardanoUtxo[]]$Utxos

    [void]AddUtxo([CardanoUtxo]$_utxo){
        $this.Utxos += $_utxo
    }
}
