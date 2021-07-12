param (
    [string]$ServerManifestPath,
    [string]$PluginsPath = "G:\Rust\Server\The Rusty Bear\oxide\plugins",
    [string]$ServerBasePath = "G:\Rust"
)

$tempFile = New-TemporaryFile

Invoke-WebRequest -Uri "https://umod.org/games/rust/download?tag=public" -OutFile $tempFile.FullName

Expand-Archive -Path $tempFile.FullName -DestinationPath $ServerBasePath -Force -Confirm:$false

Remove-Item -Path $tempFile.FullName -Force -Confirm:$false

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
}