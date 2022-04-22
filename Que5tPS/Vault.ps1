function Protect-String {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$String,
        [SecureString]$Password = $(Read-Host -AsSecureString -Prompt 'Password')
    )
    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }
    Process {
        try{
            $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes(
                $(ConvertFrom-SecureString -SecureString $Password -AsPlainText)
            ))
            $plainBytes = [System.Text.Encoding]::UTF8.GetBytes($String)
            $encryptor = $aesManaged.CreateEncryptor()
            $encryptedBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
            $encryptedBytes = $aesManaged.IV + $encryptedBytes
            return [System.Convert]::ToBase64String($encryptedBytes)
        }
        catch{
            throw 'Failed to protect string.'
        }
        finally{
            @($Password,$shaManaged,$aesManaged,
              $plainBytes,$encryptor,$encryptedBytes
            ).Where({ $_ }).ForEach({ 
                if($_.Dispose){ $_.Dispose() }
                else{ $_ = $null } 
            })
        }
    }
}

function Unprotect-String {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$String,
        [SecureString]$Password = $(Read-Host -AsSecureString -Prompt 'Password')
    )
    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }
    Process {
        try{
            $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes(
                $(ConvertFrom-SecureString -SecureString $Password -AsPlainText)
            ))
            $cipherBytes = [System.Convert]::FromBase64String($String)
            $aesManaged.IV = $cipherBytes[0..15]
            $decryptor = $aesManaged.CreateDecryptor()
            $decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
            return [System.Text.Encoding]::UTF8.GetString($decryptedBytes).Trim([char]0)
        }
        catch{
            throw 'Failed to unprotect string.'
        }
        finally{
            @($Password,$shaManaged,$aesManaged,
              $cipherBytes,$decryptor,$decryptedBytes
            ).Where({ $_ }).ForEach({ 
                if($_.Dispose){ $_.Dispose() }
                else{ $_ = $null } 
            })
        }
    }
}
