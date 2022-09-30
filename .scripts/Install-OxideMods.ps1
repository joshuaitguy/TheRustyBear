param(
    [string]$ResourcesPath,
    [string]$ServerPath,
    [int]$BackoffSeconds = 60
)



[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

$PluginsPath = Join-Path -Path $ServerPath -ChildPath "oxide/plugins"
$ServerManifestPath = Join-Path -Path "$($ResourcesPath)/oxide/plugins" -ChildPath "plugins.manifest.json"

$manifest = Get-Content -Path $ServerManifestPath | ConvertFrom-Json

$pCount = 1
$pTotal = $manifest.PluginMetadata | Measure-Object | Select-Object -ExpandProperty count

$isPsCore = $PSVersionTable.PSVersion -gt "7.0"

if($isPsCore)
{
  [int]$Global:modCount = $pTotal
  $manifest.PluginMetadata | ForEach-Object -Parallel {
    if($null -eq $_.Enabled)
    {
      $enabled = $false
    }
    else
    {
      $enabled = $_.Enabled
    }

    $fileName = Split-Path -Path $_.DownloadUrl -Leaf
    $OutputFileFullName = (Join-Path -Path $Using:PluginsPath -ChildPath $fileName)

    if($enabled)
    {
      $WasSuccessful = $false

      do
      {
        try
        {
          Write-Host "Downloading File: $fileName"
          Invoke-WebRequest -Uri $_.DownloadUrl -OutFile $OutputFileFullName
          [System.Threading.Interlocked]::Decrement([ref] $Global:modCount) | Out-Null
          Write-Host "Compleated Download of File: $fileName; $Global:modCount mods remaining"
          $WasSuccessful = $true
        }
        catch
        {
          if($_.Exception.Response.StatusCode -eq 429)
          {
            Write-Warning "Recived Backoff Requst for File: $fileName. Sleeping download for $Using:BackoffSeconds seconds."
            Start-Sleep -Seconds $Using:BackoffSeconds
          }
          else
          {
            Write-Warning "Encountered exception of type: $($_.Exception.GetType().Name) with the following message: $($_.Exception.Message)."
            break;
          }
        }
      }while($WasSuccessful -eq $true)
    }
    elseif($(Test-Path -Path $OutputFileFullName))
    {
      Remove-Item -Path $OutputFileFullName
    }
  } 
}
else
{
  foreach($plugin in $manifest.PluginMetadata)
  {
    Write-Host "Processing mod $pCount of $($pTotal): " -NoNewline
    $pCount++ | Out-Null

    if($null -eq $plugin.Enabled)
    {
        $enabled = $true
    }
    else
    {
        $enabled = $plugin.Enabled
    }

    if($enabled)
    {
        $fileName = Split-Path -Path $plugin.DownloadUrl -Leaf
        Invoke-WebRequest -Uri $plugin.DownloadUrl -OutFile (Join-Path -Path $PluginsPath -ChildPath $fileName)
        Write-Host "Compleated!" -ForegroundColor Green
        Start-Sleep -Seconds (Get-Random -Minimum 6 -Maximum 15)
    }
  }
}