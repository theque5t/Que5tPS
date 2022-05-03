function Get-CardanoWalletKeys {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(Mandatory=$true)]
        [string[]]$KeyPairNames,
        [Parameter(Mandatory=$true, ParameterSetName = 'Decrypt')]
        [switch]$Decrypt
    )
    $keys = @()
    $KeyPairNames = $KeyPairNames | Select-Object -Unique
    $KeyPairNames.ForEach({
        if($Decrypt){
            $Password = Get-PasswordInput `
                -Instruction "Specify the password for key pair `"$_`":"
        }
        $keys += [PSCustomObject]@{
            Name = $_
            VerificationKey = $(
                Get-CardanoWalletVerificationKey `
                    -Wallet $Wallet `
                    -KeyPairName $_ `
                    -Decrypt:$Decrypt `
                    -Password $Password
            )
            SigningKey = $(
                Get-CardanoWalletSigningKey `
                    -Wallet $Wallet `
                    -KeyPairName $_ `
                    -Decrypt:$Decrypt `
                    -Password $Password
            )
        }
    })
    return $keys
}