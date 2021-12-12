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
