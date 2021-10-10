function prompt {
     $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
       else { '' }) + 'PS ' + (Get-Item -Path (Get-Location)).BaseName +
         $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
}

$(Get-ChildItem -Path "$PSScriptRoot/Scripts" -Filter *.ps1).ForEach({. $_.FullName})
