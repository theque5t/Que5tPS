function Get-NextQue5tGramName {
    param(
        $SeriesName
    )
    $name = "$($SeriesName)-1"
    $seriesDirs = $(Get-ChildItem).Where({ $_.Name -match "^$SeriesName-[0-9]+$" })
    if($seriesDirs)
    {
        $naturalOrder = { [regex]::Replace($_, '\d+', { $args[0].Value.PadLeft(20) }) }
        $name="$SeriesName-$(
            [int]$(
                $seriesDirs | `
                Sort-Object -Descending $naturalOrder | `
                Select-Object -First 1
            ).Name.Split("-")[1]+1
        )"
    }
    return $name
}

function New-Que5tGramObject {
    param(
        $Params
    )
    $que5tGram = $Params
    $que5tGram.Config = $que5tGram.Config | ConvertFrom-Yaml
    $que5tGram.Name = Get-NextQue5tGramName @Params
    $que5tGram.Dir = @{}
    $que5tGram.File = @{}
    $que5tGram.Dir.Base = $que5tGram.Name
    $que5tGram.Dir.Frames = "$($que5tGram.Dir.Base)\frames"
    $que5tGram.File.Main = "$($que5tGram.Name).puml"
    $que5tGram.File.Style = "$($que5tGram.Name).style.puml"
    $que5tGram.File.NodeTypes = "$($que5tGram.Name).nodetypes.puml"
    $que5tGram.File.Nodes = "$($que5tGram.Name).nodes.puml"
    $que5tGram.File.Actions = "$($que5tGram.Name).actions.puml"

    return $que5tGram
}

function Add-Que5tGramFileSet {
    param(
        [parameter(ValueFromPipeline)]
        $Que5tGram
    )
    
    $baseDir = $Que5tGram.Dir.Base
    if(Test-Path $baseDir) { throw "$baseDir already exists" }
    
    $Que5tGram.Dir.Values.Foreach({
        New-Item "$_" -ItemType 'Directory' | `
        Out-Null
    })

    $Que5tGram.File.Values.Foreach({
        New-Item "$($que5tGram.Dir.Base)\$_" -ItemType 'File' | `
        Out-Null
    })    


    @('@startuml'
      "!include $($Que5tGram.File.Style)"
      "!include $($Que5tGram.File.NodeTypes)"
      "!include $($Que5tGram.File.Nodes)"
      "!include $($Que5tGram.File.Actions)"
      '@enduml'
    ).ForEach({ 
        Add-Content "$_" -Path "$baseDir\$($Que5tGram.File.Main)" 
    })

    @("BackgroundColor $($Que5tgram.Config.style.background.color)"
      "Shadowing $($Que5tGram.Config.style.shadowing)"
      "defaultTextAlignment $($Que5tGram.Config.style.text.alignment)"
    ).ForEach({ 
        Add-Content "skinParam $_" -Path "$baseDir\$($Que5tGram.File.Style)" 
    })

    @("!define PLANTUML_ICON_FONT_SPRITES $($Que5tGram.PumlIcons)\plantuml-icon-font-sprites"
      '!include PLANTUML_ICON_FONT_SPRITES/common.puml'
      '!include PLANTUML_ICON_FONT_SPRITES/font-awesome/circle.puml'
      '!define node(e_scale,e_type,e_color,e_sprite,e_label,e_alias,e_stereo) e_type "<color:e_color><$e_sprite{scale=e_scale}></color>e_label" as e_alias <<e_stereo>>'
      '!define circle(_alias, _label, _shape, _color, _size) node(_size,_shape,_color,circle,_label,_alias,FA CIRCLE)'
      '!define sequence_circle(_alias, _label, _color, _size) circle(_alias, _label, participant, _color, _size)'
    ).ForEach({ 
        Add-Content "$_" -Path "$baseDir\$($Que5tGram.File.NodeTypes)" 
    })
}

function Add-Que5tGramNode {
    param(
        [parameter(ValueFromPipeline)]
        $Que5tGram,
        $Node
    )

    $nodeProperties = @{
        Alias = $Que5tGram.Nodes.IndexOf($Node)+1
        Label = ''
        Color = $Que5tGram.NodeBackgroundColor
        Size = $Que5tgram.NodeSize
        BackgroundColor = $Que5tGram.BackgroundColor
    }    

    switch ($Que5tGram.NodeTextPatternType) {
        'string' {
            $nodeProperties.Label = $Que5tGram.NodeTextPattern
        }
        
        'node' {
            $nodeProperties.Label = $nodeProperties.Alias
        }
        
        'nodeProperty' {
            $nodeProperties.Label = $Node[$NodeTextPattern]
        }
    }

    $nodeDeclarationOptions = @{
        'network' = @{
            'circle' = "() $($nodeProperties.Alias)"
            'rectangle' = "rectangle $($nodeProperties.Alias)"
        }
        'sequence' = @{
            'circle' = "sequence_circle($($nodeProperties.Alias),$($nodeProperties.Label),$($nodeProperties.Color),$($nodeProperties.Size)) #$($nodeProperties.BackgroundColor)"
            'rectangle' = "participant $($nodeProperties.Alias)"
        }
    }

    $nodeDeclaration = $nodeDeclarationOptions[$Que5tGram.VisualType][$Que5tGram.NodeType]
    Write-Verbose -Message "nodeDeclaration: $nodeDeclaration"
    if(-not $(Get-Content -Path $Que5tGram.PumlFileNodes.Path | Select-String -Pattern $nodeDeclaration))
    {
        Add-Content -Value $nodeDeclaration -Path $Que5tGram.PumlFileNodes.Path
    }
}

function Add-Que5tGramAction {
    param(
        [parameter(ValueFromPipeline)]
        $Que5tGram
    )

    $action = @{ 
        Type = $Que5tGram.ActionType
        From = ""
        To = ""
        Message = "" 
    }

    switch ($Que5tGram.NodeVisibilityMethod) {
        'alwaysVisible' { 
            $Que5tGram.Nodes.ForEach({
                Write-Verbose -Message "Set node $_ visible"
                $Que5tGram | Add-Que5tGramNode -Node $_
            })
        }

        'appearOnConnection' {}
    }

    ('From','To').ForEach({
        $property = $_
        switch ($Que5tGram["Action$($property)PatternType"]) {
            'string' {
                Write-Verbose -Message "Set action.$property with string"
                $action[$property] = $Que5tGram["Action$($property)Pattern"]
            }
            
            'randomSpecifiedNode' {
                Write-Verbose -Message "Set action.$property with randomSpecifiedNode"
                $action[$property] = Get-Random -InputObject $Que5tGram.Nodes
            }

            'regexCaptureGroup1' {}
        }
    })

    
    switch ($Que5tGram.ActionMessagePatternType) {
        'string' { 
            $action.Message = $Que5tGram.ActionMessagePattern
         }

         'regexCaptureGroup1' {}
    }

    Add-Content -Value "$($action.From) $($action.Type) $($action.To) : $($action.Message)" -Path $Que5tGram.PumlFileActions.Path
}

function Add-Que5tGramFrames {
    param(
        [parameter(ValueFromPipeline)]
        $Que5tGram
    )

    $workingFrameFile = "$($Que5tGram.GramDir.Path)\$($Que5tGram.Name).png"
    $actionIdPadding = $Que5tGram.Actions.Count.ToString().length
    $actionIdCurrent = 1
    $Que5tGram.Actions.ForEach({ 
        $Que5tGram | Add-Que5tGramAction
        Invoke-PlantUML $Que5tGram.PumlFileMain.Path
        $frameFile = "$($Que5tGram.GramFramesDir.Path)\frame_$("$actionIdCurrent".PadLeft($actionIdPadding,'0')).png"
        Copy-Item $workingFrameFile -Destination $frameFile
        $actionIdCurrent++ 
    })
}

function Add-Que5tGramAnimation {
    param(
        [parameter(ValueFromPipeline)]
        $Que5tGram
    )

    $magickArgs = @(
        'convert',
        '-delay', $Que5tGram.Delay,
        "$($Que5tGram.GramFramesDir.Path)\*.png",
        '-resize', '1024x1024',
        '-gravity', 'Center',
        '-background', $Que5tGram.BackgroundColor,
        '-extent', '1024x1024',
        '-loop', 0,
        "$($Que5tGram.GramDir.Path)\$($Que5tGram.Name).gif"
    )

    Write-Verbose "magickArgs: $magickArgs"
    magick @magickArgs
}

function New-Que5tGram {
    [cmdletbinding()]
    param(
        [ValidateSet('network','sequence')]
        $VisualType = 'network',

        $SeriesName = "Que5tGram",

        [array]$Nodes = @('Node'),
        [array]$Actions = @('An action'),

        [ValidateSet('string','randomSpecifiedNode','regexCaptureGroup1')]
        $ActionFromPatternType = 'randomSpecifiedNode',
        $ActionFromPattern = '',
        [ValidateSet('string','randomSpecifiedNode','regexCaptureGroup1')]
        $ActionToPatternType = 'randomSpecifiedNode',
        $ActionToPattern = '',
        [ValidateSet('->','<-','-','-down-')]
        $ActionType = '->',
        [ValidateSet('string','regexCaptureGroup1')]
        $ActionMessagePatternType = 'string',
        $ActionMessagePattern = '',
        $ActionMessageFontColor = 'white',
        $ActionLineColor = 'white',
        $ActionLineThickness = 1,
        [ValidateSet('TODO')]
        $ActionLineType = 'TODO',

        [ValidateSet('alwaysVisible','appearOnConnection')]
        $NodeVisibilityMethod = 'appearOnConnection',
        [ValidateSet('circle','rectangle')]
        $NodeType = 'circle',
        [ValidateSet('string','node','nodeProperty')]
        $NodeTextPatternType = 'string',
        $NodeTextPattern = '',
        $NodeBackgroundColor = 'black',
        $NodeBorderColor = 'white',
        $NodeFontColor = 'white',
        $NodeLineColor = 'white',
        $NodeSize = '0.25',

        $BackgroundColor = 'black',
        $Shadowing = 'false',
        $TextAlignment = 'center',
        $Delay = 30,
        $PumlIcons = $env:PLANTUML_ICONS
    )

    try {
        $params = New-ParamsObject -Invocation $MyInvocation -BoundParameters $PSBoundParameters
        $que5tGram = New-Que5tGramObject -Params $params
        $que5tGram | Add-Que5tGramFileSet
        $que5tGram | Add-Que5tGramFrames
        $que5tGram | Add-Que5tGramAnimation
    }
    catch {
        $_.Exception.Message
        $_.ScriptStackTrace
    }
}
