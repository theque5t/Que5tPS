function Exit-CardanoWalletSession {
    [CmdletBinding()]
    param()
    if($(Get-FunctionName -StackNumber 2) -eq 'Enter-CardanoWalletSession'){
        Write-TerminatingError 'Exit'
    }
}
