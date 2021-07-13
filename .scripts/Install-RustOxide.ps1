param (
    [string]$ServerBasePath = "G:\Rust"
)

$tempFile = Join-Path -Path $Env:TEMP -ChildPath "RustOxide.zip"

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

Invoke-WebRequest -Uri "https://umod.org/games/rust/download?tag=public" -OutFile $tempFile 

Expand-Archive -Path $tempFile -DestinationPath $ServerBasePath -Force -Confirm:$false

Remove-Item -Path $tempFile -Force