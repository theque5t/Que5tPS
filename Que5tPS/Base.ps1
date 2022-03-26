function New-ParamsObject {
    param(
        $Invocation,
        $BoundParameters
    )
    $params = @{}
    foreach($h in $Invocation.MyCommand.Parameters.GetEnumerator()) {
        try {
            $key = $h.Key
            $val = Get-Variable -Name $key -ErrorAction Stop | `
                   Select-Object -ExpandProperty Value -ErrorAction Stop
            
            if (([String]::IsNullOrEmpty($val) -and (!$BoundParameters.ContainsKey($key)))) {
                throw "A blank value that wasn't supplied by the user."
            }
            Write-Verbose "$key => '$val'"
            $params[$key] = $val
        } 
        catch {}
    }
    return $params
}

function DynamicParameter {
    param(
        [parameter(Mandatory=$true)]
        [string]$Name,
        [hashtable]$Attributes,
        $ValidateSet,
        [Type]$Type = [psobject]
    )
    $paramAttributes = New-Object `
        -Type System.Management.Automation.ParameterAttribute
            
    $Attributes.GetEnumerator().ForEach({
        $paramAttributes.$($_.Key) = $_.Value
    })

    $paramAttributesCollect = New-Object `
        -Type System.Collections.ObjectModel.Collection[System.Attribute]
    $paramAttributesCollect.Add($paramAttributes)

    if($ValidateSet)
	{
		$validateSetAttribute = New-Object `
            System.Management.Automation.ValidateSetAttribute($ValidateSet)
        $paramAttributesCollect.Add($validateSetAttribute)
	}

    $dynParam = New-Object -Type `
        System.Management.Automation.RuntimeDefinedParameter(
            $Name,
            $Type,
            $paramAttributesCollect
    )

    return $dynParam
}

function DynamicParameterDictionary {
    param
    (
        [parameter(Position=0)]
        [System.Management.Automation.RuntimeDefinedParameter[]]$Parameters
    )
    $parameterDictionary = New-Object `
        -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    $Parameters.ForEach({
        $parameterDictionary.Add($_.Name, $_)
    })

    return $parameterDictionary
}

function Write-VerboseLog {
    [CmdletBinding()]
    param(
        $Message
    )  
    Write-Verbose "$(Get-Date -Format "o") | $Message"
}


function Write-TerminatingError {
    param(
        $Exception
    )
    throw "$Exception"
}

function Get-FunctionName ([int]$StackNumber = 1) {
    return [string]$(Get-PSCallStack)[$StackNumber].FunctionName
}

function Write-FalseAssertionError {
    Write-TerminatingError "False Assertion: $(Get-FunctionName -StackNumber 2)"
}

function Assert-CommandSuccessful{
    if($LastExitCode){
        Write-FalseAssertionError
    }
}

function Get-DefaultParameterValue([string] $Command, [string] $Parameter) {
    foreach ($entry in $PSDefaultParameterValues.GetEnumerator()) {
        $commandPattern, $parameterName = $entry.Key.Split(':')
        if ($Command -like $commandPattern -and $Parameter -eq $parameterName) {
            $value = $entry.Value
            if($value.GetType().Name -eq 'ScriptBlock'){
                $value = $value.Invoke()
            }
            return $value
        }
    }
}

function Get-BoundValueElseDefaultValue{
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true,Position=0)]
        [string] $Parameter,
        [parameter(Mandatory=$true,Position=1)]
        [hashtable] $Parameters,
        [parameter(Position=2)]
        [string] $Command = [string]$(Get-PSCallStack)[1].FunctionName
    )
    if($Parameters.$Parameter){
        $value = $Parameters.$Parameter
    }
    else{
        $value = Get-DefaultParameterValue -Command $Command -Parameter $Parameter
    }
    return $value
}

function Write-HostBatch {
    [CmdletBinding()]
    param(
        $Batch
    )
    $Batch.ForEach({ 
        Write-Verbose "Processing: $($_.Object)"
        $_args = $_
        $prefix = $false
        if($_args.Contains('Prefix')){
            $prefix = $true
            $prefixArgs = $_args.Prefix
            $_args.Remove('Prefix')
        }
        Write-Verbose "`$_args.Object: $($_args.Object)"
        $lines = $_args.Object -split "`r`n"
        Write-Verbose "`$lines.Count: $($lines.Count)"
        $lines.ForEach({
            if($prefix){ Write-Host @prefixArgs }
            $_args.Object = $_
            Write-Host @_args
        })
    })
}

function Get-OptionSelection {
    [CmdletBinding()]
    param(
        [array]$Options,
        $Instruction,
        $OptionDisplayTemplate = @(
            @{ Expression = '$($option.Key)'; ForegroundColor = 'Cyan'; NoNewline = $true},
            @{ Expression = ') $($option.Value)' }
            @{ NoNewline = $false }
        ),
        [switch]$MultipleChoice,
        $Delimiter = ','
    )
    
    $optionsAvailable = [ordered]@{}
    $Options.ForEach({
        $key = "$($optionsAvailable.Count + 1)"
        Write-Verbose "`$optionsAvailable.Add($key, $_)"
        $optionsAvailable.Add($key, $_)
    })

    $selectionOutput = New-Object System.Collections.ArrayList
    $selectionOutput.Add(@{ NoNewline = $false }) | Out-Null
    $selectionOutput.Add(@{ Object = $Instruction; ForegroundColor = 'Yellow' }) | Out-Null
    Write-Verbose "`$selectionOutput.Count: $($selectionOutput.Count)"
    $optionsAvailable.GetEnumerator().ForEach({
        $option = $_
        Write-Verbose "`$option.Key: $($option.Key)"
        Write-Verbose "`$option.Value: $($option.Value)"
        Write-Verbose "`$OptionDisplayTemplate.Count: $($OptionDisplayTemplate.Count)"
        $OptionDisplayTemplate.ForEach({
            $template = $_
            Write-Verbose "`$template.Keys: $($template.Keys)"
            Write-Verbose "`$template.Values: $($template.Values)"
            $renderedTemplate = $template.Clone()
            Write-Verbose "`$renderedTemplate.Keys: $($renderedTemplate.Keys)"
            Write-Verbose "`$renderedTemplate.Values: $($renderedTemplate.Values)"
            if($renderedTemplate.ContainsKey('Expression')){
                Write-Verbose "`$renderedTemplate.ContainsKey('Expression'): true"
                $expandedExpression = $ExecutionContext.InvokeCommand.ExpandString($renderedTemplate.Expression)
                Write-Verbose "`$expandedExpression: $expandedExpression"
                $renderedTemplate.Add('Object', $expandedExpression)
                $renderedTemplate.Remove('Expression')
            }
            Write-Verbose "`$renderedTemplate.Keys: $($renderedTemplate.Keys)"
            Write-Verbose "`$renderedTemplate.Values: $($renderedTemplate.Values)"
            $selectionOutput.Add($renderedTemplate) | Out-Null
        })
    })
    Write-Verbose "`$selectionOutput.Count: $($selectionOutput.Count)"
    Write-HostBatch $selectionOutput

    do{
        Write-Host "Input: " -ForegroundColor Yellow -NoNewline
        $optionSelection = Read-Host
        Write-Host
        $optionSelection = $MultipleChoice ? $optionSelection.split($Delimiter).Trim() : $optionSelection.Trim()
        Write-Verbose "`$optionSelection: $optionSelection"
        Write-Verbose "`$optionSelection.Count: $($optionSelection.Count)"
        $optionValue = New-Object System.Collections.ArrayList
        $validOptionSelection = $true
        switch($optionSelection) {
            {$optionsAvailable.Contains($_)} {
                $optionValue.Add($optionsAvailable[$_]) | Out-Null
            }
            default { 
                $validOptionSelection = $false
                Write-Host "Invalid Selection: $_" -ForegroundColor Red
            }
        }
    }
    while(-not $validOptionSelection)
    return $optionValue
}

function Get-FreeformInput {
    [CmdletBinding()]
    param(
        $Instruction,
        $InputType,
        [ValidateSet('InRange','MatchPattern','TestCommand')]
        $ValidationType,
        $ValidationParameters,
        [switch]$Delimited,
        $Delimiter = ','
    )

    Write-Host $Instruction -ForegroundColor Yellow

    do{
        Write-Host "Input: " -ForegroundColor Yellow -NoNewline
        $input = Read-Host
        Write-Host
        $input = $Delimited ? $input.split($Delimiter).Trim() : $input.Trim()
        Write-Verbose "`$input: $input"
        Write-Verbose "`$input.Count: $($input.Count)"
        $inputValue = New-Object System.Collections.ArrayList
        
        $validInput = $true
        $input.ForEach({
            $value = $_
            $value = $value -as ($InputType -as [type])
            switch ($ValidationType) {
                'InRange' { 
                    Write-Verbose "`$ValidationType: $_"
                    Write-Verbose "`$value: $value"
                    Write-Verbose "`$ValidationParameters.Minimum: $($ValidationParameters.Minimum)"
                    Write-Verbose "`$ValidationParameters.Maximum: $($ValidationParameters.Maximum)"
                    $validated = (
                        ( $value -ge $ValidationParameters.Minimum ) -and 
                        ( $value -le $ValidationParameters.Maximum )
                    )
                    Write-Verbose "`$validated: $validated"
                 }
                'MatchPattern' {
                    $validated = $value -match $ValidationParameters.Pattern
                }
                'TestCommand' {
                    $commandArgs = @{ $ValidationParameters.ValueArg = $value }
                    $validated = & $ValidationParameters.Command @commandArgs
                }
            }
            if($validated){ $inputValue.Add($value) | Out-Null }
            else{ 
                $validInput = $false
                Write-Host "Invalid Selection: $value" -ForegroundColor Red 
            }
        })
    }
    while(-not $validInput)

    return $inputValue
}

function Copy-Object($Object) {
    $copy = @()
    $Object.ForEach({
        $currentObject = $_
        $currentObjectCopy = New-Object $currentObject.GetType().Name
        $currentObjectCopy.psobject.Properties.ForEach({
            $_.Value = $currentObject.psobject.Properties[($_.Name)].Value
        })
        $copy += $currentObjectCopy
    })    
    return $copy
}

function ConvertTo-RoundNumber {
    param(
        [parameter(Mandatory = $true)]
        $Number,
        $DecimalPlaces = 0
    )
    return [math]::Round($Number,$DecimalPlaces)
}

function ConvertTo-IntPercentage {
    param(
        [parameter(Mandatory = $true)]
        $Number
    )
    $roundNumber = ConvertTo-RoundNumber -Number $Number -DecimalPlaces 2
    $intPercentage = $roundNumber * 100
    return $intPercentage
}