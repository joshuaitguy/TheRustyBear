param (
    [string]$ServerBasePath = "G:\Rust"
)

$tempFile = New-TemporaryFile

Invoke-WebRequest -Uri "https://umod.org/games/rust/download?tag=public" -OutFile $tempFile.FullName

Expand-Archive -Path $tempFile.FullName -DestinationPath $ServerBasePath -Force -Confirm:$false

Remove-Item -Path $tempFile.FullName -Force -Confirm:$false