function Test-CardanoSigningKeyIsValid {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [securestring]$Key
    )
    $signingKey = $Key | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json
    return [bool]$(
        $signingKey.type -match '^PaymentSigningKey.*' -and
        $signingKey.description -eq 'Payment Signing Key' -and
        $signingKey.cborHex -match '^[a-fA-F0-9]+$'
    )
}
