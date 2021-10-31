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

function New-DynamicParameter {
    param(
        [string]$Name,
        [hashtable]$Attributes,
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

    $dynParam = New-Object -Type `
        System.Management.Automation.RuntimeDefinedParameter(
            $Name,
            $Type,
            $paramAttributesCollect
    )

    return $dynParam
}