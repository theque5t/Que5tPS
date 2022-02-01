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
        Write-Host @_
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
        )
    )
    
    $optionsAvailable = [ordered]@{}
    $Options.ForEach({
        $key = "$($optionsAvailable.Count + 1)"
        Write-Verbose "`$optionsAvailable.Add($key, $_)"
        $optionsAvailable.Add($key, $_)
    })

    $selectionOutput = New-Object System.Collections.ArrayList
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

    $validOptionSelection = $false
    do{
        Write-Host "Input: " -NoNewline
        $optionSelection = Read-Host
        $optionSelection = $optionSelection.Trim()
        switch($optionSelection) {
            {$optionsAvailable.Contains($optionSelection)} {
                $validOptionSelection = $true
                $optionSelection = $optionsAvailable[$optionSelection]
            }
            default { Write-Host "Invalid Selection: $_" -ForegroundColor Red }
        }
    }
    while(-not $validOptionSelection)
    return $optionSelection
}

function Get-FreeformInput {
    [CmdletBinding()]
    param(
        $Instruction,
        [switch]$Csv
    )
    Write-HostBatch @(
        @{ Object = $Instruction; ForegroundColor = 'Yellow' }
        @{ Object = 'Input: '; ForegroundColor = 'Yellow'; NoNewline = $true }
    )
    $input = Read-Host
    Write-Host
    if($Csv){ $input = $input.split(",").Trim()}
    return $input
}
