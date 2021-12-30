function Get-CardanoTokenExchangeRate {
    param(
        [parameter(ValueFromPipeline)]
        [CardanoToken]$From,
        [ValidateSet('ADA')]
        $To = 'ADA',
        [switch]$WithSymbol
    )
    switch ($From.Name) {
        'lovelace' { 
            switch ($To){
                'ADA' { $exRate = $From.Quantity/1000000; $symbol = "₳" }
            }
        }
        default{ Write-TerminatingError "No known conversion formula for $($From.Name)" }
    }
    
    if($WithSymbol){
        $exRate = "$symbol $exRate"
    }

    return $exRate
}
