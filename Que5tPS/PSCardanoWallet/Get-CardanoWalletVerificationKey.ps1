function Get-CardanoWalletVerificationKey {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(Mandatory=$true)]
        [string]$KeyPairName,
        [Parameter(Mandatory=$true, ParameterSetName = 'Decrypt')]
        [switch]$Decrypt,
        [Parameter(Mandatory=$true, ParameterSetName = 'Decrypt')]
        [securestring]$Password
    )
    $keyPair = Get-CardanoWalletKeyPair -Wallet $Wallet -Name $KeyPairName
    $verificationKey = $keyPair.VerificationKey
    if($Decrypt){
        $verificationKey = Unprotect-String `
            -String $verificationKey `
            -Password $Password
    }
    return $verificationKey
}
