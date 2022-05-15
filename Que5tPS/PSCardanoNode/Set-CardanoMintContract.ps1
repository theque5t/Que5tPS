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
                'Set Witnesses'
                if(Test-CardanoMintContractHasPolicyId -MintContract $MintContract){
                    'Set Time Lock'
                    'Set Token Specification'
                }
                if(Test-CardanoMintContractHasTokenSpecifications -MintContract $MintContract){
                    'Minted Token Implementation'
                }
                'Done Editing'
            )
    
        switch($actionSelection){
            'Set Witnesses' {
                Set-CardanoMintContractWitnesses `
                    -MintContract $MintContract `
                    -VerificationKeys $(
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
            'Set Token Specification' {
                Set-CardanoMintContractTokenSpecification `
                    -MintContract $MintContract `
                    -Name $(
                        Get-FreeformInput `
                            -Instruction $(
                                "Specify the token name:"
                            ) `
                            -InputType 'string' `
                            -ValidationType TestCommand `
                            -ValidationParameters @{ 
                                Command = 'Test-CardanoTokenNameIsValid'
                                ValueArg = 'Name' 
                            }

                    ) `
                    -SupplyLimit $(
                        Get-FreeformInput `
                            -Instruction $(
                                "Specify the token supply limit"
                            ) `
                            -InputType 'Int64' `
                            -ValidationType InRange `
                            -ValidationParameters @{ 
                                Minimum = 1
                                Maximum = 10000 # arbitrary limit for now
                            }
                    ) `
                    -MetaData $(
                        Get-FreeformInput `
                            -Instruction $(
                                "Specify the token meta data"
                            )
                    )
            }
            'Minted Token Implementation' {
                $tokenName = Get-FreeformInput `
                    -Instruction $(
                        "Specify the token name:"
                    ) `
                    -InputType 'string' `
                    -ValidationType TestCommand `
                    -ValidationParameters @{ 
                        Command = 'Test-CardanoTokenNameIsValid'
                        ValueArg = 'Name' 
                    }

                Update-CardanoMintContractTokenImplementation `
                    -MintContract $MintContract `
                    -Name $tokenName `
                    -MintedDifference $(
                        Get-FreeformInput `
                            -Instruction $(
                                "Specify the amount minted:"
                            ) `
                            -InputType 'Int64' `
                            -ValidationType InRange `
                            -ValidationParameters @{ 
                                Minimum = 0
                                Maximum = $(
                                    Get-CardanoMintContractTokenImplementationUnMinted `
                                        -MintContract $MintContract `
                                        -Name $tokenName
                                )
                            }
                    )
            }
            'Burned Token Implementation' {
                $tokenName = Get-FreeformInput `
                    -Instruction $(
                        "Specify the token name:"
                    ) `
                    -InputType 'string' `
                    -ValidationType TestCommand `
                    -ValidationParameters @{ 
                        Command = 'Test-CardanoTokenNameIsValid'
                        ValueArg = 'Name' 
                    }

                Update-CardanoMintContractTokenImplementation `
                    -MintContract $MintContract `
                    -Name $tokenName `
                    -BurnedDifference $(
                        Get-FreeformInput `
                            -Instruction $(
                                "Specify the amount burned:"
                            ) `
                            -InputType 'Int64' `
                            -ValidationType InRange `
                            -ValidationParameters @{ 
                                Minimum = 0
                                Maximum = $(
                                    Get-CardanoMintContractTokenImplementationMinted `
                                        -MintContract $MintContract `
                                        -Name $tokenName
                                )
                            }
                    )
            }
            'Done Editing'{
                $interactionComplete = $true
            }
        }
    }
    until($interactionComplete)
    Format-CardanoMintContractSummary -MintContract $MintContract
}
