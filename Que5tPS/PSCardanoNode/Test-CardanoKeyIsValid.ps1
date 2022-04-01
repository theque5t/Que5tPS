function Test-CardanoKeyIsValid {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [securestring]$Key
    )
    return [bool]$(
        $(Test-CardanoSigningKeyIsValid -Key $Key) -or
        $(Test-CardanoVerificationKeyIsValid -Key $Key)
    )
}
