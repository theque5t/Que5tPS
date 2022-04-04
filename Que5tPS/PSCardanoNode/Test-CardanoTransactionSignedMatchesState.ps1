function Test-CardanoTransactionSignedMatchesState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [switch]$ReturnTests
    )
    $inputs = Get-CardanoTransactionInputs -Transaction $Transaction
    $inputTests = @()
    $inputs.ForEach({
        $inputTests += [PSCustomObject]@{
            Name = "$($_.Id) in inputs"
            Result = $_.Id -in $Transaction.SignedFileViewObject.inputs
        }
    })

    $outputs = Get-CardanoTransactionOutputs -Transaction $Transaction -Fee $Transaction.Fee
    $outputTests = @()
    $outputs.ForEach({
        $stateOutput = $_
        $signedOutput = $Transaction.SignedFileViewObject.outputs.Where({ $_.Address -eq $stateOutput.Address })
        if($signedOutput){
            $outputTests += [PSCustomObject]@{
                Name = "$($_.Address) in outputs"
                Result = $true
            }
            $stateOutput.Value.ForEach({
                $stateOutputValue = $_
                $outputTests += [PSCustomObject]@{
                    Name = "$($stateOutput.Address) value with PolicyId $($stateOutputValue.PolicyId), " +
                           "Name $($stateOutputValue.Name), and Quantity $($stateOutputValue.Quantity) in outputs"
                    Result = $($signedOutput.amount.GetEnumerator().Where({ 
                        $($_.Name -eq "$($stateOutputValue.PolicyId)$($stateOutputValue.Name)") -and
                        $($_.Value -eq $stateOutputValue.Quantity)
                    })).Count -eq 1
                }
            })
        }
    })

    $fee = Get-CardanoTransactionMinimumFee -Transaction $Transaction
    $feeTests = @(
        [PSCustomObject]@{
            Name = "Fee matches"
            Result = $fee -eq $Transaction.SignedFileViewObject.fee.TrimEnd(' Lovelace')
        }
    )

    $tests = $inputTests + $outputTests + $feeTests

    $result = [bool]$(
        $tests.Result -notcontains $false
    )
    if($ReturnTests){ $result = $Tests }

    return $result
}
