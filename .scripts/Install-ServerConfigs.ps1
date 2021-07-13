param(
    [string]$ServerPath,
    [string]$ServerRepoPath
)

New-Item -Path $ServerPath -Name cfg -ItemType Directory | Out-Null
New-Item -Path $ServerPath -Name oxide -ItemType Directory | Out-Null
New-Item -Path "$ServerPath\oxide" -Name config -ItemType Directory | Out-Null
New-Item -Path "$ServerPath\oxide" -Name plugins -ItemType Directory | Out-Null

Get-ChildItem -Path "$ServerRepoPath\*" | Copy-Item -Destination $ServerPath -Force -Recurse -Verbose