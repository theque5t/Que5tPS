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
        [parameter(Mandatory=$true,Position=0)]
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
