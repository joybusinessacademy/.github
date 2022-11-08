Clear-Host

$projPath = args[0]

Write-Host "Updating project version"

$projPath = Get-Item -Path $projPath -Filter *.csproj
$filePath = $projPath.FullName

[ValidateNotNull]
[ValidatePattern("^v?[1-9]+\.\d+\.\d+(\.\d+)?$")]
$version = args[1]

if ($version.Substring(0, 1) -eq "v") {
    $version = $version.Substring(1)
}

$xml = New-Object XML
$xml.Load($filePath)

$versionNode = $xml.Project.PropertyGroup.Version
if ($null -eq $versionNode) {
    $versionNode = $xml.CreateElement("Version")
    $xml.Project.PropertyGroup.AppendChild($versionNode)
}

$xml.Project.PropertyGroup.Version = $version
$xml.Save($filePath)

Write-Host "Updated project " + $filePath + " version to " + $version