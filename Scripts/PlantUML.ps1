function Invoke-PlantUML {
    java -jar "$env:PLANTUML_HOME\plantuml.jar" @args
}

Set-Alias -Name plantuml -Value Invoke-PlantUML
