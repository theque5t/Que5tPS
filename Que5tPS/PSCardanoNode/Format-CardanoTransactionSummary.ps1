function Format-CardanoTransactionSummary {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    $_allocationFormat = { 
        $args[0] | Select-Object Address, Value -ExpandProperty Value |
        Format-Table PolicyId, Name, Quantity, @{Label="Recipient";Expression={$_.Address}} |
        Out-String
    }
    $_labelPrefix = @{ Object = '  - '; NoNewline = $true }
    $_valuePrefix = @{ Object = '    '; NoNewline = $true }
    
    $_header = @(
        @{ Object = '=' * 97 }
        @{ Object = ' ' * 39 + 'TRANSACTION SUMMARY' + ' ' * 39 }
        @{ Object = '=' * 97 }
    )

    $_hasInputs = $Transaction.HasInputs()
    $_inputsSection = @(
        @{ Object = '+--------+' + '-' * 87; ForegroundColor = 'DarkGray' }
        @{ Object = '| INPUTS | Description: Funds being spent'; ForegroundColor = 'DarkGray' }
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
            Object = 'UTXOs: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasInputs }
    )
    if($_hasInputs){
    $Transaction.Inputs.ForEach({ 
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
    
    $_hasUnallocatedTokens = $Transaction.HasUnallocatedTokens()
    $_hasAllocatedTokens = $Transaction.HasAllocatedTokens()
    $_allocationsSection = @(
        @{ Object = '+---------+' + '-' * 86; ForegroundColor = 'DarkGray' }
        @{ Object = '| OUTPUTS | Description: Allocations of funds being spent'; ForegroundColor = 'DarkGray'  }    
        @{ Object = '+---------+'; ForegroundColor = 'DarkGray'  }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
            Object = 'Unallocated Tokens: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasUnallocatedTokens }
        @{ Prefix = $_hasUnallocatedTokens ? $_valuePrefix : @{ Object = ''; NoNewline = $true }
            Object = $_hasUnallocatedTokens ? $($Transaction.GetUnallocatedTokens() | Out-String) : 'None' }
        @{ NoNewLine = $_hasUnallocatedTokens }
        @{ Prefix = $_labelPrefix;
            Object = 'Allocated Tokens: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasAllocatedTokens }
        @{ Prefix = $_hasAllocatedTokens ? $_valuePrefix : @{ Object = ''; NoNewline = $true }
            Object = $_hasAllocatedTokens ? $(& $_allocationFormat $Transaction.GetAllocations()) : 'None' }
        @{ NoNewLine = $_hasAllocatedTokens }
    )
    
    $_hasChangeAddress = $Transaction.HasChangeAddress()
    $_changeSection = @(
        @{ Object = '+--------+' + '-' * 87; ForegroundColor = 'DarkGray' }
        @{ Object = '| CHANGE | Description: Allocation for any unallocated funds'; ForegroundColor = 'DarkGray' }    
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
            Object = 'Change Recipient: '; ForegroundColor = 'Yellow'; NoNewline = $true }
        @{ Object = $_hasChangeAddress ? $Transaction.ChangeAddress : 'None - Not specified' }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
            Object = 'Change Tokens: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasChangeAddress }
        @{ Prefix = $_hasChangeAddress ? $_valuePrefix : @{ Object = ''; NoNewline = $true }
            Object = $_hasChangeAddress ? $($Transaction.GetChangeTokens() | Out-String) : 'None - Requires change recipient' }
        @{ NoNewLine = $_hasChangeAddress }
    )

    $_feeSection = @(
        @{ Object = '+------+' + '-' * 89; ForegroundColor = 'DarkGray' }
        @{ Object = '| FEES | Description: Costs associated to transaction'; ForegroundColor = 'DarkGray' }
        @{ Object = '+------+'; ForegroundColor = 'DarkGray' }
        @{ Object = '' }
        @{ Prefix = $_labelPrefix;
           Object = 'Minimum transaction fee: '; ForegroundColor = 'Yellow'; NoNewLine = $true}
        @{ Object = $Transaction.GetMinimumFee()}
        @{ Object = '' }
    )

    $_footer = @(
        @{ Object = '=' * 97 }
    )

    Write-HostBatch $(
        $_header + $_inputsSection + $_allocationsSection + $_changeSection + $_feeSection + $_footer
    )
}