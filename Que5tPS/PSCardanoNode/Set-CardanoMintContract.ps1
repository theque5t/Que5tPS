function Set-CardanoMintContract {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    do{
        $interactionComplete = $false
        Format-CardanoMintContractSummary -MintContract $MintContract
    
        $actionSelection = Get-OptionSelection `
            -Instruction 'Select an option:' `
            -Options @(
                'Set Policy'
                'Set Tokens'
                'Done Editing'
            )
    
        switch($actionSelection){
            'Set Witnesses' {
                Set-CardanoMintContractWitnesses `
                    -MintContract $MintContract `
                    -Witnesses $(
                        Get-FreeformInput `
                            -Instruction $(
                                "Specify 1 or more verification key strings" +
                                " or file paths to witness minting (e.g. <key>,</path/to/key.vkey>)"
                                "`nSeperate addresses using a comma."
                            ) `
                            -InputType 'object' `
                            -TransformCommand 'ConvertTo-CardanoKeySecureStringList' `
                            -TransformValueArg 'Objects' `
                            -ValidationType TestCommand `
                            -ValidationParameters @{ Command = 'Test-CardanoVerificationKeyIsValid'; ValueArg = 'Key' } `
                            -Delimited `
                            -Sensitive
                    )
            }
            'Add Token Allocation' {
                Add-CardanoMintContractTokenAllocation `
                    -Name $name `
                    -Quantity $quantity
            }
            'Remove Token Allocation' {
                Remove-CardanoMintContractTokenAllocation `
                    -Name $name
            }
            'Done Editing'{
                $interactionComplete = $true
            }
        }
    }
    until($interactionComplete)
    Format-CardanoMintContractSummary -MintContract $MintContract
}
