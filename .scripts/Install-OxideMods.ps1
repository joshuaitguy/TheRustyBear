param(
    [string]$ServerPath
)

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

$PluginsPath = Join-Path -Path $ServerPath -ChildPath "oxide/plugins"
$ServerManifestPath = Join-Path -Path $PluginsPath -ChildPath "plugins.manifest.json"

$manifest = Get-Content -Path $ServerManifestPath | ConvertFrom-Json

$pCount = 1
$pTotal = $manifest.PluginMetadata | Measure-Object | Select-Object -ExpandProperty count

foreach($plugin in $manifest.PluginMetadata)
{
    Write-Host "Processing mod $pCount of $pTotal: " -NoNewline
    $pCount++ | Out-Null

    if($null -eq $plugin.Enabled)
    {
        $shouldProcess = $true
    }
    else
    {
        $shouldProcess = $plugin.Enabled
    }

    if($shouldProcess)
    {
        $fileName = Split-Path -Path $plugin.DownloadUrl -Leaf
        Invoke-WebRequest -Uri $plugin.DownloadUrl -OutFile (Join-Path -Path $PluginsPath -ChildPath $fileName)
        Write-Host "Compleated!" -ForegroundColor Green
        Start-Sleep -Seconds 6
    }
}