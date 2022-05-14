function Test-CardanoTokenNameIsValid {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    return [bool]$( $Name -match '^[\w ]+$' )
}
