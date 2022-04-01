function ConvertTo-CardanoKeySecureStringList {
    param(
        [Parameter(Mandatory = $true)]
        $Objects
    )
    $secureStrings = @()
    $Objects.ForEach({
        $object = $_
        if(Test-Path $object){ $object = Get-Content -Path $object -Raw }
        if($object.GetType().Name -ne 'SecureString'){
            $object = ConvertTo-SecureString -String $object -AsPlainText -Force
        }
        if(Test-CardanoKeyIsValid -Key $object){
            $secureStrings += $object
        }
    })
    return $secureStrings
}
