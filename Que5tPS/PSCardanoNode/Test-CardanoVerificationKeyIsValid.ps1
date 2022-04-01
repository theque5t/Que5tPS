function Test-CardanoVerificationKeyIsValid {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [securestring]$Key
    )
    $verificationKey = $Key | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json
    return [bool]$(
        $verificationKey.type -match '^PaymentVerificationKey.*' -and
        $verificationKey.description -eq 'Payment Verification Key' -and
        $verificationKey.cborHex -match '^[a-fA-F0-9]+$'
    )
}
