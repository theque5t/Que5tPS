function Test-CardanoAddressIsValid {
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        $Address
    )
    $addressPattern = '^(addr1|stake1|addr_test1|stake_test1)[a-z0-9]+$'+
                      '|^(Ae2|DdzFF|37bt)[a-zA-Z0-9]+$'
    return $Address -match $addressPattern
}
