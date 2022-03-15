function Format-CardanoTransactionSummary {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    $_labelPrefix = @{ Object = '  - '; NoNewline = $true }
    $_valuePrefix = @{ Object = '    '; NoNewline = $true }
    
    $_header = @(
        @{ Object = '=' * 125 }
        @{ Object = ' ' * 53 + 'TRANSACTION SUMMARY' + ' ' * 53 }
        @{ Object = '=' * 125 }
    )

    $_hasInputs = $Transaction | Test-CardanoTransactionHasInputs
    $_inputsSection = @(
        @{ Object = '+--------+' + '-' * 115; ForegroundColor = 'DarkGray' }
        @{ Object = '| INPUTS | Description: Funds being spent'; ForegroundColor = 'DarkGray' }
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
            Object = 'UTXOs: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasInputs }
    )
    if($_hasInputs){
    $inputs = $Transaction | Get-CardanoTransactionInputs 
    $inputs.ForEach({ 
        $_inputsSection += 
        @{ Object = '' },
        @{ Prefix = @{ Object = '    | '; NoNewline = $true } 
            Object = 'Id: '; ForegroundColor = 'Yellow'; NoNewline = $true },
        @{ Object = $_.Id },
        @{ Prefix = @{ Object = '    | '; NoNewline = $true } 
            Object = 'Data: '; ForegroundColor = 'Yellow'; NoNewline = $true },
        @{ Object = $_.Data },
        @{ Prefix = @{ Object = '    | '; NoNewline = $true }
            Object = 'From Address: '; ForegroundColor = 'Yellow'; NoNewline = $true },
        @{ Object = $_.Address },
        @{ Prefix = @{ Object = '    | '; NoNewline = $true }
            Object = 'Tokens:'; ForegroundColor = 'Yellow' },
        @{ Prefix = @{ Object = '    |  '; NoNewline = $true }; 
            Object = $_.Value | Format-Table "PolicyId", "Name", "Quantity" | Out-String },
        @{ Object = '' }
    })}
    else{
        $_inputsSection += @{ Object = 'None' }
    }
    $_inputsSection += @{ NoNewLine = $_hasInputs }
    
    $_hasUnallocatedTokens = $Transaction | Test-CardanoTransactionHasUnallocatedTokens
    $_hasAllocatedTokens = $Transaction | Test-CardanoTransactionHasAllocatedTokens
    $_allocationsSection = @(
        @{ Object = '+--------------+' + '-' * 109; ForegroundColor = 'DarkGray' }
        @{ Object = '| DISTRIBUTION | Description: Allocations of funds being spent'; ForegroundColor = 'DarkGray'  }    
        @{ Object = '+--------------+'; ForegroundColor = 'DarkGray'  }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
           Object = 'Unallocated Tokens: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasUnallocatedTokens }
        @{ Prefix = $_hasUnallocatedTokens ? $_valuePrefix : @{ Object = ''; NoNewline = $true }
           Object = $_hasUnallocatedTokens ? $($Transaction | Get-CardanoTransactionUnallocatedTokens | Out-String) : 'None' }
        @{ NoNewLine = $_hasUnallocatedTokens }
        @{ Prefix = $_labelPrefix;
           Object = 'Allocations: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasAllocatedTokens }
    )
    if($_hasAllocatedTokens){
        $allocations = $Transaction | Get-CardanoTransactionAllocations
        $allocations.ForEach({ 
            $_allocationsSection += 
            @{ Object = '' },
            @{ Prefix = @{ Object = '    | '; NoNewline = $true } 
               Object = 'Recipient: '; ForegroundColor = 'Yellow'; NoNewline = $true },
            @{ Object = $_.Recipient },
            @{ Prefix = @{ Object = '    | '; NoNewline = $true }
               Object = 'Tokens:'; ForegroundColor = 'Yellow' },
            @{ Prefix = @{ Object = '    |  '; NoNewline = $true }; 
               Object = $_.Value | Format-Table "PolicyId", "Name", "Quantity" | Out-String },
            @{ Object = '' }
    })}
    else{
        $_allocationsSection += @{ Object = 'None' }
    }
    $_allocationsSection += @{ NoNewLine = $_hasAllocatedTokens }
        
    $_hasChangeRecipient = $Transaction | Test-CardanoTransactionHasChangeRecipient
    $_hasChangeAllocation = $Transaction | Test-CardanoTransactionHasChangeAllocation
    $_changeSection = @(
        @{ Object = '+--------+' + '-' * 115; ForegroundColor = 'DarkGray' }
        @{ Object = '| CHANGE | Description: Allocation for any unallocated funds'; ForegroundColor = 'DarkGray' }    
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
        @{ Prefix = @{ Object = '    | '; NoNewline = $true };
           Object = 'Recipient: '; ForegroundColor = 'Yellow'; NoNewline = $true }
        @{ Object = $_hasChangeRecipient ? $Transaction.ChangeRecipient : 'None - Not specified' }
        @{ Prefix = @{ Object = '    | '; NoNewline = $true };
           Object = 'Tokens: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasChangeAllocation }
        @{ Prefix = $_hasChangeAllocation ? @{ Object = '    | '; NoNewline = $true } : @{ Object = ''; NoNewline = $true }
           Object = $_hasChangeAllocation ? $($($Transaction | Get-CardanoTransactionChangeAllocation).Value | Out-String) : 'None' }
        @{ NoNewLine = $_hasChangeAllocation }
        @{ Object = '' }
    )

    $_hasFeeAllocations = $Transaction | Test-CardanoTransactionHasFeeAllocations
    $_feeSection = @(
        @{ Object = '+------+' + '-' * 117; ForegroundColor = 'DarkGray' }
        @{ Object = '| FEES | Description: Costs associated to transaction'; ForegroundColor = 'DarkGray' }
        @{ Object = '+------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
           Object = 'Minimum transaction fee: '; ForegroundColor = 'Yellow'; NoNewLine = $true}
        @{ Object = $Transaction | Get-CardanoTransactionMinimumFee }
        @{ Prefix = $_labelPrefix;
           Object = 'Fee Allocations: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasFeeAllocations }
        @{ Prefix = $_hasFeeAllocations ? $_valuePrefix : @{ Object = ''; NoNewline = $true }
           Object = $_hasFeeAllocations ? $($Transaction | Get-CardanoTransactionFeeAllocationsStatus | Format-Table | Out-String) : 'None' }
        @{ NoNewLine = $_hasFeeAllocations }
    )

    $_hasOutputs = $Transaction | Test-CardanoTransactionHasOutputs
    $_outputs = @(
        @{ Object = '+---------+' + '-' * 114; ForegroundColor = 'DarkGray' }
        @{ Object = '| OUTPUTS | Description: Spending implementation for funds based on allocations and fees'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+---------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
    )
    if($_hasOutputs){
        $outputs = $Transaction | Get-CardanoTransactionOutputs
        $outputs.ForEach({ 
            $_outputs += 
            @{ Prefix = @{ Object = '    | '; NoNewline = $true } 
               Object = 'Address: '; ForegroundColor = 'Yellow'; NoNewline = $true },
            @{ Object = $_.Address },
            @{ Prefix = @{ Object = '    | '; NoNewline = $true }
               Object = 'Tokens:'; ForegroundColor = 'Yellow' },
            @{ Prefix = @{ Object = '    |  '; NoNewline = $true }; 
               Object = $_.Value | Format-Table "PolicyId", "Name", "Quantity" | Out-String },
            @{ Object = '' }
    })}
    else{
        $_outputs += @{ Prefix = $_valuePrefix; Object = 'None' }
    }
    $_outputs += @{ NoNewLine = $_hasOutputs }

    $_status = @(
        @{ Object = '+--------+' + '-' * 115; ForegroundColor = 'DarkGray' }
        @{ Object = '| STATUS | Description: State of transaction'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = $Transaction | Get-CardanoTransactionStatus | Format-Table | Out-String }
    )

    $_footer = @(
        @{ Object = '=' * 125 }
    )

    Write-HostBatch $(
        $_header + 
        $_inputsSection + 
        $_allocationsSection + 
        $_changeSection + 
        $_feeSection + 
        $_outputs +
        $_status +
        $_footer
    )
}