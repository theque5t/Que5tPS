function Format-CardanoTransactionSummary {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    $_labelPrefix = @{ Object = '  - '; NoNewline = $true }
    $_valuePrefix = @{ Object = '    '; NoNewline = $true }
    
    $_header = @(
        @{ Object = '=' * 129 }
        @{ Object = ' ' * 55 + 'TRANSACTION SUMMARY' + ' ' * 55 }
        @{ Object = '=' * 129 }
    )

    $_hasInputs = Test-CardanoTransactionHasInputs -Transaction $Transaction
    $_inputsSection = @(
        @{ Object = '+--------+' + '-' * 119; ForegroundColor = 'DarkGray' }
        @{ Object = '| INPUTS | Description: Funds being spent'; ForegroundColor = 'DarkGray' }
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
            Object = 'UTXOs: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasInputs }
    )
    if($_hasInputs){
    $inputs = Get-CardanoTransactionInputs -Transaction $Transaction 
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
    
    $_hasUnallocatedTokens = Test-CardanoTransactionHasUnallocatedTokens -Transaction $Transaction
    $_hasAllocatedTokens = Test-CardanoTransactionHasAllocatedTokens -Transaction $Transaction
    $_allocationsSection = @(
        @{ Object = '+--------------+' + '-' * 113; ForegroundColor = 'DarkGray' }
        @{ Object = '| DISTRIBUTION | Description: Allocations of funds being spent'; ForegroundColor = 'DarkGray'  }    
        @{ Object = '+--------------+'; ForegroundColor = 'DarkGray'  }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
           Object = 'Unallocated Tokens: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasUnallocatedTokens }
        @{ Prefix = $_hasUnallocatedTokens ? $_valuePrefix : @{ Object = ''; NoNewline = $true }
           Object = $_hasUnallocatedTokens ? $(Get-CardanoTransactionUnallocatedTokens -Transaction $Transaction | Out-String) : 'None' }
        @{ NoNewLine = $_hasUnallocatedTokens }
        @{ Prefix = $_labelPrefix;
           Object = 'Allocations: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasAllocatedTokens }
    )
    if($_hasAllocatedTokens){
        $allocations = Get-CardanoTransactionAllocations -Transaction $Transaction
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
        
    $_hasChangeRecipient = Test-CardanoTransactionHasChangeAllocationRecipient -Transaction $Transaction
    $_hasChangeAllocation = Test-CardanoTransactionHasChangeAllocation -Transaction $Transaction
    $_changeSection = @(
        @{ Object = '+--------+' + '-' * 119; ForegroundColor = 'DarkGray' }
        @{ Object = '| CHANGE | Description: Allocation for any unallocated funds'; ForegroundColor = 'DarkGray' }    
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
        @{ Prefix = @{ Object = '    | '; NoNewline = $true };
           Object = 'Recipient: '; ForegroundColor = 'Yellow'; NoNewline = $true }
        @{ Object = $_hasChangeRecipient ? $(Get-CardanoTransactionChangeAllocationRecipient -Transaction $Transaction) : 'None - Not specified' }
        @{ Prefix = @{ Object = '    | '; NoNewline = $true };
           Object = 'Tokens: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasChangeAllocation }
        @{ Prefix = $_hasChangeAllocation ? @{ Object = '    | '; NoNewline = $true } : @{ Object = ''; NoNewline = $true }
           Object = $_hasChangeAllocation ? $($(Get-CardanoTransactionChangeAllocation -Transaction $Transaction).Value | Out-String) : 'None' }
        @{ NoNewLine = $_hasChangeAllocation }
        @{ Object = '' }
    )

    $_hasAllocations = Test-CardanoTransactionHasAllocations -Transaction $Transaction
    $_feeSection = @(
        @{ Object = '+------+' + '-' * 121; ForegroundColor = 'DarkGray' }
        @{ Object = '| FEES | Description: Costs associated to transaction'; ForegroundColor = 'DarkGray' }
        @{ Object = '+------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
           Object = 'Minimum Transaction Fee: '; ForegroundColor = 'Yellow'; NoNewLine = $true}
        @{ Object = Get-CardanoTransactionMinimumFee -Transaction $Transaction }
        @{ Prefix = $_labelPrefix;
           Object = 'Fee Allocations: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasAllocations }
        @{ Prefix = $_hasAllocations ? $_valuePrefix : @{ Object = ''; NoNewline = $true }
           Object = $_hasAllocations ? $(Get-CardanoTransactionAllocationsFeeStatus -Transaction $Transaction | Format-Table | Out-String) : 'None' }
        @{ NoNewLine = $_hasAllocations }
    )

    $_hasOutputs = Test-CardanoTransactionHasOutputs -Transaction $Transaction
    $_outputs = @(
        @{ Object = '+---------+' + '-' * 118; ForegroundColor = 'DarkGray' }
        @{ Object = '| OUTPUTS | Description: Spending implementation for funds based on allocations and fees'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+---------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
    )
    if($_hasOutputs){
        $outputs = Get-CardanoTransactionOutputs -Transaction $Transaction
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
        @{ Object = '+--------+' + '-' * 119; ForegroundColor = 'DarkGray' }
        @{ Object = '| STATUS | Description: State of transaction'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-CardanoTransactionStatus -Transaction $Transaction | Format-Table | Out-String }
    )

    $_footer = @(
        @{ Object = '=' * 129 }
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