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
                                "`nSeperate witnesses using a comma."
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
            'Set Time Lock' {
                $timelock = Get-FreeformInput `
                    -Instruction $(
                        "Specify the slots to bound minting/burning actions within" +
                        " (e.g. <afterSlot>,<beforeSlot>)" +
                        "`nEmpty value is the equivalent of any slot." +
                        "`nSeperate slots using a comma."
                    ) `
                    -InputType 'int64' `
                    -ValidateEach $false `
                    -ValidateTogether $true `
                    -ValidationType TestCommand `
                    -ValidationParameters @{ 
                        Command = 'Test-CardanoMintContractTimeLockIsValid'
                        ValueArgs = @(
                            @{ Arg = 'AfterSlot'; Input = 1 }
                            @{ Arg = 'BeforeSlot'; Input = 2 }
                        )
                     } `
                    -Delimited
                Set-CardanoMintContractTimeLock `
                    -MintContract $MintContract `
                    -AfterSlot $timelock[0] `
                    -BeforeSlot $timelock[1]
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
