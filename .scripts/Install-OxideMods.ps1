param(
    [string]$ServerPath
)

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

$PluginsPath = Join-Path -Path $ServerPath -ChildPath "oxide/plugins"
$ServerManifestPath = Join-Path -Path $PluginsPath -ChildPath "plugins.manifest.json"

$manifest = Get-Content -Path $ServerManifestPath | ConvertFrom-Json

foreach($plugin in $manifest.PluginMetadata)
{
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
    }

    Start-Sleep -Seconds 10
}