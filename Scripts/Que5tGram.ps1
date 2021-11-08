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

function New-Que5tGramParameters {
    param(
        $Params
    )
    $que5tGram = $Params
    $que5tGram.Config = $(Get-Content $que5tGram.Config | ConvertFrom-Yaml)
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

function New-Que5tGramFileSet {
    param(
        [parameter(ValueFromPipeline)]
        $Que5tGram
    )
    $baseDir = $Que5tGram.Dir.Base
    if(Test-Path $baseDir) { throw "$baseDir already exists" }
    
    ($Que5tGram.Dir.Base, $Que5tGram.Dir.Frames).ForEach({
        New-Item $_ -ItemType 'Directory' | Out-Null
    })

    $Que5tGram.File.Values.ForEach({
        New-Item "$baseDir\$_" -ItemType 'File' | Out-Null
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

    (@("BackgroundColor $($Que5tgram.Config.style.color.background)"
       "defaultFontColor $($Que5tGram.Config.style.color.text)"
       "Shadowing $($Que5tGram.Config.style.shadowing)"
       "defaultTextAlignment $($Que5tGram.Config.style.text.alignment)"
      ) + 
      @(if($Que5tgram.Config.visual_type -eq 'sequence'){ 
        "sequenceLifeLineBorderColor $($Que5tGram.Config.style.color.grid)"
      }) +
      $Que5tGram.Config.nodes.GetEnumerator().ForEach({
       "rectangleBorderColor<<$($_.alias)>> $($_.style.color.border)"
       "participantBorderColor<<$($_.alias)>> $($_.style.color.border)"
      })
    ).ForEach({ 
        Add-Content "skinParam $_" -Path "$baseDir\$($Que5tGram.File.Style)" 
    })

    @("!define icons_home $($Que5tGram.PumlIcons)"
      '!define lib_font_sprites icons_home\plantuml-icon-font-sprites'
      '!include lib_font_sprites/common.puml'
      '!include lib_font_sprites/font-awesome/circle.puml'
      '!include lib_font_sprites/font-awesome/square.puml'
      '!definelong sprite(e_scale,e_type,e_color,e_sprite,e_label,e_alias,e_stereo)'
      'e_type ' +
      '"<color:e_color><$e_sprite{scale=e_scale}></color>e_label" ' +
      'as e_alias <<e_stereo>>'
      '!enddefinelong'
      '!definelong circle(_alias,_label,_shape,_color,_size,_stereo)'
          'sprite(_size,_shape,_color,circle,_label,_alias,_stereo)'
      '!enddefinelong'
      '!definelong square(_alias,_label,_shape,_color,_size,_stereo)'
          'sprite(_size,_shape,_color,square,_label,_alias,_stereo)'
      '!enddefinelong'
      '!definelong sequence_circle(_alias,_label,_color,_size,_stereo)'
          'circle(_alias,_label,participant,_color,_size,_stereo)'
      '!enddefinelong'
      '!definelong sequence_square(_alias,_label,_color,_size,_stereo)'
          'square(_alias,_label,participant,_color,_size,_stereo)'
      '!enddefinelong'
      '!definelong network_circle(_alias,_label,_color,_size,_stereo)'
          'circle(_alias,_label,rectangle,_color,_size,_stereo)'
      '!enddefinelong'
      '!definelong network_square(_alias,_label,_color,_size,_stereo)'
          'square(_alias,_label,rectangle,_color,_size,_stereo)'
      '!enddefinelong'
    ).ForEach({ 
        Add-Content "$_" -Path "$baseDir\$($Que5tGram.File.NodeTypes)" 
    })
}

function Set-Que5tGramNodes {
    param(
        $Nodes,
        $Path,
        $VisualType
    )
    Clear-Content $Path
    
    $puml = '{0}_{1}({2},{3},{4},{5},{6}) #{7}'

    $Nodes.GetEnumerator().ForEach({
        Add-Content -Path $path -Value $(
            $puml -f (
                $VisualType,
                $_.type,
                $_.alias,
                $_.text,
                $_.style.color.shape,
                $_.style.size,
                $_.alias,
                $_.style.color.background
            )
        )    
    })
}

function Add-Que5tGramAction {
    param(
        [parameter(ValueFromPipeline)]
        $Action,
        $Path
    )
    $puml = '{0} {1}[{2}]{3}{4} {5} : {6}'

    Add-Content -Path $Path -Value $(
        $puml -f (
            $Action.from,
            $Action.style.line.from,
            $(
                (
                    $('#{0}' -f $($Action.style.line.color -join ';#')),
                    "$($Action.style.line.type)",
                    "$(if($Action.style.line.thickness){ 
                        "thickness=$($Action.style.line.thickness)" 
                    })"
                ).Where({ ![string]::IsNullOrWhitespace($_) }) -join ','
            ),
            $Action.style.line.direction,
            $Action.style.line.to,
            $Action.to,
            $Action.text
        )
    )
}

function New-Que5tGramFrames {
    param(
        [parameter(ValueFromPipeline)]
        $Que5tGram
    )
    $actions = $Que5tGram.Config.actions
    $nodes = $Que5tGram.Config.nodes

    $padding = "{0:d$($actions.Count.ToString().length)}"
    $frameRendered = "$($Que5tGram.Dir.Base)\$($Que5tGram.Name).png"
    $frameFinal = "$($Que5tGram.Dir.Frames)\$($padding).png"

    $setNodes = @{}
    $actionId = 1
    $actions.GetEnumerator().ForEach({
        $action = $_

        $setNodes = $nodes.Where({ 
            $_.alias -in ($action.from, $action.to) -or
            $_.visible_when -eq "always" -or
            $_.alias -in $setNodes.alias
         })
        Set-Que5tGramNodes `
            -Nodes $setNodes `
            -Path "$($Que5tGram.Dir.Base)\$($Que5tGram.File.Nodes)" `
            -VisualType $Que5tGram.Config.visual_type

        Add-Que5tGramAction `
            -Action $action `
            -Path "$($Que5tGram.Dir.Base)\$($Que5tGram.File.Actions)"
        
        Invoke-PlantUML "$($Que5tGram.Dir.Base)\$($Que5tGram.File.Main)"
        Copy-Item -Path $frameRendered -Dest $($frameFinal -f $actionId)
        $actionId++ 
    })
}

function New-Que5tGramAnimation {
    param(
        [parameter(ValueFromPipeline)]
        $Que5tGram
    )
    $magickArgs = @(
        'convert',
        '-delay', $Que5tGram.Config.animation.delay,
        "$($Que5tGram.Dir.Frames)\*.png",
        '-resize', '1024x1024',
        '-gravity', 'Center',
        '-background', $Que5tGram.Config.style.color.background,
        '-extent', '1024x1024',
        '-loop', 0,
        "$($Que5tGram.Dir.Base)\$($Que5tGram.Name).gif"
    )

    Write-Verbose "magick args: $magickArgs"
    magick @magickArgs
}


class Que5tGramAnimation {
    $delay = 30
}

class Que5tGramStyle {
    $color = @{
        background = 'black'
        text = 'white'
    }
    $shadowing = $false
    $text = @{
        alignment = 'center'
    }
}

class Que5tGramNodeStyle {
    $color = @{
        background = 'black'
        border = 'black'
        shape = 'white'
    }
    $size = 0.25
}

class Que5tGramNode {
    [ValidateSet('circle','square')]
    $type
    $alias
    $text
    [Que5tGramNodeStyle]$style = [Que5tGramNodeStyle]::new()
    [ValidateSet('always','connection')]
    $visible_when = 'connection'

    Que5tGramNode(
        $_type,
        $_alias
    ){
        $this.type = $_type
        $this.alias = $_alias
    }

    Que5tGramNode(
        $_type,
        $_alias,
        $_text
    ){
        $this.type = $_type
        $this.alias = $_alias
        $this.text = $_text
    }
}

class Que5tGramActionStyle {
    $line = @{
        from = '-'
        to = '->'
        type = 'plain'
        direction = 'down'
        color = 'white'
        thickness = 1
    }
}

class Que5tGramAction {
    $from
    $to
    $text
    [Que5tGramActionStyle]$style = [Que5tGramActionStyle]::new()
    
    Que5tGramAction(
        $_from,
        $_to
    ){
        $this.from = $_from
        $this.to = $_to
    }

    Que5tGramAction(
        $_from,
        $_to,
        $_text
    ){
        $this.from = $_from
        $this.to = $_to
        $this.text = $_text
    }
}

class Que5tGram {
    [ValidateSet('network','sequence')]
    $visual_type
    
    [Que5tGramAnimation]
    $animation = [Que5tGramAnimation]::new()

    [Que5tGramStyle]
    $style = [Que5tGramStyle]::new()

    [Que5tGramNode[]]
    $nodes
    
    [Que5tGramAction[]]
    $actions

    Que5tGram(
        $_visual_type
    ){
        $this.visual_type = $_visual_type
    }

    AddNode(
        $_type,
        $_alias,
        $_text
    ){ 
        $this.nodes += [Que5tGramNode]::new($_type, $_alias, $_text)
    }

    AddUniqueNode(
        $_type,
        $_alias,
        $_text
    ){
        if($this.nodes.alias -notcontains $_alias){ 
            $this.AddNode($_type, $_alias, $_text) 
        }
    }

    AddAction(
        $_from,
        $_to,
        $_text
    ){
        $this.actions += [Que5tGramAction]::new($_from, $_to, $_text)
    }
}

function New-Que5tGramRendering {
    [cmdletbinding()]
    param(
        $SeriesName = "Que5tGram",
        [Parameter(Mandatory=$true)]
        $Config,
        $PumlIcons = $env:PLANTUML_ICONS
    )
    try {
        $params = New-ParamsObject $MyInvocation $PSBoundParameters
        $que5tGram = New-Que5tGramParameters $params
        $que5tGram | New-Que5tGramFileSet
        $que5tGram | New-Que5tGramFrames
        $que5tGram | New-Que5tGramAnimation
    }
    catch {
        $_.Exception.Message
        $_.ScriptStackTrace
    }
}

function New-Que5tGramConfigs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('CardanoUtxo','GitFileEvo')]
        $SeriesType
    )
    DynamicParam {        
        switch ($SeriesType) {
            'CardanoUtxo' { 
                DynamicParameterDictionary (
                    (DynamicParameter -Name Blocks -Attributes @{ Mandatory = $true } -Type psobject)
                )
            }
        }
    }
    process {
        switch ($SeriesType) {
            'CardanoUtxo' { 
                # Create 1 gram per block
                $config = @{}
                $PSBoundParameters.Blocks.ForEach({
                    $block = $_
                    $config.$block = @{}
                    $config.$block.Block = $block
                    $config.$block.Txs = Get-CardanoBlockTransactions -Block $block
                    $config.$block.Utxos = @{}
                    $config.$block.Txs.ForEach({
                        $tx = $_
                        $config.$block.Utxos.$tx = Get-CardanoTransactionUtxos -Hash $tx
                    })

                    $config.$block.Que5tGram = [Que5tGram]::new('network')
                    $config.$block.Utxos.GetEnumerator().ForEach({
                        $utxo = $_.value
                        $($utxo.inputs + $utxo.outputs).ForEach({
                            $io = $_
                            $ioAddressShort = $(
                                $io.address -replace '(Ae2|DdzFF|addr1).*(......)$','$1...$2'
                            )
                            $config.$block.Que5tGram.AddUniqueNode(
                                'circle',
                                $io.address,
                                $ioAddressShort
                            )
                        })
                        # TODO: add action logic
                    })
                })
                return $config
            }
        }
    }
}

function New-Que5tGramRenderings {
    Write-Output TODO
}
