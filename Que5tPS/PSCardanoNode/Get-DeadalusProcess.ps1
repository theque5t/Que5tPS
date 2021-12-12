function Get-DeadalusProcess {
    $process = $(Get-Process -Verbose:$false).Where({
        $_.Path -like "$env:DEADALUS_HOME\Daedalus*"
    })

    return $process
}
